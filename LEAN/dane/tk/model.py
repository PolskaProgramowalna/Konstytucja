"""Model stanów wyboru, tytułu i funkcji (plan_tk.txt, pkt 4.1-4.7, kroki 2-4).

Dla jednej Interpretacji (moduł M1), jednej alternatywy danych A (przyporządkowanie
wyborów do wakatów) i jednego zestawu założeń danych AD model wyznacza:
- dla każdego wyboru: składniki dopuszczalności S2 z powodami, S4, objęcie (S5),
  kadencję, przedział tytułu, stan S8;
- dla każdej osoby: przedziały funkcji (TAK / NIEUSTALONA) zgodnie z T9 i T10;
- dla każdego miejsca pomocniczego: roszczenia (S4) z przedziałami.

Daty niepewne są przedziałami (Chwila). Przynależność niepewnej chwili do
przedziału sprawdza `Przedział.zawiera_chwilę` na całych zakresach. Granice
liczników wyznacza `liczniki()` metodą przedziałową z korelacją na miejscu
pomocniczym; ścisłość i bezpieczeństwo tej metody dla wszystkich przypadków
nie są dowiedzione - to otwarta kontrola F8 (pkt 12 planu).
"""
from __future__ import annotations

import itertools
from dataclasses import dataclass, field

import datetime as _dt

from .daty import (Chwila, Data, Przedział, W3, data, maks, mini, nie_później, plus_lata,
                   przed)
from .parametry import Interpretacja
from .rejestr import Rejestr, Wiersz

T_START = data("2015-10-01")  # wariant T2 (pkt 4.5)
T_END = data("2026-11-17")  # stan zamknięty na koniec 2026-11-16
KADENCJA_LAT = 9  # W1
KWORUM_SEJMU = 230  # art. 120 zd. 2 (W12): połowa ustawowej liczby posłów
_1 = _dt.timedelta(days=1)


@dataclass(frozen=True)
class ZałożeniaDanych:
    """Jawne założenia danych (AD) - nie są parametrami interpretacji Konstytucji.

    Każde zastępuje brakującą daną i jest raportowane. Wyłączenie daje NIEUSTALONE.
    """

    ad1_brak_innych_E6: bool = True  # zdarzenia E6 spoza rejestru nie występują
    ad2_ślubowanie_niespornych: bool = True  # osoby bez E3: ślubowanie wobec Prezydenta
    ad3_dopuszczenie: bool = True  # osoby bez E3 i bez E4: dopuszczenie z dniem ślubowania
    ad4_początek_od_wyboru: bool = True  # brak daty w uchwale: kadencja liczona od wyboru
    ad5_odejście_niespornych: bool = True  # osoby bez sporu: E10 z faktycznym końcem kadencji
    ad6_kompletność_E7: bool = True  # E7 w oknie badania są kompletne
    ad7_brak_funkcji_po_odmowie: bool = True  # E3 bez E4 i bez E5: brak funkcji przed E5

    def opis(self) -> list[tuple[str, str, bool]]:
        return [
            ("AD1", "zdarzenia E6 spoza rejestru nie występują", self.ad1_brak_innych_E6),
            ("AD2", "osoby bez E3 złożyły ślubowanie wobec Prezydenta w dniu wyboru "
                    "albo w dniu początku kadencji z uchwały (późniejszym)", self.ad2_ślubowanie_niespornych),
            ("AD3", "osoby bez E3 i bez E4 zostały dopuszczone do funkcji w dniu ślubowania",
             self.ad3_dopuszczenie),
            ("AD4", "gdy uchwała nie podaje początku kadencji, a dane nie wskazują wakatu, "
                    "faktyczny początek liczony od dnia wyboru", self.ad4_początek_od_wyboru),
            ("AD5", "osoby spoza sporu zakończyły funkcję z faktycznym końcem kadencji, "
                    "jeżeli brak E5 po tym dniu", self.ad5_odejście_niespornych),
            ("AD6", "postanowienia E7 w oknie badania są w rejestrze kompletne", self.ad6_kompletność_E7),
            ("AD7", "osoby z E3 (odmowa przyjęcia ślubowania), bez E4, nie wykonywały funkcji przed "
                    "pierwszym udokumentowanym E5", self.ad7_brak_funkcji_po_odmowie),
        ]


@dataclass
class Wybór:
    osoba: str
    wiersz: Wiersz
    miejsce: str | None  # identyfikator miejsca pomocniczego; None = nieustalone
    poprzednik: str | None
    korzeń: bool
    f: Chwila | None = None  # pierwszy dzień zamierzonego wakatu
    s2: W3 = W3.NIEUST
    powody: dict[str, W3] = field(default_factory=dict)
    s4: Chwila | None = None
    s4_status: W3 = W3.NIE
    s5: Chwila | None = None
    s5_status: W3 = W3.NIE
    początek: Chwila | None = None
    koniec: Chwila | None = None  # koniec kadencji (pierwszy dzień po)
    koniec_roszczenia: Chwila | None = None
    s8: W3 = W3.NIE
    tytuł: list[tuple[Przedział, W3]] = field(default_factory=list)
    funkcja: list[tuple[Przedział, W3]] = field(default_factory=list)
    sporna: bool = False
    konwalidacja: bool = False
    uwagi: list[str] = field(default_factory=list)

    def ma_tytuł(self, t: Data) -> W3:
        wynik = W3.NIE
        for p, st in self.tytuł:
            wynik = wynik | (p.zawiera(t) & st)
        return wynik

    def w_funkcji(self, t: Data) -> W3:
        wynik = W3.NIE
        for p, st in self.funkcja:
            wynik = wynik | (p.zawiera(t) & st)
        return wynik


@dataclass
class Stan:
    """Wynik modelu dla (Interpretacja, alternatywa A, AD)."""

    interpretacja: Interpretacja
    alternatywa: dict[str, str | None]
    wybory: dict[str, Wybór]
    miejsca: list[str]

    def daty_zmian(self) -> list[Data]:
        ds = {T_START}
        for w in self.wybory.values():
            for p, _ in w.tytuł + w.funkcja:
                ds.update(d for d in p.granice() if d is not None)
            for k in ("s4", "koniec_roszczenia"):
                c = getattr(w, k)
                if c is not None:
                    ds.add(c.lo)
                    if c.hi:
                        ds.add(c.hi)
        return sorted(d for d in ds if T_START <= d < T_END)


# --- Alternatywy danych (krok 2) -------------------------------------------------------

def alternatywy(rej: Rejestr) -> list[dict[str, str | None]]:
    """Wszystkie dopuszczalne przyporządkowania wyborów do zamierzonych wakatów (4.1).

    Ograniczenia: wybory z tej samej `grupa` dostają różne wakaty; `wspolny_wakat=x`
    wiąże wybór z wakatem osoby x. Alternatywy różniące się tylko permutacją wakatów
    nierozróżnialnych (ten sam poprzednik-korzeń z tą samą datą początku i bez
    zdarzeń osobowych) są utożsamiane.
    """
    wybory = rej.typu("E1")
    wybory_lista = [w for w in wybory if w.wakat not in ("", "?") and "|" in w.wakat]
    stałe = {w.osoba: (w.wakat if w.wakat not in ("", "?") else None)
             for w in wybory if w.wakat in ("", "?") or "|" not in w.wakat}
    opcje = [w.wakat.split("|") for w in wybory_lista]
    wyniki: list[dict[str, str | None]] = []
    widziane: set = set()
    for wybór in itertools.product(*opcje):
        przyp = dict(stałe)
        przyp.update({w.osoba: v for w, v in zip(wybory_lista, wybór)})
        if not _spójne(rej, wybory, przyp):
            continue
        kanon = _kanon(rej, przyp)
        if kanon in widziane:
            continue
        widziane.add(kanon)
        wyniki.append(przyp)
    return wyniki


def _spójne(rej: Rejestr, wybory: list[Wiersz], przyp: dict[str, str | None]) -> bool:
    grupy: dict[str, set] = {}
    for w in wybory:
        g = w.a("grupa")
        v = przyp.get(w.osoba)
        if g and v:
            if v in grupy.setdefault(g, set()):
                return False
            grupy[g].add(v)
        x = w.a("wspolny_wakat")
        if x and v and przyp.get(x) != v:
            return False
    return True


def _kanon(rej: Rejestr, przyp: dict[str, str | None]) -> tuple:
    """Utożsamienie permutacji wakatów nierozróżnialnych: zastępujemy identyfikator
    wakatu-korzenia klasą (data początku z uchwały, brak zdarzeń osobowych) i
    numerujemy w kolejności pierwszego użycia."""
    def klasa(wakat: str) -> str:
        o = wakat[2:]
        w = rej.wybór(o)
        if w is None or w.wakat or rej.dla(o, "E2", "E3", "E4", "E4-", "E5", "E6a", "E6b", "E10"):
            return wakat
        return f"klasa:{w.a('poczatek')}:{w.data}"
    numery: dict[str, str] = {}
    out = []
    for osoba in sorted(przyp, key=lambda o: (rej.wybór(o).data, o)):
        v = przyp[osoba]
        if v is None:
            out.append((osoba, None))
            continue
        k = klasa(v)
        if k.startswith("klasa:"):
            numery.setdefault(v, f"{k}#{sum(1 for x in numery if klasa(x) == k)}")
            out.append((osoba, numery[v]))
        else:
            out.append((osoba, v))
    return tuple(out)


# --- Model (krok 3) --------------------------------------------------------------------

def _kadencja_sejmu_do(rej: Rejestr, d: Data) -> Chwila:
    for s in rej.typu("SEJM"):
        do = s.a("do")
        if s.data <= d and (not do or d <= data(do)):
            return Chwila.dokładnie(data(do)) if do else Chwila(T_END, None)
    return Chwila(d, None)


def osoby_sporne(rej: Rejestr) -> set[str]:
    out = {w.osoba for w in rej.typu("E3")}
    for u in rej.typu("UCHWALA_STATUS"):
        out.update(u.lista("dotyczy"))
    for w in rej.typu("E1"):
        if "|" in w.wakat:
            out.add(w.osoba)  # wakat sporny między kilkoma roszczeniami
    return out


def faktyczny_początek(w: Wiersz, ad: ZałożeniaDanych) -> Chwila:
    p = w.a("poczatek")
    if p:
        return Chwila.dokładnie(data(p))
    if ad.ad4_początek_od_wyboru:
        return Chwila.dokładnie(w.data)
    return Chwila(plus_lata(w.data, -1), plus_lata(w.data, 1))


def oblicz(rej: Rejestr, i: Interpretacja, alt: dict[str, str | None],
           ad: ZałożeniaDanych = ZałożeniaDanych()) -> Stan:
    sporni = osoby_sporne(rej)
    wybory: dict[str, Wybór] = {}
    korzenie = [w.osoba for w in rej.typu("E1") if w.wakat == ""]
    miejsca = [f"M.{o}" for o in korzenie]
    # roszczenia na miejscach: miejsce -> lista (osoba, s4, koniec_roszczenia, status)
    roszczenia: dict[str, list[tuple[str, Chwila, Chwila | None, W3]]] = {m: [] for m in miejsca}

    for w in sorted(rej.typu("E1"), key=lambda w: (w.data, w.id)):
        o = w.osoba
        wa = alt.get(o) if w.wakat else None
        korzeń = w.wakat == ""
        poprz = wa[2:] if wa else None
        if korzeń:
            miejsce = f"M.{o}"
        elif poprz and wybory.get(poprz) and wybory[poprz].miejsce:
            miejsce = wybory[poprz].miejsce
        else:
            miejsce = None
        wb = Wybór(osoba=o, wiersz=w, miejsce=miejsce, poprzednik=poprz, korzeń=korzeń,
                   sporna=o in sporni)
        wybory[o] = wb
        _wybór(rej, i, ad, wb, wybory, roszczenia)
        if miejsce is not None and wb.s4 is not None:
            roszczenia[miejsce].append((o, wb.s4, wb.koniec_roszczenia, wb.s4_status))
    for wb in wybory.values():
        _funkcja(rej, ad, wb)
    return Stan(i, alt, wybory, miejsca)


def _zgon_lub_odejście(rej: Rejestr, o: str) -> Chwila | None:
    ws = rej.dla(o, "E6a", "E6b")
    if not ws:
        return None
    c = ws[0].chwila()
    for x in ws[1:]:
        c = mini(c, x.chwila())
    return c


def _zajęty(roszczenia, miejsce: str, chwila: Chwila) -> W3:
    """Czy w chwili `chwila` miejsce jest zajęte przez wcześniejsze roszczenie (S4).

    Niepewna chwila jest badana na całym zakresie (TKI-3)."""
    wynik = W3.NIE
    for _, s4, kon, st in roszczenia.get(miejsce, []):
        wynik = wynik | (Przedział(s4, kon).zawiera_chwilę(chwila) & st)
    return wynik


def _koniec_zajęcia(roszczenia, miejsce: str, chwila: Chwila) -> Chwila | None:
    """Najpóźniejszy koniec roszczeń zajmujących miejsce w danej chwili (T3)."""
    końce = []
    for _, s4, kon, st in roszczenia.get(miejsce, []):
        if Przedział(s4, kon).zawiera_chwilę(chwila) is not W3.NIE:
            końce.append(kon)
    if not końce:
        return None
    if any(k is None for k in końce):
        return Chwila(chwila.lo, None)
    out = końce[0]
    for k in końce[1:]:
        out = maks(out, k)
    return out


def _ślubowanie(rej: Rejestr, ad: ZałożeniaDanych, wb: Wybór) -> tuple[Chwila | None, bool, bool]:
    """(data ślubowania wobec Prezydenta, czy była odmowa E3, czy ślubowanie innej formy)."""
    o = wb.osoba
    e2 = rej.dla(o, "E2")
    wobec = [x for x in e2 if x.a("forma") == "wobec_prezydenta"]
    inna = any(x.a("forma") != "wobec_prezydenta" for x in e2)
    e3 = bool(rej.dla(o, "E3"))
    if wobec:
        c = wobec[0].chwila()
        if wobec[0].pewność == "nieustalone":
            c = Chwila(c.lo, None)
        return c, e3, inna
    if not e3 and ad.ad2_ślubowanie_niespornych and not inna:
        return maks(Chwila.dokładnie(wb.wiersz.data), faktyczny_początek(wb.wiersz, ad)), e3, inna
    return None, e3, inna


def _wybór(rej: Rejestr, i: Interpretacja, ad: ZałożeniaDanych, wb: Wybór,
           wybory: dict[str, Wybór], roszczenia) -> None:
    w = wb.wiersz
    d = Chwila.dokładnie(w.data)
    # f: pierwszy dzień zamierzonego wakatu
    if wb.korzeń:
        wb.f = faktyczny_początek(w, ad)
    elif wb.poprzednik and wb.poprzednik in wybory:
        p = wybory[wb.poprzednik]
        wb.f = p.koniec_roszczenia if p.koniec_roszczenia is not None else (
            p.koniec if p.koniec is not None else None)
        if wb.f is None:
            # poprzednik bez roszczenia (np. wybór nieskuteczny): wakat po jego faktycznej
            # kadencji albo zgonie
            fk = faktyczny_początek(p.wiersz, ad).plus_lata(KADENCJA_LAT)
            zg = _zgon_lub_odejście(rej, p.osoba)
            wb.f = mini(fk, zg) if zg else fk
    else:
        wb.f = None
    # S2: składniki (krok 5)
    pow = wb.powody
    if wb.korzeń:
        pow["stan_wyjściowy"] = W3.TAK
    else:
        pow["tryb"] = _tryb(i, w)
        g = w.a("glosowanie", "nieustalone")
        pow["indywidualność"] = W3.TAK if g in ("odrebne", "lista") else W3.NIEUST
        if wb.f is None or wb.miejsce is None:
            pow["wakat_nieustalony"] = W3.TAK
            pow["wyprzedzający"] = W3.NIEUST
            pow["zajęty"] = W3.NIEUST
        else:
            if i.z7 == "a":
                ok7 = nie_później(wb.f, d)
            elif i.z7 == "b":
                ok7 = nie_później(wb.f, _kadencja_sejmu_do(rej, w.data))
            else:
                ok7 = W3.TAK
            pow["wyprzedzający"] = ~ok7
            pow["zajęty"] = _zajęty(roszczenia, wb.miejsce, maks(wb.f, d))
    wb.s2 = W3.TAK
    for k, v in pow.items():
        if k in ("tryb", "indywidualność", "stan_wyjściowy"):
            wb.s2 = wb.s2 & v
        elif k == "wakat_nieustalony":
            wb.s2 = wb.s2 & W3.NIEUST
        else:
            wb.s2 = wb.s2 & ~v
    # S4 (T2-T5)
    zg = _zgon_lub_odejście(rej, wb.osoba)
    if wb.korzeń:
        wb.s4, wb.s4_status = wb.f, W3.TAK
    elif wb.s2 is W3.TAK:
        wb.s4, wb.s4_status = maks(wb.f, d), W3.TAK
    elif wb.s2 is W3.NIEUST:
        baza = maks(wb.f, d) if wb.f is not None else d
        wb.s4, wb.s4_status = (Chwila(baza.lo, None) if i.z4 != "a" else baza), W3.NIEUST
    else:
        twarde = pow.get("tryb") is W3.NIE or pow.get("indywidualność") is W3.NIE
        zajęty = pow.get("zajęty") is W3.TAK
        wyprz = pow.get("wyprzedzający") is W3.TAK
        if twarde or i.z4 == "a" or (wyprz and i.z4 != "bR2"):
            wb.s4 = None  # T5 albo brak konwalidacji
        else:
            start = maks(wb.f, d)
            if zajęty:
                kz = _koniec_zajęcia(roszczenia, wb.miejsce, maks(wb.f, d))
                start = maks(start, kz) if kz is not None else start
            wb.s4, wb.s4_status = start, W3.TAK
            wb.konwalidacja = True
            if zajęty:
                wb.uwagi.append("T3: skuteczność z dniem zwolnienia wakatu (Z4b)")
            if wyprz:
                wb.uwagi.append("T4: skuteczność z dniem powstania wakatu (Z4b, R2)")
    if wb.s4 is None:
        wb.s4_status = W3.NIE
        return
    # S5 (T6) według Z1
    x, e3, inna = _ślubowanie(rej, ad, wb)
    T = i.fikcja_T
    if i.z1 == "a":
        wb.s5, wb.s5_status = wb.s4, wb.s4_status
    elif i.z1 == "b":
        if x is not None:
            wb.s5, wb.s5_status = maks(wb.s4, x), wb.s4_status
        elif e3:
            wb.s5, wb.s5_status = None, W3.NIE
        else:
            wb.s5, wb.s5_status = Chwila(wb.s4.lo, None), W3.NIEUST
    elif i.z1 == "c":
        if x is not None:
            wb.s5, wb.s5_status = maks(wb.s4, x), wb.s4_status
        else:
            wb.s5, wb.s5_status = wb.s4, W3.NIEUST  # tytuł nieustalony do ślubowania
    else:
        fikcja = wb.s4.plus_dni(T)
        wb.s5 = mini(maks(wb.s4, x), fikcja) if x is not None else fikcja
        wb.s5_status = wb.s4_status
    # Kadencja (Z2) i T8. Według Z2a kadencja biegnie od dnia wakatu; przy konwalidacji
    # (T3/T4) - od dnia, w którym wakat stał się wolny dla tego wyboru.
    start_a = wb.s4 if (wb.konwalidacja or wb.f is None) else wb.f
    koniec_a = start_a.plus_lata(KADENCJA_LAT)
    wb.początek = wb.s5 if (i.z2 == "b" and wb.s5 is not None) else start_a
    wb.koniec = wb.początek.plus_lata(KADENCJA_LAT)
    # T8: objęcie musi nastąpić przed końcem kadencji liczonej według Z2a.
    wb.s8 = W3.TAK if wb.s5 is None else ~przed(wb.s5, koniec_a)
    # Roszczenie (S4) zajmuje wakat do końca kadencji: według Z2, gdy nastąpiło objęcie,
    # a w przeciwnym razie według Z2a (T7, T8).
    kon_kad = wb.koniec if (wb.s5 is not None and i.z2 == "b") else koniec_a
    wb.koniec_roszczenia = mini(kon_kad, zg) if zg else kon_kad
    if wb.s5 is not None and wb.s8 is not W3.TAK:
        st = wb.s5_status if wb.s8 is W3.NIE else W3.NIEUST
        kon = mini(wb.koniec, zg) if zg else wb.koniec
        wb.tytuł.append((Przedział(wb.s5, kon), st))
    if zg is None and not ad.ad1_brak_innych_E6:
        wb.tytuł = [(p, W3.NIEUST) for p, _ in wb.tytuł]


def _tryb(i: Interpretacja, w: Wiersz) -> W3:
    """Z12: kworum i większość przy wyborze (W12)."""
    if i.z12 == "b":
        return W3.NIEUST  # reguła ustawy/regulaminu (D11) nie jest jeszcze wczytana
    lista = w.a("lista")
    if lista:
        a, b = (int(x) for x in lista.split("/"))
        return W3.TAK if a + b >= KWORUM_SEJMU and a > b else W3.NIE
    if not w.a("za"):
        return W3.NIEUST
    za, przeciw, wstrz = int(w.a("za")), int(w.a("przeciw")), int(w.a("wstrz", "0"))
    return W3.TAK if za + przeciw + wstrz >= KWORUM_SEJMU and za > przeciw else W3.NIE


def _funkcja(rej: Rejestr, ad: ZałożeniaDanych, wb: Wybór) -> None:
    """Przedziały funkcji według T9 i T10 (tytuł i funkcja to osobne składowe).

    Dopuszczenia (E4) i zakończenia (E4-, E6a, E10) są przetwarzane chronologicznie,
    więc ponowne dopuszczenie otwiera nowy przedział (TKI-5). Brak daty dopuszczenia
    nie jest dowodem braku funkcji: od pierwszego E5 aktywność pozostaje możliwa do
    udokumentowanego zakończenia albo tEnd (TKI-4).
    """
    o = wb.osoba
    e4 = [x.chwila() for x in rej.dla(o, "E4")]
    e3 = rej.dla(o, "E3")
    e5 = sorted(x.data for x in rej.dla(o, "E5"))
    jawne_stopy = [x.chwila() for x in rej.dla(o, "E4-", "E6a", "E10")]
    fakt_koniec = faktyczny_początek(wb.wiersz, ad).plus_lata(KADENCJA_LAT)
    stopy = list(jawne_stopy)
    if not stopy and ad.ad5_odejście_niespornych and not wb.sporna:
        if not any(d >= fakt_koniec.lo for d in e5):
            stopy.append(fakt_koniec)
    starty = list(e4)
    if not starty and not e3 and ad.ad3_dopuszczenie:
        x, _, _ = _ślubowanie(rej, ad, wb)
        if x is None and wb.korzeń:
            x = wb.f
        if x is not None:
            starty.append(x)
    # 1. Przedziały z dopuszczeń i zakończeń (chronologicznie)
    zdarzenia = sorted([(c, 0) for c in starty] + [(c, 1) for c in stopy],
                       key=lambda z: (z[0].lo, z[1]))
    pewne: list[Przedział] = []
    otwarty: Chwila | None = None
    for c, rodzaj in zdarzenia:
        if rodzaj == 0 and otwarty is None:
            otwarty = c
        elif rodzaj == 1 and otwarty is not None:
            pewne.append(Przedział(otwarty, c))
            otwarty = None
    if otwarty is not None:
        pewne.append(Przedział(otwarty, None))
    segmenty: list[tuple[Przedział, W3]] = []
    # 2. Brak dopuszczenia w danych: E5 otwiera możliwą aktywność (TKI-4)
    if not starty:
        pierwszy_e5 = e5[0] if e5 else None
        if e3 and ad.ad7_brak_funkcji_po_odmowie:
            początek_niep = pierwszy_e5
        else:
            początek_niep = wb.wiersz.data  # dopuszczenie nieustalone od dnia wyboru
        if początek_niep is not None:
            koniec = None
            for st in sorted(jawne_stopy, key=lambda c: c.lo):
                if st.lo >= początek_niep:
                    koniec = st
                    break
            segmenty.append((Przedział(Chwila.dokładnie(początek_niep), koniec), W3.NIEUST))
    # 3. T10: po końcu tytułu (albo faktycznym końcu kadencji) aktywność nieustalona
    koniec_t = wb.tytuł[-1][0].do if wb.tytuł else fakt_koniec
    for p in pewne:
        if koniec_t is None or (p.do is not None and nie_później(p.do, koniec_t) is W3.TAK):
            segmenty.append((p, W3.TAK))
            continue
        if koniec_t.lo <= p.od.lo:
            segmenty.append((p, W3.NIEUST))
            continue
        segmenty.append((Przedział(p.od, Chwila(koniec_t.lo, koniec_t.lo)), W3.TAK))
        segmenty.append((Przedział(Chwila(koniec_t.lo, koniec_t.lo), p.do), W3.NIEUST))
    # 4. E5 potwierdza aktywność w swoim zakresie
    for d in e5:
        segmenty.append((Przedział(Chwila.dokładnie(d), Chwila.dokładnie(d + _1)), W3.TAK))
    wb.funkcja = segmenty


# --- Liczniki (krok 4) ----------------------------------------------------------------

@dataclass(frozen=True)
class Granice:
    dolna: int
    górna: int

    def __str__(self) -> str:
        return str(self.dolna) if self.dolna == self.górna else f"{self.dolna}-{self.górna}"


def liczniki(stan: Stan, t: Data) -> dict[str, Granice]:
    """Liczniki T, F, B, W, Z, U w dniu t (granice dolna/górna, metoda przedziałowa)."""
    T_lo = T_hi = F_lo = F_hi = B_lo = B_hi = 0
    W_lo = W_hi = Z_lo = Z_hi = U_lo = U_hi = 0
    nieznane_miejsce = 0
    for m in stan.miejsca:
        ws = [w for w in stan.wybory.values() if w.miejsce == m]
        tyt = [w.ma_tytuł(t) for w in ws]
        rosz = [(Przedział(w.s4, w.koniec_roszczenia).zawiera(t) & w.s4_status
                 if w.s4 is not None else W3.NIE) for w in ws]
        if any(x is W3.TAK for x in tyt):
            T_lo += 1
        if any(x is not W3.NIE for x in tyt):
            T_hi += 1
        aktywne_pewne = [r for r in rosz if r is W3.TAK]
        aktywne_moż = [r for r in rosz if r is not W3.NIE]
        if not aktywne_moż:
            W_lo += 1
        if not aktywne_pewne:
            W_hi += 1
        blok = [r is not W3.NIE and ty is not W3.TAK for r, ty in zip(rosz, tyt)]
        blok_pewny = [r is W3.TAK and ty is W3.NIE for r, ty in zip(rosz, tyt)]
        if any(blok_pewny):
            Z_lo += 1
        if any(blok):
            Z_hi += 1
        if len(aktywne_pewne) > 1:
            U_lo += 1
        if len(aktywne_moż) > 1 or any(r is W3.NIEUST for r in rosz):
            U_hi += 1
    for w in stan.wybory.values():
        if w.miejsce is None:
            if w.ma_tytuł(t) is not W3.NIE:
                nieznane_miejsce += 1
        f = w.w_funkcji(t)
        ty = w.ma_tytuł(t)
        if f is W3.TAK:
            F_lo += 1
        if f is not W3.NIE:
            F_hi += 1
        if f is W3.TAK and ty is W3.NIE:
            B_lo += 1
        if f is not W3.NIE and ty is not W3.TAK:
            B_hi += 1
    T_hi = min(15, T_hi + nieznane_miejsce)
    return {"T": Granice(T_lo, T_hi), "F": Granice(F_lo, F_hi), "B": Granice(B_lo, B_hi),
            "W": Granice(W_lo, W_hi), "Z": Granice(Z_lo, Z_hi), "U": Granice(U_lo, U_hi)}
