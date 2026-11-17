#!/usr/bin/env bash
# Pobiera źródła TK/KryzysKonstytucyjny.md. Wymaga bash, python3 >= 3.9 i curl.
# Uruchomienie: ./skrypty/tk_dokumenty.sh [--dry-run] [--force] [--jobs 4]
# Domyślny katalog: dokumenty/TK (ścieżki niezależne od katalogu uruchomienia).
set -euo pipefail

tk_root="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
command -v python3 >/dev/null || { echo 'Brak python3.' >&2; exit 2; }
exec python3 - "$tk_root" "$@" <<'PY'
import argparse
import concurrent.futures
import hashlib
import html
from html.parser import HTMLParser
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unicodedata
import zipfile
from urllib.parse import parse_qs, quote, unquote, urljoin, urlsplit, urlunsplit
from datetime import datetime, timezone


ROOT = Path(sys.argv[1])
if sys.version_info < (3, 9):
    print('Wymagany python3 w wersji co najmniej 3.9.', file=sys.stderr)
    sys.exit(2)
parser = argparse.ArgumentParser(
    prog='tk_dokumenty.sh',
    description='Pobiera dokumenty wskazane w TK/KryzysKonstytucyjny.md.',
    epilog='Kod 0: komplet; 1: błędy pobierania; 2: błąd parametrów. '
           'manifest.json zawiera adresy, statusy i sumy SHA-256; bledy.tsv — błędy. '
           'Ponowne uruchomienie pomija poprawnie zapisane pliki i ponawia błędy. '
           'Pliki D1/D2 są kopiowane, bez pobierania wszystkich ich przypisów.')
parser.add_argument('--source', type=Path, default=ROOT / 'TK/KryzysKonstytucyjny.md',
                    help='plik źródłowy Markdown')
parser.add_argument('--output', type=Path, default=ROOT / 'dokumenty/TK',
                    help='katalog docelowy')
parser.add_argument('--dry-run', action='store_true',
                    help='wypisz początkową listę bez sieci i zapisywania plików; '
                         'załączniki zostaną rozpoznane dopiero podczas pobierania')
parser.add_argument('--force', action='store_true', help='pobierz ponownie także zapisane pliki')
parser.add_argument('--jobs', type=int, default=4, help='liczba równoległych pobrań (domyślnie 4)')
parser.add_argument('--timeout', type=int, default=45, help='limit sekund pojedynczej próby')
parser.add_argument('--retries', type=int, default=2, help='liczba ponowień po błędzie sieci')
args = parser.parse_args(sys.argv[2:])
if args.jobs < 1 or args.timeout < 1 or args.retries < 0:
    parser.error('--jobs i --timeout muszą być dodatnie, --retries nieujemne')
if not args.source.is_file():
    parser.error(f'Brak pliku źródłowego: {args.source}')
if not args.dry_run and shutil.which('curl') is None:
    parser.error('Brak curl')

source = args.source.resolve()
output = args.output.resolve()
text = source.read_text(encoding='utf-8')
API = 'https://api.sejm.gov.pl/'
jobs = {}


def numbers(value):
    """Rozwija m.in. 1038–1042, 610, 873 oraz 78–79."""
    for match in re.finditer(r'(\d+)(?:[–-](\d+))?', value):
        first = int(match[1])
        last = int(match[2] or first)
        if not first <= last < first + 1000:
            raise ValueError(f'Nieprawidłowy zakres: {match[0]}')
        yield from range(first, last + 1)


def slug(value):
    value = unicodedata.normalize('NFKD', unquote(value)).encode('ascii', 'ignore').decode()
    return re.sub(r'[^A-Za-z0-9._-]+', '_', value).strip('._-')[:100] or 'dokument'


def add(url, path, kind, origin, depth=0):
    key = url
    if key in jobs:
        if origin not in jobs[key]['sources']:
            jobs[key]['sources'].append(origin)
        return
    jobs[key] = dict(url=url, path=path, kind=kind, sources=[origin], depth=depth)


def act(journal, year, pos, origin):
    base = f'eli/acts/{journal}/{year}/{pos}'
    path = f'ELI/{journal}/{year}/{pos}'
    add(API + base, path + '.json', 'json', origin)
    add(API + base + '/text.pdf', path + '.pdf', 'pdf', origin)


def voting(term, sitting, num, origin):
    base = f'sejm/term{term}/votings/{sitting}/{num}'
    path = f'Sejm/kadencja{term}/glosowania/{sitting}/{num}'
    add(API + base, path + '.json', 'json', origin)
    add(API + base + '/pdf', path + '.pdf', 'pdf', origin)


def process(term, num, origin):
    add(API + f'sejm/term{term}/processes/{num}',
        f'Sejm/kadencja{term}/procesy/{num}.json', 'json', origin)
    printing(term, num, origin)


def printing(term, num, origin):
    if not re.fullmatch(r'\d+(?:-[A-Za-z]+)?', str(num)):
        return
    add(API + f'sejm/term{term}/prints/{num}',
        f'Sejm/kadencja{term}/druki/{num}/metryka.json', 'json', origin)


def remote(url, origin, depth=0):
    url = html.unescape(url).rstrip('.,;')
    parts = urlsplit(url)
    if parts.scheme not in ('http', 'https') or not parts.netloc:
        return
    if any(c in url for c in '{}…'):
        return  # Przykłady składni, nie dokumenty.
    url = urlunsplit(parts._replace(fragment=''))
    if parts.hostname in ('api.sejm.gov.pl', 'eli.gov.pl'):
        path = re.sub(r'^/api/', '/', parts.path).lstrip('/')
        match = re.fullmatch(r'eli/acts/(DU|MP)/(\d{4})/(\d+)(?:/text(?:\.pdf|\.html))?', path)
        if match:
            act(*match.groups(), origin)
            return
        match = re.fullmatch(r'sejm/term(\d+)/votings/(\d+)/(\d+)(?:/pdf)?', path)
        if match:
            voting(*match.groups(), origin)
            return
        match = re.fullmatch(r'sejm/term(\d+)/processes/(\d+)', path)
        if match:
            process(*match.groups(), origin)
            return
        match = re.fullmatch(r'sejm/term(\d+)/prints/(\d+(?:-[A-Za-z]+)?)', path)
        if match:
            printing(*match.groups(), origin)
            return
        # Adresy bazowe API i przykłady bez identyfikatora nie są dokumentami.
        if path in ('eli', 'eli/acts', 'sejm'):
            return
    if parts.path in ('', '/') and not parts.query:
        return
    kind = 'html'
    if re.search(r'\.(pdf|docx?|rtf|txt|json)$', parts.path, re.I):
        kind = parts.path.rsplit('.', 1)[1].lower()
    elif parts.path.endswith('/ipo/dok'):
        filename = parse_qs(parts.query).get('dok', [''])[0]
        extension = Path(filename).suffix.lstrip('.').lower()
        kind = extension if extension in ('pdf', 'doc', 'docx', 'rtf', 'txt') else 'pdf'
    elif parts.path.endswith('/downloadOTK'):
        kind = 'pdf'
    host = parts.hostname or ''
    category = ('TK/IPO' if host == 'ipo.trybunal.gov.pl' else
                'TK/www' if host.endswith('trybunal.gov.pl') else
                'KPRP' if host.endswith('prezydent.pl') else
                'Komisja_Wenecka' if host.endswith('coe.int') else
                'Sejm/strony' if host.endswith('sejm.gov.pl') else 'Inne')
    basename = slug(Path(parts.path).name or host)
    digest = hashlib.sha256(url.encode()).hexdigest()[:12]
    add(url, f'{category}/{basename}-{digest}.{kind}', kind, origin, depth)


def discover():
    # Identyfikatory ELI występują również poza odnośnikami.
    sequence = r'\d+(?:[–-]\d+)?(?:,\s*\d+(?:[–-]\d+)?)*'
    for match in re.finditer(r'\b(DU|MP)/(\d{4})/(' + sequence + ')', text):
        for pos in numbers(match[3]):
            act(match[1], match[2], pos, match[0])
    for match in re.finditer(r'(Dz\.\s*U\.|M\.\s*P\.)\s*(\d{4})\s+poz\.\s*(' + sequence + ')', text):
        for pos in numbers(match[3]):
            act('DU' if match[1].startswith('Dz') else 'MP', match[2], pos, match[0])
    for match in re.finditer(r'\bterm(\d+)/(\d+)\b', text):
        process(match[1], match[2], match[0])
    # Rozwinięcie skrótów typu „VIII kadencja: ... druk 122 — …/122”.
    section = ''
    for line in text.splitlines():
        if line.startswith('### '):
            section = line
        term = 8 if re.search(r'(?<!\w)VIII kadencj', line) else 10 if re.search(r'(?<!\w)X kadencj', line) else None
        if term and 'procesy legislacyjne' in section:
            for match in re.finditer(r'druk\s+(\d+)', line):
                process(term, match[1], line)
        if term and 'głosowania' in section:
            for match in re.finditer(r'(\d+)/(\d+(?:[–-]\d+)?)', line):
                for num in numbers(match[2]):
                    voting(term, match[1], num, line)
    # Druki wymienione wprost, także zakres 42–46; kadencja z tego samego akapitu.
    for block in re.split(r'\n\s*\n', text):
        terms = set(re.findall(r'term(\d+)', block))
        if len(terms) == 1:
            term = next(iter(terms))
            for match in re.finditer(r'druki?\s+(?:nr\s+)?(' + sequence + r'(?:\s+i\s+\d+)?)', block):
                for num in numbers(match[1]):
                    printing(term, num, match[0])
    # Rozwija także adresy „…/591”, „…/2147” i „…/MP/2020/1104”.
    for line in text.splitlines():
        previous_url = None
        for match in re.finditer(r'https?://[^\s<>`"|)]+|…/(?:DU/|MP/)?\d+(?:/\d+)*', line):
            url = match[0].rstrip('.,;')
            if url.startswith('…/'):
                if previous_url is None:
                    continue
                suffix = url[2:]
                if suffix.startswith(('DU/', 'MP/')) and '/eli/acts/' in previous_url:
                    url = previous_url.split('/eli/acts/')[0] + '/eli/acts/' + suffix
                else:
                    url = previous_url.rsplit('/', 1)[0] + '/' + suffix
            previous_url = url
            remote(url, line)
    # Roczniki są zbiorem metadanych; nie pobieramy PDF wszystkich ustaw w roczniku.
    for match in re.finditer(r'roczniki[^\n]*?za lata (\d{4})[–-](\d{4})', text):
        for year in range(int(match[1]), int(match[2]) + 1):
            for journal in ('DU', 'MP'):
                add(API + f'eli/acts/{journal}/{year}',
                    f'ELI/roczniki/{journal}-{year}.json', 'json', match[0])
    # Kopie lokalne, bez rekurencji do kilkuset przypisów D1/D2.
    local = {source}
    for path in re.findall(r'`((?:Senat|TK)/[^`]+\.(?:txt|md))`', text):
        local.add(ROOT / path)
    for path in re.findall(r'\]\(([^)#]+\.(?:md|txt))(?:#[^)]*)?\)', text):
        local.add((source.parent / path).resolve())
    for path in sorted(local):
        path = path.resolve()
        if not path.is_relative_to(ROOT) and path != source:
            continue
        relative = path.relative_to(ROOT) if path.is_relative_to(ROOT) else Path(path.name)
        add(path.as_uri(), 'lokalne/' + str(relative), 'local', str(source))


def validate(path, kind, url):
    data = path.read_bytes()
    if not data:
        raise ValueError('pusta odpowiedź')
    if kind == 'pdf' and not data.lstrip().startswith(b'%PDF-'):
        raise ValueError('odpowiedź nie jest PDF (możliwa blokada dostępu)')
    if kind == 'docx':
        try:
            with zipfile.ZipFile(path) as document:
                if 'word/document.xml' not in document.namelist():
                    raise ValueError('odpowiedź nie jest dokumentem Word DOCX')
        except zipfile.BadZipFile:
            raise ValueError('odpowiedź nie jest plikiem DOCX (możliwa blokada dostępu)')
    if kind == 'json':
        obj = json.loads(data)
        if isinstance(obj, dict) and ('error' in obj or ('message' in obj and 'items' not in obj)):
            raise ValueError('API zwróciło komunikat błędu zamiast dokumentu')
    if kind == 'html':
        sample = data[:131072].decode('utf-8', errors='replace').lower()
        markers = ('please enable javascript to view the page content',
                   '<title>just a moment', '<title>request rejected',
                   '<title>attention required', 'cf-chl-', 'the requested url was rejected')
        if any(marker in sample for marker in markers):
            raise ValueError('strona blokady dostępu zamiast dokumentu')
        query = parse_qs(urlsplit(url).query)
        if urlsplit(url).hostname == 'ipo.trybunal.gov.pl' and query.get('sygnatura'):
            visible = html.unescape(re.sub(r'<[^>]+>', ' ', sample))
            signature = re.sub(r'\s+', '', query['sygnatura'][0]).lower()
            if not re.search(r'(?:metryka|sygnatura)\s*' + re.escape(signature), re.sub(r'\s+', '', visible)):
                raise ValueError('IPO nie zwróciło metryki żądanej sprawy')
    return data


def fetch(job, previous):
    result = dict(job)
    target = output / job['path']
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        old = previous.get(job['url'], {})
        if target.is_file() and not args.force and job['kind'] != 'local':
            try:
                data = validate(target, job['kind'], job['url'])
                checksum = hashlib.sha256(data).hexdigest()
                if (old.get('status') != 'error' and old.get('sha256') == checksum
                        and old.get('path') == job['path']):
                    result.update(status='cached', sha256=checksum, bytes=len(data),
                                  final_url=old.get('final_url', job['url']))
                    return result
            except (OSError, ValueError):
                pass  # Uszkodzony plik wymaga ponownego pobrania.
        with tempfile.NamedTemporaryFile(dir=target.parent, suffix='.part', delete=False) as handle:
            temporary = Path(handle.name)
        if job['kind'] == 'local':
            shutil.copyfile(unquote(urlsplit(job['url']).path), temporary)
            final_url = job['url']
        else:
            command = ['curl', '--fail', '--location', '--silent', '--show-error',
                       '--proto', '=https,http', '--proto-redir', '=https,http',
                       '--connect-timeout', str(min(args.timeout, 15)),
                       '--max-time', str(args.timeout), '--retry', str(args.retries),
                       '--retry-delay', '1', '--retry-max-time', str(args.timeout * (args.retries + 1)),
                       '--user-agent', 'Konstytucja-TK-archiwum/1.0',
                       '--output', str(temporary), '--write-out', '%{url_effective}', job['url']]
            completed = subprocess.run(command, capture_output=True, text=True, check=False)
            if completed.returncode:
                raise ValueError(completed.stderr.strip() or f'curl: kod {completed.returncode}')
            final_url = completed.stdout.strip()
        data = validate(temporary, job['kind'], job['url'])
        os.replace(temporary, target)
        result.update(status='copied' if job['kind'] == 'local' else 'downloaded',
                      sha256=hashlib.sha256(data).hexdigest(), bytes=len(data), final_url=final_url)
    except (OSError, ValueError) as error:
        result.update(status='error', error=str(error))
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)
    return result


class Attachments(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            self.links.extend(value for key, value in attrs if key == 'href' and value)


def expand(result):
    """Tylko załączniki źródeł, bez przechodzenia po nawigacji serwisów."""
    if result['status'] == 'error':
        return
    path = output / result['path']
    match = re.fullmatch(r'https://api\.sejm\.gov\.pl/sejm/term(\d+)/(processes|prints)/(\d+(?:-[A-Za-z]+)?)', result['url'])
    if match:
        term, category, num = match.groups()
        obj = json.loads(path.read_bytes())
        if category == 'prints':
            for attachment in obj.get('attachments', []):
                name = attachment.get('fileName') if isinstance(attachment, dict) else attachment
                if isinstance(name, str):
                    remote(result['url'] + '/' + quote(name, safe=''), result['url'])
        def walk(node):
            if isinstance(node, dict):
                if node.get('printNumber'):
                    printing(term, node['printNumber'], result['url'])
                for key, value in node.items():
                    if key in ('reportFile', 'textAfter3') and isinstance(value, str):
                        remote(value, result['url'])
                    walk(value)
            elif isinstance(node, list):
                for value in node:
                    walk(value)
        walk(obj)
    if result['kind'] == 'html' and result['depth'] == 0:
        page = Attachments()
        page.feed(path.read_text(encoding='utf-8', errors='replace'))
        for href in page.links:
            url = urljoin(result['final_url'], href)
            parts = urlsplit(url)
            # Pełne teksty dokumentów udostępnione na pobranej stronie.
            if re.search(r'\.(pdf|docx?|rtf)$', parts.path, re.I) or parts.path.endswith(('/ipo/dok', '/downloadOTK')):
                host = parts.hostname or ''
                original_host = urlsplit(result['final_url']).hostname or ''
                related = any(host.endswith(domain) and original_host.endswith(domain)
                              for domain in ('.sejm.gov.pl', '.prezydent.pl', '.trybunal.gov.pl', '.coe.int'))
                if host == original_host or related:
                    remote(url, result['url'], depth=1)


def save(results):
    manifest = dict(source=str(source), generated_at=datetime.now(timezone.utc).isoformat(),
                    documents=sorted(results.values(), key=lambda row: row['path']))
    staging = output / 'manifest.json.tmp'
    staging.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    staging.replace(output / 'manifest.json')
    failures = ['plik\turl\tblad']
    for row in manifest['documents']:
        if row['status'] == 'error':
            failures.append('\t'.join(str(row.get(key, '')).replace('\t', ' ').replace('\n', ' ')
                                      for key in ('path', 'url', 'error')))
    (output / 'bledy.tsv').write_text('\n'.join(failures) + '\n', encoding='utf-8')


discover()
if args.dry_run:
    print('typ\tplik\turl')
    for job in sorted(jobs.values(), key=lambda row: row['path']):
        print(f"{job['kind']}\t{job['path']}\t{job['url']}")
    print(f'{len(jobs)} pozycji początkowych; załączniki zostaną dodane podczas pobierania.', file=sys.stderr)
    sys.exit(0)

output.mkdir(parents=True, exist_ok=True)
previous_path = output / 'manifest.json'
previous = {}
if previous_path.is_file():
    try:
        previous = {row['url']: row for row in json.loads(previous_path.read_text())['documents']}
    except (OSError, ValueError, KeyError, TypeError):
        print('Uwaga: nieczytelny stary manifest; pliki zostaną sprawdzone i pobrane ponownie.', file=sys.stderr)
results = {}
try:
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        pending = {}
        while True:
            for url, job in list(jobs.items()):
                if url not in results and url not in pending:
                    pending[url] = pool.submit(fetch, job, previous)
            if not pending:
                break
            finished, _ = concurrent.futures.wait(pending.values(), return_when=concurrent.futures.FIRST_COMPLETED)
            for future in finished:
                row = future.result()
                pending.pop(row['url'])
                results[row['url']] = row
                try:
                    expand(row)
                except (OSError, ValueError, KeyError, TypeError) as error:
                    row.update(status='error', error=f'Odczyt załączników: {error}')
                print(f"[{len(results)}/{len(jobs)}] {row['status']}: {row['path']}", flush=True)
                if row['status'] == 'error':
                    print('  ' + row['error'].replace('\n', ' '), file=sys.stderr, flush=True)
                save(results)
except KeyboardInterrupt:
    save(results)
    print('Przerwano. Ponowne uruchomienie wznowi pobieranie.', file=sys.stderr)
    sys.exit(130)

failed = sum(row['status'] == 'error' for row in results.values())
print(f"Zapisano/sprawdzono {len(results) - failed} plików; błędy: {failed}. Katalog: {output}")
sys.exit(1 if failed else 0)
PY
