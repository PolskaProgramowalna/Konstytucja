"""Rejestr zdarzeń (plan_tk.txt, pkt 4.2 i pkt 6) oraz jego walidator (krok 1, kontrola F2).

Format pliku `tk_rejestr.csv`:
  id, typ, data, osoba, wakat, atrybuty, zrodlo, pewnosc, uwagi
- `wakat` (tylko E1): alternatywy `W.<osoba>` rozdzielone `|`, `?` oznacza wakat
  nieustalony, pusty oznacza miejsce pomocnicze zakładane przez tę osobę (stan wyjściowy).
- `atrybuty`: pary `klucz=wartość` rozdzielone `;`. Wartość `?` oznacza nieustalenie.
- `zrodlo`: identyfikatory dokumentów rozdzielone `;` (ELI:, SEJM-GL:, IPO:, API-SEJM:,
  DOC:, WIKI:).
- `pewnosc`: `ustalone` albo `nieustalone`.
"""
from __future__ import annotations

import csv
import pathlib
import re
from dataclasses import dataclass, field

from .daty import Chwila, Data, data

TYPY = {
    "SEJM": "kadencja Sejmu (D9)",
    "E1": "wybór",
    "E2": "ślubowanie",
    "E3": "odmowa przyjęcia ślubowania lub bezczynność",
    "E4": "dopuszczenie do funkcji",
    "E4-": "cofnięcie dopuszczenia",
    "E5": "udział w orzeczeniu lub inna czynność w funkcji",
    "E6a": "śmierć",
    "E6b": "zrzeczenie, stan spoczynku, wygaśnięcie",
    "E7": "postanowienie Prezydenta o Prezesie, Wiceprezesie lub powierzeniu obowiązków",
    "E8": "uchwała Zgromadzenia Ogólnego",
    "E9": "przejęcie kierowania bez E7",
    "E10": "udokumentowane zaprzestanie funkcji",
    "E10P": "zakończenie funkcji kierowniczej",
    "ORZ": "orzeczenie (D6)",
    "PUB": "zdarzenie publikacyjne O1-O4 (D7)",
    "UCHWALA_STATUS": "uchwała Sejmu o statusie sędziów (D2, dana, nie wzorzec)",
    "OCENA": "ocena interpretacyjna (P11)",
}
WYMAGA_OSOBY = {"E1", "E2", "E3", "E4", "E4-", "E5", "E6a", "E6b", "E7", "E9", "E10", "E10P"}
PREFIKSY_ŹRÓDEŁ = ("ELI:", "SEJM-GL:", "IPO:", "API-SEJM:", "DOC:", "WIKI:")
PEWNOŚCI = {"ustalone", "nieustalone"}


@dataclass
class Wiersz:
    id: str
    typ: str
    data: Data
    osoba: str
    wakat: str
    atrybuty: dict[str, str]
    źródła: list[str]
    pewność: str
    uwagi: str
    nr: int = 0

    def a(self, klucz: str, domyślnie: str | None = None) -> str | None:
        return self.atrybuty.get(klucz, domyślnie)

    def lista(self, klucz: str) -> list[str]:
        v = self.atrybuty.get(klucz)
        if not v or v == "?":
            return []
        return [x for x in v.split("+") if x]

    def chwila(self) -> Chwila:
        """Data zdarzenia; przy pewności `nieustalone` i atrybucie `data_do` - przedział."""
        if self.pewność == "nieustalone":
            do = self.a("data_do")
            od = self.a("data_od")
            lo = data(od) if od else self.data
            return Chwila(lo, data(do) if do else (self.data if od else None))
        return Chwila.dokładnie(self.data)


@dataclass
class Rejestr:
    wiersze: list[Wiersz]
    błędy: list[str] = field(default_factory=list)
    ostrzeżenia: list[str] = field(default_factory=list)

    def typu(self, *typy: str) -> list[Wiersz]:
        return [w for w in self.wiersze if w.typ in typy]

    def osoby(self) -> list[str]:
        return sorted({w.osoba for w in self.typu("E1")})

    def wybór(self, osoba: str) -> Wiersz | None:
        ws = [w for w in self.typu("E1") if w.osoba == osoba]
        return ws[0] if ws else None

    def dla(self, osoba: str, *typy: str) -> list[Wiersz]:
        return sorted((w for w in self.wiersze if w.osoba == osoba and w.typ in typy),
                      key=lambda w: w.data)

    def po_id(self, i: str) -> Wiersz | None:
        for w in self.wiersze:
            if w.id == i:
                return w
        return None


def parsuj_atrybuty(s: str) -> dict[str, str]:
    out: dict[str, str] = {}
    for część in s.split(";"):
        część = część.strip()
        if not część:
            continue
        if "=" not in część:
            raise ValueError(f"atrybut bez '=': {część!r}")
        k, v = część.split("=", 1)
        out[k.strip()] = v.strip()
    return out


def wczytaj(ścieżka: pathlib.Path) -> Rejestr:
    wiersze: list[Wiersz] = []
    błędy: list[str] = []
    with open(ścieżka, encoding="utf8", newline="") as f:
        czytnik = csv.DictReader(f)
        oczekiwane = ["id", "typ", "data", "osoba", "wakat", "atrybuty", "zrodlo", "pewnosc", "uwagi"]
        if czytnik.fieldnames != oczekiwane:
            raise ValueError(f"nagłówek {czytnik.fieldnames} != {oczekiwane}")
        for nr, r in enumerate(czytnik, start=2):
            try:
                wiersze.append(Wiersz(
                    id=r["id"].strip(), typ=r["typ"].strip(), data=data(r["data"].strip()),
                    osoba=r["osoba"].strip(), wakat=r["wakat"].strip(),
                    atrybuty=parsuj_atrybuty(r["atrybuty"]),
                    źródła=[z.strip() for z in r["zrodlo"].split(";") if z.strip()],
                    pewność=r["pewnosc"].strip(), uwagi=r["uwagi"].strip(), nr=nr))
            except (ValueError, KeyError) as e:
                błędy.append(f"wiersz {nr}: {e}")
    rej = Rejestr(wiersze, błędy)
    waliduj(rej)
    return rej


def waliduj(rej: Rejestr) -> None:
    """Krok 1 i kontrola F2: identyfikatory, typy, źródła, osoby, wakaty, spójność."""
    B, O = rej.błędy, rej.ostrzeżenia
    ids: dict[str, int] = {}
    for w in rej.wiersze:
        if w.id in ids:
            B.append(f"{w.id}: identyfikator powtórzony (wiersze {ids[w.id]} i {w.nr})")
        ids[w.id] = w.nr
        if w.typ not in TYPY:
            B.append(f"{w.id}: nieznany typ {w.typ!r}")
        if w.pewność not in PEWNOŚCI:
            B.append(f"{w.id}: pewność {w.pewność!r} spoza {sorted(PEWNOŚCI)}")
        if not w.źródła:
            B.append(f"{w.id}: brak źródła (zasada P5)")
        for z in w.źródła:
            if not z.startswith(PREFIKSY_ŹRÓDEŁ):
                B.append(f"{w.id}: źródło {z!r} bez znanego prefiksu {PREFIKSY_ŹRÓDEŁ}")
        if w.typ in WYMAGA_OSOBY and not w.osoba:
            B.append(f"{w.id}: typ {w.typ} wymaga osoby")
        if w.typ != "E1" and w.wakat:
            B.append(f"{w.id}: pole wakat dozwolone tylko dla E1")
        if not re.fullmatch(r"[a-z0-9_]*", w.osoba):
            B.append(f"{w.id}: identyfikator osoby {w.osoba!r} spoza [a-z0-9_]")
    # Jedna osoba - jeden wybór (brak podwójnego zaliczenia, F2).
    wybrani: dict[str, str] = {}
    for w in rej.typu("E1"):
        if w.osoba in wybrani:
            B.append(f"{w.id}: osoba {w.osoba} ma drugi wybór ({wybrani[w.osoba]}); "
                     "ponowny wybór wymaga osobnej obsługi")
        wybrani[w.osoba] = w.id
    for w in rej.wiersze:
        if w.typ in WYMAGA_OSOBY - {"E1"} and w.osoba and w.osoba not in wybrani:
            B.append(f"{w.id}: osoba {w.osoba} bez zdarzenia E1")
    for w in rej.typu("ORZ", "E8"):
        for klucz in ("sklad", "obecni", "glosujacy", "dotyczy_tytulu", "przepisy_tytulu"):
            for o in w.lista(klucz):
                if o.isdigit():
                    continue  # liczba zamiast listy osób - dana niepełna
                if o not in wybrani:
                    B.append(f"{w.id}: {klucz} zawiera nieznaną osobę {o}")
    # Wakaty: odwołania W.<osoba> muszą wskazywać osobę z E1.
    for w in rej.typu("E1"):
        if w.wakat in ("", "?"):
            continue
        for alt in w.wakat.split("|"):
            if not alt.startswith("W.") or alt[2:] not in wybrani:
                B.append(f"{w.id}: wakat {alt!r} nie wskazuje osoby z E1")
            elif alt[2:] == w.osoba:
                B.append(f"{w.id}: wakat wskazuje własną osobę")
    # Daty uchwał w oknie kadencji Sejmu.
    sejmy = rej.typu("SEJM")
    if not sejmy:
        B.append("brak kadencji Sejmu (D9)")
    for w in rej.typu("E1"):
        if not any(s.data <= w.data and (not s.a("do") or w.data <= data(s.a("do"))) for s in sejmy):
            O.append(f"{w.id}: data wyboru poza znanymi kadencjami Sejmu")
    # Jedno E2 wobec Prezydenta na osobę; odwołania ZO z E7.
    for w in rej.typu("E7"):
        zo = w.a("zo")
        if zo and zo != "?" and not rej.po_id(zo):
            B.append(f"{w.id}: odwołanie do nieistniejącej uchwały ZO {zo}")
    for w in rej.typu("E2"):
        if w.a("forma") not in ("wobec_prezydenta", "sejm", "pisemna"):
            B.append(f"{w.id}: forma ślubowania {w.a('forma')!r} nieznana")
    for w in rej.typu("PUB"):
        if w.a("zdarzenie") not in ("O1", "O2", "O3", "O4"):
            B.append(f"{w.id}: zdarzenie publikacyjne spoza O1-O4")
        if not any(o.a("sprawa") == w.a("sprawa") for o in rej.typu("ORZ")):
            B.append(f"{w.id}: brak orzeczenia {w.a('sprawa')} w rejestrze")
    for w in rej.typu("OCENA"):
        for k in ("warunek", "wynik", "autor", "status", "uzasadnienie"):
            if not w.a(k):
                B.append(f"{w.id}: ocena interpretacyjna bez pola {k} (zasada P11)")


def kompletność(rej: Rejestr) -> dict[str, tuple[int, int]]:
    """Liczba pól ustalonych / wszystkich dla kategorii danych D1-D10."""
    out: dict[str, tuple[int, int]] = {}

    def licz(nazwa: str, pola: list[bool]) -> None:
        out[nazwa] = (sum(pola), len(pola))

    e1 = rej.typu("E1")
    licz("D1 wakat zamierzony", [w.wakat not in ("?",) for w in e1])
    licz("D1 początek kadencji w uchwale", [bool(w.a("poczatek")) for w in e1])
    licz("D1 wynik głosowania", [bool(w.a("za") or w.a("lista")) for w in e1])
    osoby = {w.osoba for w in e1}
    licz("D3 ślubowanie lub odmowa", [bool(rej.dla(o, "E2", "E3")) for o in sorted(osoby)])
    licz("D5 ZO: lista obecnych", [w.a("obecni", "?") != "?" and "+" in w.a("obecni", "")
                                   for w in rej.typu("E8")])
    orz = rej.typu("ORZ")
    licz("D6 skład orzeczenia", [w.a("sklad", "?") != "?" for w in orz])
    licz("D6 wynik głosowania", [w.a("wynik", "?") != "?" for w in orz])
    licz("D10 dopuszczenie (E4) udokumentowane", [bool(rej.dla(o, "E4")) for o in sorted(osoby)])
    return out
