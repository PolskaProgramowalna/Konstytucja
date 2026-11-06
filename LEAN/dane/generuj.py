#!/usr/bin/env python3
"""Etap 1: tekst wzorcowy (Sejm/D19970483Lj.pdf) -> pliki w LEAN/dane.

Uruchomienie z katalogu LEAN/dane: python3 generuj.py
Wymaga pdftotext. Kontrola kończy się błędem, gdy tekst różni się od wydania
Senatu czymkolwiek poza znaną różnicą w art. 228 ust. 7.
"""
import collections
import csv
import difflib
import pathlib
import re
import subprocess
import unicodedata

TU = pathlib.Path(__file__).resolve().parent
REPO = TU.parent.parent
PDF = REPO / "Sejm/D19970483Lj.pdf"
SENAT = REPO / "Senat/konstytucja_rp_miniatura_w._polska.txt"
MALE = "a-ząćęłńóśźż"

# Tylko identyfikacja, nie treść prawa: co jest już w Konstytucja/Demo.lean.
SZKIC = {31: "art. 31 ust. 3", 96: "art. 96 ust. 1", 122: "art. 122 ust. 5",
         154: "art. 154", 155: "art. 155", 158: "art. 158 ust. 1",
         230: "art. 230", 235: "art. 235 ust. 4"}
PRIORYTET = {"I": 3, "II": 3, "III": 1, "IV": 1, "V": 1, "VI": 1, "VII": 2,
             "VIII": 2, "IX": 2, "X": 2, "XI": 1, "XII": 1, "XIII": 0}
# Lista ręczna: artykuły opisujące przebieg postępowania (patrz plan, etap 3).
PROCEDURY = {79, 98, 118, 119, 120, 121, 122, 123, 125, 127, 128, 129, 131,
             145, 154, 155, 156, 158, 159, 160, 161, 162, 190, 191, 193, 198,
             221, 222, 223, 224, 225, 226, 228, 229, 230, 231, 232, 234, 235}
WZORCE = {
    "próg": r"większoś|ustawowej liczby|co najmniej \d|\d/\d|\b\d+ 000\b|\bskłada się z(e)? \d",
    "termin": r"\b\d+ (dni|godzin|miesi|lat)|\bw ciągu\b|niezwłocznie|nie później|nie wcześniej|kadencj|\w+letni",
    "kompetencja": r"przysługuje|kompetencj|orzeka|rozstrzyga|powołuje|odwołuje|wydaje|sprawuje|zarządza|\bmoże\b.*(Sejm|Senat|Prezydent|Rada Ministrów|Trybunał)|(Sejm|Senat|Prezydent|Rada Ministrów|Trybunał)[^.]*\bmoże\b",
    "odesłanie": r"określa ustawa|określają ustawy|określone w ustawie|określonych w ustaw|(?<!wyrażonej )(?<!wyrażoną )w ustawie|w drodze ustawy|na podstawie ustawy|\bUstawa\b|\bustawa (może|określa)|regulamin",
    "ocenne": r"sprawiedliw|\bgodnoś|rzeteln|sumienn|należyt|dobr(o|em|a) wspóln|dobr\w+ obywateli|\binteres|uzasadnion|konieczn|niezbędn|istot|szczególn|moralnoś|ochron\w+ środowiska|zrównoważon|niewystarczając|odpowiadać stopniowi",
}


def wyodrębnij():
    t = subprocess.run(["pdftotext", "-layout", str(PDF), "-"], check=True,
                       capture_output=True, text=True).stdout
    t = unicodedata.normalize("NFC", t).replace("­", "").replace("\xa0", " ")
    wiersze = []
    for nr, strona in enumerate(t.split("\f"), 1):
        for w in strona.split("\n"):
            s = w.strip()
            if s.startswith("©Kancelaria Sejmu") or s == "2015-01-07":
                continue
            if nr == 1:
                w = w[:85]  # adnotacja "Opracowano na podstawie" na marginesie
            wiersze.append(w.rstrip())
    return wiersze


def dołącz(tekst, s):
    if re.search(rf"[{MALE}]-$", tekst) and re.match(rf"[{MALE}]", s):
        return tekst[:-1] + s
    return f"{tekst} {s}".strip()


def parsuj(wiersze):
    segmenty, nagłówki = [], []  # segmenty: kolejne kawałki tekstu do kontroli
    przepisy = []
    rozdz, tytuł, podrozdz = None, None, ""
    akt = None  # bieżący wiersz przepisy
    art = ust = pkt = 0
    początek = next(i for i, w in enumerate(wiersze) if w.strip() == "z dnia 2 kwietnia 1997 r.")
    segmenty.append(wiersze[początek].strip())
    preambuła = ""
    i = początek + 1
    while not wiersze[i].strip().startswith("Rozdział"):
        s = " ".join(wiersze[i].split())
        if s:
            preambuła = dołącz(preambuła, s)
        i += 1
    segmenty.append(preambuła)
    n = len(wiersze)
    while i < n:
        surowy = wiersze[i]
        s = " ".join(surowy.split())
        i += 1
        if not s:
            continue
        m = re.fullmatch(r"Rozdział ([IVX]+)", s)
        if m:
            rozdz = m.group(1)
            while not wiersze[i].strip():
                i += 1
            tytuł = " ".join(wiersze[i].split())
            i += 1
            podrozdz, akt = "", None
            segmenty += [s, tytuł]
            nagłówki.append((rozdz, tytuł))
            continue
        wcięcie = len(surowy) - len(surowy.lstrip())
        pusty_przed = not wiersze[i - 2].strip()
        pusty_po = i >= n or not wiersze[i].strip()
        if wcięcie >= 14 and pusty_przed and pusty_po and not re.match(r"Art\.|\d", s):
            podrozdz, akt = s, None
            segmenty.append(s)
            continue
        m = re.match(r"Art\. (\d+)\.\s*(.*)", s)
        if m and int(m.group(1)) == art + 1:
            art, ust, pkt = art + 1, 0, 0
            reszta = m.group(2)
            segmenty.append(f"Art. {art}.")
            m1 = re.match(r"1\.\s+(.*)", reszta)
            if m1:
                ust, reszta = 1, m1.group(1)
            akt = dict(rozdział=rozdz, podrozdział=podrozdz, art=art, ust=ust, pkt=0, tekst=reszta)
            przepisy.append(akt)
            continue
        m = re.match(r"(\d+)\.\s+(.*)", s)
        if m and ust and int(m.group(1)) == ust + 1:
            ust, pkt = ust + 1, 0
            akt = dict(rozdział=rozdz, podrozdział=podrozdz, art=art, ust=ust, pkt=0, tekst=m.group(2))
            przepisy.append(akt)
            continue
        m = re.match(r"(\d+)\)\s*(.*)", s)
        if m and int(m.group(1)) == pkt + 1:
            pkt += 1
            akt = dict(rozdział=rozdz, podrozdział=podrozdz, art=art, ust=ust, pkt=pkt, tekst=m.group(2))
            przepisy.append(akt)
            continue
        akt["tekst"] = dołącz(akt["tekst"], s)
    return segmenty, przepisy, preambuła, nagłówki


def tokeny(t):
    return re.findall(r"\w+|[^\w\s]", t)


def senat_tokeny():
    t = unicodedata.normalize("NFC", SENAT.read_text(encoding="utf8")).replace("\f", "\n")
    t = t[t.index("z dnia 2 kwietnia 1997 r."):]
    t = re.sub(rf"(?<=\w)[–-]\s*\d+\s*[–-]\s*\n\s*(?=[{MALE}])", "", t)
    t = re.sub(r"(?m)^\s*[–-]\s*\d+\s*[–-]\s*$", "", t)
    t = re.sub(rf"(?<=[{MALE}])-\n\s*(?=[{MALE}])", "", t)
    return tokeny(t)


def kontrola(segmenty, przepisy, nagłówki):
    numery = sorted({p["art"] for p in przepisy})
    assert numery == list(range(1, 244)), "brak kompletu 243 artykułów"
    assert [r for r, _ in nagłówki] == list(PRIORYTET), "zły zestaw rozdziałów"
    assert max(p["pkt"] for p in przepisy if p["art"] == 144) == 30, "art. 144 ust. 3"
    a = tokeny(" ".join(złóż(segmenty, przepisy)))
    b = senat_tokeny()
    różnice = [o for o in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes() if o[0] != "equal"]
    opis = [(a[i:j], b[k:l]) for _, i, j, k, l in różnice]
    assert opis == [(["przeprowadzane"], ["przeprowadzone"])], f"nieoczekiwane różnice: {opis[:10]}"
    return len(a)


def złóż(segmenty, przepisy):
    """Odtwarza pełny tekst: nagłówki i numery z segmentów, treść z przepisów."""
    wyjście = []
    treść = collections.defaultdict(list)
    for p in przepisy:
        treść[p["art"]].append(p)
    for s in segmenty:
        m = re.fullmatch(r"Art\. (\d+)\.", s)
        wyjście.append(s)
        if m:
            wyjście.append(artykuł(treść[int(m.group(1))]))
    return wyjście


def artykuł(prz):
    części = []
    for p in prz:
        if p["pkt"]:
            części.append(f"{p['pkt']})")
        elif p["ust"]:
            części.append(f"{p['ust']}.")
        części.append(p["tekst"])
    return " ".join(x for x in części if x)


def typy(nr, tekst, rozdz, ma_punkty):
    wynik = [t for t, w in WZORCE.items() if re.search(w, tekst)]
    if nr in PROCEDURY:
        wynik.insert(0, "procedura")
    if ma_punkty:
        wynik.append("wyliczenie")
    if rozdz in ("I", "II"):
        wynik.append("prawo_lub_zasada")
    if rozdz == "XIII":
        wynik = ["przepis_przejściowy"]
    return wynik or ["do_oceny"]


def main():
    segmenty, przepisy, preambuła, nagłówki = parsuj(wyodrębnij())
    liczba = kontrola(segmenty, przepisy, nagłówki)
    arty = collections.defaultdict(list)
    for p in przepisy:
        arty[p["art"]].append(p)
    with open(TU / "artykuly.txt", "w", encoding="utf8") as f:
        f.write(f"Preambuła. {preambuła}\n")
        for nr, prz in arty.items():
            f.write(f"Art. {nr}. {artykuł(prz)}\n")
    with open(TU / "przepisy.csv", "w", encoding="utf8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["rozdział", "podrozdział", "art", "ust", "pkt", "tekst"])
        for p in przepisy:
            w.writerow([p["rozdział"], p["podrozdział"], p["art"], p["ust"], p["pkt"], p["tekst"]])
    licznik = collections.Counter()
    with open(TU / "pokrycie.csv", "w", encoding="utf8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["art", "rozdział", "podrozdział", "liczba_ust", "liczba_pkt", "priorytet",
                    "typy", "status", "plik_lean", "uwagi"])
        for nr, prz in arty.items():
            tekst, rozdz = artykuł(prz), prz[0]["rozdział"]
            tt = typy(nr, tekst, rozdz, any(p["pkt"] for p in prz))
            licznik.update(tt)
            szkic = nr in SZKIC
            w.writerow([nr, rozdz, prz[0]["podrozdział"], max(p["ust"] for p in prz),
                        sum(1 for p in prz if p["pkt"]), PRIORYTET[rozdz], ";".join(tt),
                        "szkic" if szkic else "nie_rozpoczęto",
                        "Konstytucja/Demo.lean" if szkic else "",
                        f"szkic obejmuje {SZKIC[nr]}" if szkic else ""])
    print("tokeny", liczba, "artykuły", len(arty), "wiersze przepisów", len(przepisy))
    print(dict(licznik))


if __name__ == "__main__":
    main()
