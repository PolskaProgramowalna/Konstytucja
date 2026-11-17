"""Przegląd wariantów z grafem zależności (krok 10), klasyfikacja K (pkt 9) i agregacja.

Moduły liczone są przez złączenie: każdy wariant M2 rozszerza wariant M1, a każdy
wariant M3 - wariant M2, więc wspólne parametry mają jedną wartość (pkt 5.1). Wyniki
M3 tablicujemy dla par (odcisk M1, odcisk M2) i 64 rozszerzeń, co jest równoważne
pełnemu przeglądowi, bo krok 7 zależy od M1 i M2 wyłącznie przez te odciski
(warunek kontroli F7 dla implementacji).
"""
from __future__ import annotations

import collections
import itertools
from dataclasses import dataclass, field, replace

from . import oceny
from .daty import W3, Data
from .model import T_END, T_START, Stan, ZałożeniaDanych, alternatywy, liczniki, oblicz
from .parametry import DEP, K4_X, N1, PARAMETRY, Interpretacja, warianty, zmiany
from .rejestr import Rejestr

ROZSZERZENIA_M3 = [p for p in DEP["M3"] if p not in DEP["M2"]]


@dataclass
class Agregat:
    """Dla klucza wyniku: liczba wariantów na wartość i marginesy parametrów."""

    liczby: collections.Counter = field(default_factory=collections.Counter)
    marginesy: dict = field(default_factory=lambda: collections.defaultdict(set))

    def dodaj(self, wartość: str, i: Interpretacja, waga: int = 1, alt: int | None = None):
        self.liczby[wartość] += waga
        for p in PARAMETRY:
            v = getattr(i, p)
            if v is not None:
                self.marginesy[(p, v)].add(wartość)
        if alt is not None:
            self.marginesy[("A", str(alt))].add(wartość)

    def dodaj_zbiorczo(self, liczby: collections.Counter, i: Interpretacja,
                       marginesy_rozszerzeń: dict, alt: int | None = None):
        """Dodanie wyników wszystkich rozszerzeń wariantu `i` naraz (ta sama suma)."""
        self.liczby.update(liczby)
        wartości = set(liczby)
        for p in PARAMETRY:
            v = getattr(i, p)
            if v is not None:
                self.marginesy[(p, v)].update(wartości)
        for k, zb in marginesy_rozszerzeń.items():
            self.marginesy[k].update(zb)
        if alt is not None:
            self.marginesy[("A", str(alt))].update(wartości)

    def jednolity(self) -> bool:
        return len(self.liczby) == 1

    def wpływające(self) -> list[str]:
        """Parametry, których wartości dają różne zbiory wyników (miara marginalna)."""
        po_param = collections.defaultdict(list)
        for (p, v), s in self.marginesy.items():
            po_param[p].append(frozenset(s))
        return sorted(p for p, zb in po_param.items() if len(set(zb)) > 1)


@dataclass
class Wynik:
    agregaty: dict[str, Agregat] = field(default_factory=lambda: collections.defaultdict(Agregat))
    wpływ_dokładny: dict[str, set[str]] = field(default_factory=lambda: collections.defaultdict(set))
    obwiednia: dict[Data, dict[str, tuple[int, int]]] = field(default_factory=dict)
    k_dni: dict[str, dict[Data, set[str]]] = field(default_factory=dict)
    publikacja: list[dict] = field(default_factory=list)
    k4: dict = field(default_factory=lambda: collections.defaultdict(collections.Counter))
    ślad: dict[str, dict] = field(default_factory=dict)  # klucz -> wzorce, źródła, przedziały
    liczba_wariantów: dict[str, int] = field(default_factory=dict)
    alternatywy: list = field(default_factory=list)
    założenia: ZałożeniaDanych = field(default_factory=ZałożeniaDanych)


def wyniki_m1(rej: Rejestr, st: Stan, ślad: dict | None = None) -> dict[str, str]:
    oc = oceny.krok5(rej, st)
    if ślad is not None:
        for o in oc:
            ślad.setdefault(o.klucz, {"wzorce": o.wzorce, "źródła": "; ".join(o.źródła)})
    out = {o.klucz: o.wynik for o in oc}
    for osoba, w in st.wybory.items():
        if w.wiersz.data >= T_START:
            out[f"S4:{osoba}"] = f"{w.s4_status.value} od {w.s4}" if w.s4 else "BRAK"
            out[f"tytuł:{osoba}"] = ("; ".join(f"[{p.od}, {p.do}) {s.value}" for p, s in w.tytuł)
                                     or "BRAK")
            out[f"S8:{osoba}"] = w.s8.value
    return out


def klasyfikacja_dzienna(st: Stan, daty: list[Data]) -> dict[str, dict[Data, str]]:
    """K1-K3 w punktach zmiany (stan obowiązuje do następnego punktu)."""
    out = {"K1": {}, "K2": {}, "K3": {}}
    for t in daty:
        L = liczniki(st, t)
        T, F, B = L["T"], L["F"], L["B"]
        out["K1"][t] = "TAK" if T.górna < 8 else ("NIE" if T.dolna >= 8 else "NIEUSTALONY")
        out["K2"][t] = "TAK" if B.dolna > 0 else ("NIE" if B.górna == 0 else "NIEUSTALONY")
        if F.górna == 0:
            out["K3"][t] = "BRAK OSÓB W FUNKCJI"
        else:
            min_r = B.dolna / F.górna
            max_r = 1.0 if F.dolna == 0 else min(1.0, B.górna / F.dolna)
            out["K3"][t] = "TAK" if min_r >= 1 / 3 else ("NIE" if max_r < 1 / 3 else "NIEUSTALONY")
    return out


def przebieg(rej: Rejestr, ad: ZałożeniaDanych = ZałożeniaDanych(),
             moduły: tuple[str, ...] = ("M1", "M2", "M3"), limit_m1: int | None = None) -> Wynik:
    W = Wynik(założenia=ad)
    alts = alternatywy(rej)
    W.alternatywy = alts
    W.publikacja = oceny.krok8(rej, N1)
    m1 = list(warianty("M1"))[:limit_m1] if limit_m1 else list(warianty("M1"))
    licz = collections.Counter()
    wszystkie_daty: set[Data] = set()
    stany: dict[tuple[int, Interpretacja], Stan] = {}
    for ai, alt in enumerate(alts):
        for i1 in m1:
            st = oblicz(rej, i1, alt, ad)
            stany[(ai, i1)] = st
            wszystkie_daty.update(st.daty_zmian())
    daty = sorted(wszystkie_daty)
    tab_m3: dict = {}
    d6_rok = {int(w.a("rok")): int(w.a("liczba")) for w in rej.typu("D6_ROK")}
    cache_zo: dict = {}
    r1_tab: dict = {}
    for (ai, i1), st in stany.items():
        r1 = wyniki_m1(rej, st, W.ślad)
        r1_tab[(ai, i1)] = r1
        licz["M1"] += 1
        for k, v in r1.items():
            W.agregaty[k].dodaj(v, i1, alt=ai)
        kd = klasyfikacja_dzienna(st, daty)
        for kk, dni in kd.items():
            dd = W.k_dni.setdefault(kk, {})
            for t, v in dni.items():
                dd.setdefault(t, set()).add(v)
        for t in daty:
            L = liczniki(st, t)
            ob = W.obwiednia.setdefault(t, {})
            for k, g in L.items():
                lo, hi = ob.get(k, (g.dolna, g.górna))
                ob[k] = (min(lo, g.dolna), max(hi, g.górna))
        if "M2" not in moduły:
            continue
        orz = [r for r in rej.typu("ORZ") if r.data >= T_START]
        for i2 in warianty("M2", i1):
            kier = oceny.krok6(rej, st, i2, cache_zo)
            licz["M2"] += 1
            for k in kier:
                kk = f"kierownictwo:{k.osoba}:{k.funkcja}:{k.od}"
                W.agregaty[kk].dodaj(k.wynik, i2, alt=ai)
                śl = W.ślad.setdefault(kk, {"wzorce": "W2", "źródła": "", "przedziały": set()})
                śl["przedziały"].add(f"[{k.od}, {k.do or '…'})")
                for o in k.oceny:
                    W.agregaty[f"ocena:{o.klucz}"].dodaj(o.wynik, i2, alt=ai)
                    W.ślad.setdefault(f"ocena:{o.klucz}",
                                      {"wzorce": o.wzorce, "źródła": "; ".join(o.źródła)})
                    if not śl["źródła"]:
                        śl["źródła"] = "; ".join(o.źródła)
            if "M3" not in moduły:
                continue
            # Krok 7 zależy od M2 tylko przez kierującego w dniach orzeczeń (odcisk2);
            # tożsamość wariantu M1 jest częścią klucza, więc tablicowanie jest dokładne.
            odcisk2 = tuple(oceny.kierujący(kier, r.data) for r in orz)
            klucz = (ai, i1, odcisk2)
            if klucz not in tab_m3:
                podsum = collections.defaultdict(collections.Counter)
                marg = collections.defaultdict(lambda: collections.defaultdict(set))
                udział = collections.defaultdict(collections.Counter)  # (rok, X) -> W3 udziału
                for wart in itertools.product(*(PARAMETRY[p][0] for p in ROZSZERZENIA_M3)):
                    i3 = replace(i2, **dict(zip(ROZSZERZENIA_M3, wart)))
                    roczne = collections.defaultdict(lambda: [0, 0, 0])
                    for r, det, łączny in oceny.krok7(rej, st, i3, kier):
                        sprawa = r.a("sprawa")
                        podsum[sprawa][łączny] += 1
                        for p, v in zip(ROZSZERZENIA_M3, wart):
                            marg[sprawa][(p, v)].add(łączny)
                        if r.a("art188") == "tak":
                            rr = roczne[r.data.year]
                            rr[0] += łączny == "WADLIWE"
                            rr[1] += łączny == "NIEUSTALONE"
                            rr[2] += 1
                    for rok in LATA:
                        n_w, n_n, n_r = roczne.get(rok, [0, 0, 0])
                        for x in K4_X:
                            udział[(rok, x)][udział_wadliwych(n_w, n_n, n_r, d6_rok.get(rok), x)] += 1
                tab_m3[klucz] = (podsum, marg, udział)
            podsum, marg, udział = tab_m3[klucz]
            for rok in LATA:
                kw = kierownictwo_naruszone_w_roku(kier, rok)
                for x in K4_X:
                    for wu, n in udział[(rok, x)].items():
                        W.k4[(rok, x)][(kw & wu).value] += n
            licz["M3"] += sum(next(iter(podsum.values())).values()) if podsum else 0
            for sprawa, cnt in podsum.items():
                W.agregaty[f"orzeczenie:{sprawa}"].dodaj_zbiorczo(cnt, i2, marg[sprawa], alt=ai)
    # Wpływ dokładny dla wyników M1: zmiana jednego parametru przy reszcie bez zmian.
    for (ai, i1), r1 in r1_tab.items():
        for p in DEP["M1"]:
            for j in zmiany(i1, p):
                r2 = r1_tab.get((ai, j))
                if r2 is None:
                    continue
                for k, v in r1.items():
                    if r2.get(k) != v:
                        W.wpływ_dokładny[k].add(p)
    W.liczba_wariantów = dict(licz)
    return W


LATA = tuple(range(T_START.year, T_END.year + 1))


def udział_wadliwych(n_w: int, n_n: int, n_rej: int, n_całość: int | None, x: float) -> W3:
    """Czy udział orzeczeń WADLIWYCH w roku jest >= X (granice przy niepewności).

    Bez liczby wszystkich orzeczeń roku (D6_ROK) udział jest NIEUSTALONY. Orzeczenia
    spoza rejestru traktujemy jak nieustalone (mogą być wadliwe albo nie).
    """
    if not n_całość:
        return W3.NIEUST
    brak = max(0, n_całość - n_rej)
    dolna = n_w / n_całość
    górna = (n_w + n_n + brak) / n_całość
    if dolna >= x:
        return W3.TAK
    if górna < x:
        return W3.NIE
    return W3.NIEUST


def kierownictwo_naruszone_w_roku(kier: list, rok: int) -> W3:
    """TAK: w roku jest przedział kierownictwa NARUSZONY; NIE: cały rok (w oknie)
    pokrywają przedziały SPEŁNIONE; w pozostałych przypadkach NIEUSTALONY."""
    import datetime as _dt
    od = max(_dt.date(rok, 1, 1), T_START)
    do = min(_dt.date(rok + 1, 1, 1), T_END)
    seg = [k for k in kier if k.funkcja in ("prezes", "po_prezesa", "kierowanie")
           and k.od < do and (k.do is None or k.do > od)]
    if any(k.wynik == oceny.NARUSZONY for k in seg):
        return W3.TAK
    pokryte = od
    for k in sorted(seg, key=lambda k: k.od):
        if k.wynik != oceny.SPEŁNIONY or k.od > pokryte:
            return W3.NIEUST
        pokryte = max(pokryte, k.do or do)
        if pokryte >= do:
            return W3.NIE
    return W3.NIEUST


def k4(W: Wynik, rej: Rejestr) -> dict[tuple[int, float], str]:
    """K4 rocznie i dla każdego X: rozkład wartości po zbadanych wariantach (pkt 9)."""
    out = {}
    d6 = {int(w.a("rok")) for w in rej.typu("D6_ROK")}
    for (rok, x), cnt in sorted(W.k4.items()):
        opis = "; ".join(f"{v}: {n:,}".replace(",", " ") for v, n in cnt.most_common())
        uwagi = []
        if rok not in d6:
            uwagi.append("brak liczby orzeczeń roku (D6_ROK)")
        if rok == T_END.year:
            uwagi.append("rok niepełny")
        if rok == T_START.year:
            uwagi.append(f"od {T_START}")
        out[(rok, x)] = opis + (f" ({', '.join(uwagi)})" if uwagi else "")
    return out
