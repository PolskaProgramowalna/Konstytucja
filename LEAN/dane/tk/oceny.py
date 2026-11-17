"""Oceny wymogów (plan_tk.txt, kroki 5-8) i niepewność element po elemencie (P10).

Każda ocena zwraca `Ocena` z wynikiem SPEŁNIONY / NARUSZONY / NIEUSTALONY /
NIEPOKRYTY / NIEPRZEWIDZIANE / NIE DOTYCZY, wzorcem (W), założeniami (Z) i źródłem (D).
"""
from __future__ import annotations

import itertools
from dataclasses import dataclass, field

from .daty import Chwila, Data, Przedział, W3, data, plus_lata
from .model import KADENCJA_LAT, T_END, T_START, Stan
from .parametry import Interpretacja
from .rejestr import Rejestr, Wiersz

SPEŁNIONY, NARUSZONY, NIEUSTALONY = "SPEŁNIONY", "NARUSZONY", "NIEUSTALONY"
NIEPOKRYTY, NIEPRZEWIDZIANE, NIE_DOTYCZY = "NIEPOKRYTY", "NIEPRZEWIDZIANE", "NIE DOTYCZY"
WYNIKI_OCENY = {"spelniony": "SPEŁNIONY", "naruszony": "NARUSZONY", "nieustalony": "NIEUSTALONY"}
LIMIT_UZUPEŁNIEŃ = 1 << 16  # powyżej: NIEUSTALONY z adnotacją (bez skrótu, P10)
KADENCJA_PREZESA_USTAWA = 6  # Z5b: art. 10 ust. 2 ustawy z 30.11.2016 (D11, ELI:DU/2016/2072)


@dataclass
class Ocena:
    klucz: str
    wynik: str
    wzorce: str
    założenia: str
    źródła: list[str]
    uwagi: list[str] = field(default_factory=list)


def z_w3(w: W3, naruszenie_gdy: W3 = W3.NIE) -> str:
    """W3 warunku -> wynik oceny (warunek TAK = spełniony)."""
    if w is W3.NIEUST:
        return NIEUSTALONY
    return NARUSZONY if w is naruszenie_gdy else SPEŁNIONY


# --- Krok 5: obsada -------------------------------------------------------------------

def krok5(rej: Rejestr, stan: Stan) -> list[Ocena]:
    out: list[Ocena] = []
    i = stan.interpretacja
    for o, w in sorted(stan.wybory.items(), key=lambda x: (x[1].wiersz.data, x[0])):
        if w.korzeń or w.wiersz.data < T_START:
            continue
        z = f"Z7={i.z7} Z12={i.z12} Z4={i.z4}"
        src = w.wiersz.źródła
        p = w.powody
        out.append(Ocena(f"E1:{o}:tryb", z_w3(p.get("tryb", W3.NIEUST)), "W1 W12", z, src,
                         ["reguła ustawy/regulaminu (D11) nie wczytana"] if i.z12 == "b" else []))
        out.append(Ocena(f"E1:{o}:indywidualność", z_w3(p.get("indywidualność", W3.NIEUST)),
                         "W1", z, src))
        if "wakat_nieustalony" in p:
            out.append(Ocena(f"E1:{o}:wakat", NIEUSTALONY, "W1", z, src,
                             ["dokumenty nie wskazują zamierzonego wakatu (D1)"]))
        else:
            out.append(Ocena(f"E1:{o}:wyprzedzający", z_w3(~p["wyprzedzający"]), "W1 W13", z, src))
            out.append(Ocena(f"E1:{o}:wakat_wolny", z_w3(~p["zajęty"]), "W1", z, src))
        out.append(Ocena(f"E1:{o}:ponowny_wybór", NIEPOKRYTY, "W1", "-", src,
                         ["rejestr nie obejmuje wyborów sprzed 2006 r. (P8)"]))
        out.append(Ocena(f"E1:{o}:wiedza_prawnicza", NIEPOKRYTY, "W1", "-", src,
                         ["kryterium ocenne poza obliczeniem (P8)"]))
        pocz = w.wiersz.a("poczatek")
        if pocz and w.f is not None and w.f.znana and w.f.lo.isoformat() != pocz:
            out.append(Ocena(f"E1:{o}:data_początku_uchwały", NIEUSTALONY, "W1 L2", z, src,
                             [f"uchwała podaje początek {pocz}, a pierwszy dzień wakatu "
                              f"według 4.5 to {w.f.lo.isoformat()} (konwencja przedziałów)"]))
    return out


# --- P10: uzupełnienia niepewnych tytułów ---------------------------------------------

def uzupełnienia(stan: Stan, osoby: list[str], t: Data):
    """Wszystkie wspólnie dopuszczalne uzupełnienia tytułów osób w dniu t.

    Korelacja: na jednym miejscu pomocniczym co najwyżej jedna osoba z tytułem.
    Zwraca generator słowników osoba -> bool; None, gdy przekroczono limit.
    """
    pewne = {o: stan.wybory[o].ma_tytuł(t) for o in osoby if o in stan.wybory}
    niepewne = [o for o, v in pewne.items() if v is W3.NIEUST]
    if (1 << len(niepewne)) > LIMIT_UZUPEŁNIEŃ:
        return None
    zajęte: dict[str, int] = {}
    for o, w in stan.wybory.items():
        if w.miejsce and w.ma_tytuł(t) is W3.TAK:
            zajęte[w.miejsce] = zajęte.get(w.miejsce, 0) + 1

    def gen():
        for bity in itertools.product((False, True), repeat=len(niepewne)):
            u = {o: v is W3.TAK for o, v in pewne.items()}
            u.update(dict(zip(niepewne, bity)))
            licz = dict(zajęte)
            ok = True
            for o, b in zip(niepewne, bity):
                m = stan.wybory[o].miejsce
                if b and m:
                    licz[m] = licz.get(m, 0) + 1
                    if licz[m] > 1:
                        ok = False
                        break
            if ok:
                yield u
    return gen()


def agreguj(wyniki: set[bool]) -> str:
    if wyniki == {True}:
        return SPEŁNIONY
    if wyniki == {False}:
        return NARUSZONY
    return NIEUSTALONY


# --- Krok 6: kierownictwo -------------------------------------------------------------

@dataclass
class Kierownictwo:
    osoba: str
    funkcja: str
    od: Data
    do: Data | None
    wynik: str
    oceny: list[Ocena]


def osoby_z_tytułem_możliwym(stan: Stan, t: Data) -> list[str]:
    return [o for o, w in stan.wybory.items() if w.ma_tytuł(t) is not W3.NIE]


def ocena_zo(rej: Rejestr, stan: Stan, i: Interpretacja, zo: Wiersz,
             kierownictwo: list[Kierownictwo], cache: dict, kandydat: str) -> Ocena:
    """Prawidłowość uchwały ZO (Z3.C, Z3.Q, Z3.M, Z8) z przeglądem uzupełnień (P10)."""
    t = zo.data
    obecni = zo.lista("obecni")
    głosujący = zo.lista("glosujacy")
    głosy = {}
    for para in (zo.a("glosy") or "").split("+"):
        if ":" in para:
            k, v = para.split(":")
            głosy[k] = int(v)
    if not obecni or any(x.isdigit() for x in obecni):
        return Ocena(f"ZO:{zo.id}", NIEUSTALONY, "W2", f"Z3={i.z3c}{i.z3q}{i.z3m} Z8={i.z8}",
                     zo.źródła, ["lista obecnych nieustalona (D5)"])
    wszyscy = osoby_z_tytułem_możliwym(stan, t)
    # Klucz pamięci obejmuje status tytułu ORAZ miejsce pomocnicze każdej osoby, która
    # może mieć tytuł: od miejsc zależą wspólnie dopuszczalne uzupełnienia (TKI-1).
    klucz = (zo.id, kandydat, i.z3c, i.z3q, i.z3m, i.z8, i.z5z, tuple(sorted(
        (o, stan.wybory[o].ma_tytuł(t).value, stan.wybory[o].miejsce or "?")
        for o in set(wszyscy) | set(obecni) if o in stan.wybory)),
        _status_zwołującego(stan, i, zo, kierownictwo))
    if klucz in cache:
        return cache[klucz]
    zwołanie = klucz[-1]
    gen = uzupełnienia(stan, sorted(set(wszyscy) | set(obecni)), t)
    if gen is None:
        wynik = Ocena(f"ZO:{zo.id}", NIEUSTALONY, "W2", "", zo.źródła,
                      ["liczba uzupełnień ponad limit (P10)"])
        cache[klucz] = wynik
        return wynik
    wyniki: set[bool] = set()
    naruszające: list[str] = []
    for u in gen:
        z_tyt = [o for o, b in u.items() if b]
        obecni_t = [o for o in obecni if u.get(o)]
        głos_t = [o for o in głosujący if u.get(o)]
        kworum = (len(obecni_t) >= 8) if i.z3q == "a" else (len(obecni_t) * 2 > len(z_tyt))
        # przydział głosów do głosujących nie jest znany: przegląd wszystkich przydziałów
        ok_większość = set()
        if not głosy or not głosujący:
            # brak danych o głosach nie jest dowodem braku poparcia (TKI-2)
            ok_większość = {True, False}
        for przydział in (_przydziały(głosujący, głosy) if głosy and głosujący else []):
            # Z3.M dotyczy poparcia dla osoby następnie powołanej (kandydat E7)
            v = sum(1 for o, g in przydział.items() if g == kandydat and u.get(o))
            if i.z3m == "a":
                ok = v >= 8
            elif i.z3m == "b":
                ok = v * 2 > len(głos_t)
            else:
                ok = v * 2 > len(obecni_t)
            ok_większość.add(ok)
        bez_tytułu = [o for o in obecni if not u.get(o)]
        z8 = (not bez_tytułu) if i.z8 == "a" else True
        zw = zwołanie in (SPEŁNIONY,) if i.z3c == "a" else True
        if zwołanie == NIEUSTALONY and i.z3c == "a":
            wyniki.update({True, False})
            continue
        for ok in ok_większość:
            r = kworum and ok and z8 and zw
            wyniki.add(r)
            if not r and len(naruszające) < 3:
                naruszające.append(f"tytuł: {sorted(z_tyt)}")
    wynik = Ocena(f"ZO:{zo.id}", agreguj(wyniki), "W2",
                  f"Z3.C={i.z3c} Z3.Q={i.z3q} Z3.M={i.z3m} Z8={i.z8} Z5.Z={i.z5z}", zo.źródła,
                  [f"zwołanie: {zwołanie}",
                   "odrębne głosowanie nad uchwałą (wymóg ustawowy, P2): NIEPOKRYTY"] + (["przykłady uzupełnień z naruszeniem: "
                                                + "; ".join(naruszające)] if naruszające and
                                               agreguj(wyniki) == NIEUSTALONY else []))
    cache[klucz] = wynik
    return wynik


def _przydziały(głosujący: list[str], głosy: dict[str, int]):
    """Wszystkie przydziały głosów (kandydat -> liczba) do konkretnych głosujących."""
    kandydaci = list(głosy)
    if sum(głosy.values()) > len(głosujący):
        raise ValueError("więcej głosów niż głosujących - błąd danych (walidator)")
    pozostali = list(głosujący)

    def rek(idx: int, wolni: list[str], acc: dict):
        if idx == len(kandydaci):
            yield dict(acc)
            return
        k = kandydaci[idx]
        for wybrani in itertools.combinations(wolni, głosy[k]):
            for o in wybrani:
                acc[o] = k
            yield from rek(idx + 1, [o for o in wolni if o not in wybrani], acc)
            for o in wybrani:
                del acc[o]
    yield from rek(0, pozostali, {})


def _status_zwołującego(stan: Stan, i: Interpretacja, zo: Wiersz,
                        kierownictwo: list[Kierownictwo]) -> str:
    kto = zo.a("zwolal")
    if not kto or kto == "?":
        return NIEUSTALONY
    for k in kierownictwo:
        if k.osoba == kto and k.od <= zo.data and (k.do is None or zo.data < k.do):
            if k.funkcja == "prezes":
                return k.wynik
            if k.funkcja == "po_prezesa":
                return NARUSZONY if i.z5z == "a" else (
                    _najdłuższy_staż(stan, kto, zo.data) if i.z5z == "b" else NIEUSTALONY)
            if k.funkcja == "kierowanie":
                return k.wynik
    if i.z5z == "b":
        return _najdłuższy_staż(stan, kto, zo.data)
    return NIEUSTALONY if i.z5z == "c" else NARUSZONY


def _najdłuższy_staż(stan: Stan, osoba: str, t: Data) -> str:
    """Z5.Zb: czy osoba ma tytuł i najdłuższy staż wśród osób z tytułem w dniu t."""
    w = stan.wybory.get(osoba)
    if w is None or w.ma_tytuł(t) is W3.NIE:
        return NARUSZONY
    def start(x):
        for p, st in x.tytuł:
            if p.zawiera(t) is not W3.NIE:
                return p.od
        return None
    mój = start(w)
    pewny = w.ma_tytuł(t) is W3.TAK and mój is not None
    for o, x in stan.wybory.items():
        if o == osoba or x.ma_tytuł(t) is W3.NIE:
            continue
        s = start(x)
        if s is None or mój is None:
            pewny = False
            continue
        if x.ma_tytuł(t) is W3.TAK and s.hi is not None and mój.lo > s.hi:
            return NARUSZONY
        if not (s.lo > (mój.hi or s.lo)):
            pewny = False
    return SPEŁNIONY if pewny else NIEUSTALONY


def krok6(rej: Rejestr, stan: Stan, i: Interpretacja, cache: dict | None = None
          ) -> list[Kierownictwo]:
    cache = {} if cache is None else cache
    akty = sorted(rej.typu("E7", "E9"), key=lambda w: (w.data, w.id))
    końce = {(w.osoba, w.a("funkcja")): w.data for w in rej.typu("E10P")}
    out: list[Kierownictwo] = []
    for a in akty:
        f = a.a("funkcja")
        o = a.osoba
        ws = stan.wybory.get(o)
        od = a.data
        # koniec funkcji: następny akt tej funkcji, E10P, koniec tytułu, Z5
        kier_f = ("prezes", "po_prezesa", "kierowanie")
        nast = [b.data for b in akty if b.data > od and (
            b.a("funkcja") == f or (f in kier_f and b.a("funkcja") in kier_f))]
        do_ = min(nast) if nast else None
        if (o, f) in końce and końce[(o, f)] > od:
            do_ = końce[(o, f)] if do_ is None else min(do_, końce[(o, f)])
        oc: list[Ocena] = []
        if f == "po_prezesa":
            out.append(Kierownictwo(o, f, od, do_, NIEPRZEWIDZIANE, [Ocena(
                f"E7:{a.id}", NIEPRZEWIDZIANE, "W2", "-", a.źródła,
                ["powierzenie obowiązków Prezesa nie ma odpowiednika w art. 194 ust. 2"])]))
            continue
        if f == "kierowanie":  # E9
            tyt = ws.ma_tytuł(od) if ws else W3.NIEUST
            if i.z5z == "a":
                w9 = NARUSZONY if not any(k.funkcja == "wiceprezes" and k.osoba == o for k in out) \
                    else SPEŁNIONY
            elif i.z5z == "b":
                w9 = _najdłuższy_staż(stan, o, od)
            else:
                w9 = NIEUSTALONY
            if tyt is W3.NIE:
                w9 = NARUSZONY
            elif tyt is W3.NIEUST and w9 == SPEŁNIONY:
                w9 = NIEUSTALONY
            oc.append(Ocena(f"E9:{a.id}", w9, "W2", f"Z5.Z={i.z5z} Z1={i.z1}", a.źródła,
                            [f"tytuł osoby przejmującej: {tyt.value}"]))
            out.append(Kierownictwo(o, f, od, do_, w9, oc))
            continue
        # prezes / wiceprezes (E7)
        wyniki: list[str] = []
        zo_id = a.a("zo")
        if f == "prezes":
            zo = rej.po_id(zo_id) if zo_id and zo_id != "?" else None
            if zo is None:
                wyniki.append(NIEUSTALONY)
                oc.append(Ocena(f"E7:{a.id}:a", NIEUSTALONY, "W2", "-", a.źródła,
                                ["brak danych o uchwale ZO (E8)"]))
            else:
                oz = ocena_zo(rej, stan, i, zo, out, cache, o)
                oc.append(oz)
                wyniki.append(oz.wynik)
                kandydat = o in zo.lista("kandydaci")
                oc.append(Ocena(f"E7:{a.id}:c", SPEŁNIONY if kandydat else NARUSZONY, "W2", "-",
                                a.źródła + zo.źródła))
                wyniki.append(SPEŁNIONY if kandydat else NARUSZONY)
        else:
            wyniki.append(NIEUSTALONY)
            oc.append(Ocena(f"E7:{a.id}:a", NIEUSTALONY, "W2", "-", a.źródła,
                            ["brak danych o uchwale ZO dla Wiceprezesa"]))
        tyt = ws.ma_tytuł(od) if ws else W3.NIEUST
        wyniki.append(z_w3(tyt))
        oc.append(Ocena(f"E7:{a.id}:tytuł", z_w3(tyt), "W1 W2", f"Z1={i.z1} Z4={i.z4} Z7={i.z7}",
                        a.źródła))
        if a.pewność == "nieustalone":
            wyniki.append(NIEUSTALONY)
        # (d) okres: Z5
        if ws and ws.tytuł:
            koniec_t = ws.tytuł[-1][0].do
            if koniec_t is not None:
                do_ = koniec_t.lo if do_ is None else min(do_, koniec_t.lo)
        if i.z5 == "b":
            k6 = plus_lata(od, KADENCJA_PREZESA_USTAWA)
            do_ = k6 if do_ is None else min(do_, k6)
        stopy = [x.data for x in rej.dla(o, "E10", "E6a", "E4-") if x.data > od]
        if stopy:
            do_ = min(stopy) if do_ is None else min(do_, min(stopy))
        out.append(Kierownictwo(o, f, od, do_, _łącz(wyniki), oc))
    return out


def _łącz(wyniki: list[str]) -> str:
    if NARUSZONY in wyniki:
        return NARUSZONY
    if NIEUSTALONY in wyniki or NIEPRZEWIDZIANE in wyniki:
        return NIEUSTALONY
    return SPEŁNIONY


def kierujący(kier: list[Kierownictwo], t: Data) -> tuple[str, str]:
    """(osoba, wynik) kierującego TK w dniu t; NIEUSTALONY przy braku danych."""
    cand = [k for k in kier if k.funkcja in ("prezes", "po_prezesa", "kierowanie")
            and k.od <= t and (k.do is None or t < k.do)]
    if not cand:
        return ("?", NIEUSTALONY)
    k = max(cand, key=lambda k: k.od)
    return (k.osoba, k.wynik)


# --- Krok 7: orzeczenia ---------------------------------------------------------------

def krok7(rej: Rejestr, stan: Stan, i: Interpretacja, kier: list[Kierownictwo]
          ) -> list[tuple[Wiersz, dict[str, str], str]]:
    """Dla każdego orzeczenia: wykrycia (a)-(e), skutki i skutek łączny."""
    out = []
    for r in sorted(rej.typu("ORZ"), key=lambda w: w.data):
        if r.data < T_START:
            continue
        t = r.data
        skład = r.lista("sklad")
        det: dict[str, str] = {}
        sk: dict[str, str] = {}
        # (a) członek bez tytułu
        if not skład:
            det["a"] = NIEUSTALONY
        else:
            st = [stan.wybory[o].ma_tytuł(t) if o in stan.wybory else W3.NIEUST for o in skład]
            det["a"] = "TAK" if any(x is W3.NIE for x in st) else (
                "NIE" if all(x is W3.TAK for x in st) else NIEUSTALONY)
        if det["a"] == "NIE":
            sk["a"] = "BEZ WADY"
        elif i.z13 == "a":
            sk["a"] = "WADLIWE" if det["a"] == "TAK" else NIEUSTALONY
        else:  # Z13b: łączne usunięcie wszystkich osób bez tytułu
            wynik = r.a("wynik", "?")
            if wynik == "jednoglosnie" and skład and det["a"] != NIEUSTALONY:
                sk["a"] = _z13b_jednogłośnie(skład, stan, t, i)
            else:
                sk["a"] = NIEUSTALONY
        # (b) wyznaczenie składu
        _, kw = kierujący(kier, t)
        det["b"] = "TAK" if kw == NARUSZONY else ("NIE" if kw == SPEŁNIONY else NIEUSTALONY)
        sk["b"] = ("WADLIWE" if det["b"] == "TAK" else NIEUSTALONY if det["b"] == NIEUSTALONY
                   else "BEZ WADY") if i.z9 == "a" else "BEZ WADY"
        # (c) większość (W6d) - z wyniku głosowania, nie ze zdań odrębnych
        wynik = r.a("wynik", "?")
        det["c"] = "NIE" if wynik in ("jednoglosnie", "wiekszoscia") else NIEUSTALONY
        sk["c"] = "BEZ WADY" if det["c"] == "NIE" else NIEUSTALONY
        # (d) kworum i liczebność (Z11)
        det["d"] = NIEUSTALONY if i.z11 == "a" else NIEPOKRYTY
        sk["d"] = NIEUSTALONY if i.z11 == "a" else NIEPOKRYTY
        # (e) konflikt interesów (Z10)
        własny = set(r.lista("dotyczy_tytulu")) & set(skład)
        przepisy = set(r.lista("przepisy_tytulu")) & set(skład)
        konf = bool(własny) or (i.z10 == "b" and bool(przepisy))
        if not skład:
            det["e"] = NIEUSTALONY
        else:
            det["e"] = "TAK" if konf else "NIE"
        sk["e"] = ("WADLIWE" if i.z14 == "a" else NIEUSTALONY) if det["e"] == "TAK" else (
            NIEUSTALONY if det["e"] == NIEUSTALONY else "BEZ WADY")
        łączny = ("WADLIWE" if "WADLIWE" in sk.values() else
                  "NIEUSTALONE" if NIEUSTALONY in sk.values() else
                  "BEZ WYKRYTEJ WADY")
        out.append((r, {**{f"wykrycie_{k}": v for k, v in det.items()},
                        **{f"skutek_{k}": v for k, v in sk.items()}}, łączny))
    return out


def _z13b_jednogłośnie(skład: list[str], stan: Stan, t: Data, i: Interpretacja) -> str:
    """Z13b przy jednogłośności: po łącznym usunięciu osób bez tytułu sprawdzamy
    większość (W6d) ORAZ kworum (Z11). Bez wczytanej reguły kworum wynik pozostaje
    NIEUSTALONY (Z11a) albo NIEPOKRYTY (Z11b) - TKI-7."""
    gen = uzupełnienia(stan, skład, t)
    if gen is None:
        return NIEUSTALONY
    większość = set()
    for u in gen:
        pozostali = [o for o in skład if u.get(o)]
        większość.add(len(pozostali) >= 1)  # jednogłośnie: pozostali głosowali za
    if większość == {False}:
        return "WADLIWE"
    # większość zachowana (albo niepewna); kworum zależy od reguły Z11, której brak
    return NIEPOKRYTY if (i.z11 == "b" and większość == {True}) else NIEUSTALONY


# --- Krok 8: publikacja (R-PUB) -------------------------------------------------------

def krok8(rej: Rejestr, n1: tuple[int, ...]) -> list[dict]:
    out = []
    for r in sorted(rej.typu("ORZ"), key=lambda w: w.data):
        if r.data < T_START:
            continue
        sprawa = r.a("sprawa")
        zd = [p for p in rej.typu("PUB") if p.a("sprawa") == sprawa]
        o3 = [p for p in zd if p.a("zdarzenie") == "O3"]
        o2 = [p for p in zd if p.a("zdarzenie") == "O2"]
        o1 = [p for p in zd if p.a("zdarzenie") == "O1"]
        ocena = [p for p in rej.typu("OCENA") if p.a("warunek") == f"W6b:{sprawa}"
                 and p.a("status") == "zatwierdzona"]
        rek = {"sprawa": sprawa, "data": r.data, "zdarzenia": [f"{p.a('zdarzenie')} {p.data}"
                                                              for p in zd]}
        if r.a("art188") != "tak":
            rek.update(w6b=NIE_DOTYCZY, czas=None, przekroczenia={}, przyczyna="-",
                       uwagi=["orzeczenie poza art. 188 (np. kontrola prewencyjna)"])
            out.append(rek)
            continue
        ogł = min(p.data for p in o3) if o3 else None
        czas = (ogł - r.data).days if ogł else None
        dolny = (T_END - r.data).days if ogł is None else czas
        rek["czas"] = czas if czas is not None else f">= {dolny} (brak ogłoszenia do końca okna)"
        rek["przekroczenia"] = {n: (dolny > n) for n in n1}
        uwagi = []
        pewne_o2 = [p for p in o2 if p.pewność == "ustalone"]
        if pewne_o2:
            rek["w6b"] = NARUSZONY
            od = min(p.data for p in pewne_o2)
            rek["przedział_naruszenia"] = (od, ogł)
            rek["przyczyna"] = pewne_o2[0].a("organ")
        elif ocena:
            # jawne odwzorowanie; zatwierdzenie oceny nie czyni jej rozstrzygającą (TKI-6)
            rek["w6b"] = WYNIKI_OCENY[ocena[0].a("wynik")]
            rek["przyczyna"] = ocena[0].a("organ", "-") if rek["w6b"] == NARUSZONY else (
                NIEUSTALONY if rek["w6b"] == NIEUSTALONY else "-")
            rek["ocena"] = f"{ocena[0].id} ({ocena[0].a('autor')})"
        else:
            rek["w6b"] = NIEUSTALONY
            rek["przyczyna"] = NIEUSTALONY
            if o2:
                uwagi.append("O2 o pewności nieustalonej - wymaga oceny P11")
            if o1 and not o2:
                uwagi.append("tylko zapowiedź (O1); zapowiedź nie jest odmową wykonaną")
            if not ogł:
                uwagi.append("brak ogłoszenia; sam upływ czasu nie rozstrzyga W6b (R-PUB)")
        rek["w6c"] = (f"wejście w życie z dniem ogłoszenia {ogł}" if ogł
                      else "brak ogłoszenia - orzeczenie nie weszło w życie (opis, nie ocena)")
        rek["uwagi"] = uwagi
        out.append(rek)
    return out
