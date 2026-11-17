"""Raport przygotowawczy (pkt 10, prace możliwe przed zatwierdzeniem parametrów)
i raport wyniku roboczego (pkt 8, tabele A-G, oraz pkt 9)."""
from __future__ import annotations

import collections
import datetime as dt

from . import model, oceny
from .model import ZałożeniaDanych, alternatywy
from .parametry import DEP, PARAMETRY, liczba, liczba_nominalna
from .przebieg import ROZSZERZENIA_M3, Wynik, k4
from .rejestr import Rejestr, kompletność

NAGŁÓWEK_ROBOCZY = (
    "> **WYNIK ROBOCZY.** Parametry Z1–Z14, reguła R-PUB i założenia danych AD1–AD6 mają "
    "status *roboczy* (plan_tk.txt, pkt 5 i 10). Wynik nie jest werdyktem, nie ma mocy "
    "prawnej i znaczy wyłącznie: „przy tych założeniach i danych wynika, że…” (P6).\n")


def _tabela(nagłówki: list[str], wiersze: list[list]) -> str:
    out = ["| " + " | ".join(nagłówki) + " |", "|" + "---|" * len(nagłówki)]
    for w in wiersze:
        out.append("| " + " | ".join(str(x).replace("|", "/") for x in w) + " |")
    return "\n".join(out)


def obserwacje_danych(rej: Rejestr, ad: ZałożeniaDanych) -> list[str]:
    """Ustalenia z danych istotne dla parametrów (bez rozstrzygania)."""
    out = []
    i = model.Interpretacja(z1="a", z2="a", z4="a", z7="c", z12="a")
    alts = alternatywy(rej)
    st = model.oblicz(rej, i, alts[0], ad)
    rozb = []
    for o, w in st.wybory.items():
        p = w.wiersz.a("poczatek")
        if p and not w.korzeń and w.f is not None and w.f.znana and w.f.lo.isoformat() != p:
            rozb.append(f"{o}: uchwała {p}, pierwszy dzień wakatu {w.f.lo}")
    if rozb:
        out.append("Konwencja dat (L2, pkt 4.5): daty początku kadencji w uchwałach Sejmu są o "
                   "jeden dzień późniejsze od pierwszego dnia wakatu liczonego przedziałami "
                   "półotwartymi od daty początku kadencji poprzednika z jego uchwały: "
                   + "; ".join(sorted(rozb)) + ". Praktyka uchwał odpowiada przedziałom "
                   "domkniętym [początek, początek + 9 lat]. Plan (4.5) przyjmuje przedziały "
                   "półotwarte; różnica może mieć znaczenie dla H1 i H5 i wymaga decyzji recenzenta.")
    korz = [w.osoba for w in rej.typu("E1") if w.wakat == ""]
    L = model.liczniki(st, model.T_START)
    out.append(f"Stan wyjściowy (T2): miejsca pomocnicze z wyborów 2006–2012 bez wskazanego "
               f"poprzednika: {len(korz)} ({', '.join(korz)}). W dniu {model.T_START} "
               f"licznik osób w funkcji F = {L['F']}. Wynik powyżej 15 wynika z braku w rejestrze "
               "zdarzenia kończącego funkcję L. Bagińskiej (wybór 8.12.2006) albo z innego braku "
               "danych sprzed 2015 r.; nie jest to ustalenie o stanie TK.")
    nieust = [w.osoba for w in rej.typu("E1") if w.wakat == "?"]
    out.append(f"Wakat nieustalony w dokumentach (D1): {len(nieust)} wyborów ({', '.join(nieust)}). "
               "Dla nich S2, S4 i tytuł są NIEUSTALONE. Uzupełnienie wymaga dokumentu wskazującego "
               "poprzednika (np. uzasadnienia, druku sejmowego, komunikatu TK) albo listy "
               "kandydujących wakatów do przeglądu alternatyw A.")
    out.append("Uchwały Sejmu z 2026 r. o wyborze sędziów powołują się na ustawę o statusie "
               "sędziów TK „z 2018 r. poz. 1422 oraz z 2026 r. poz. 26” - zmiana ustawy z 2026 r. "
               "nie jest jeszcze w rejestrze aktów D11.")
    return out


def przygotowanie(rej: Rejestr, ad: ZałożeniaDanych) -> str:
    d = dt.date.today().isoformat()
    s = [f"# Przygotowanie testu ciągłości TK\n",
         f"Wygenerowano: {d} przez `LEAN/dane/tk_test.py przygotuj` na podstawie "
         "`LEAN/dane/tk_rejestr.csv`. Dokument opisuje stan narzędzi i danych "
         "(plan_tk.txt, pkt 10, prace 1–4). **Nie zawiera wyników testu**: obliczenia "
         "historyczne wymagają zatwierdzenia parametrów i reguły R-PUB.\n",
         "## 1. Walidacja rejestru (krok 1, kontrola F2)\n",
         f"- wiersze: {len(rej.wiersze)}, osoby z wyborem (E1): {len(rej.osoby())}",
         f"- błędy: {len(rej.błędy)}" + ("" if not rej.błędy else "\n  - " + "\n  - ".join(rej.błędy)),
         f"- ostrzeżenia: {len(rej.ostrzeżenia)}" + (
             "" if not rej.ostrzeżenia else "\n  - " + "\n  - ".join(rej.ostrzeżenia)),
         "\n## 2. Kompletność danych (pkt 6)\n"]
    k = kompletność(rej)
    s.append(_tabela(["kategoria", "ustalone", "wszystkie", "udział"],
                     [[n, a, b, f"{a / b:.0%}" if b else "-"] for n, (a, b) in k.items()]))
    s.append("\n## 3. Założenia danych AD (jawne, przełączalne)\n")
    s.append(_tabela(["id", "treść", "włączone"], [[a, b, "tak" if c else "nie"]
                                                   for a, b, c in ad.opis()]))
    s.append("\nKażde AD zastępuje brakującą daną. Wyłączenie AD daje w odpowiednich miejscach "
             "wynik NIEUSTALONY (P4). AD nie są parametrami interpretacji Konstytucji.\n")
    s.append("## 4. Warianty (pkt 5.1)\n")
    m1, m2 = liczba("M1"), liczba("M2")
    m3 = m2 * 2 ** len(ROZSZERZENIA_M3)
    s.append(_tabela(["moduł", "parametry (dep)", "nominalnie", "po F1 (utożsamienia 4.6)"], [
        ["M1", ", ".join(DEP["M1"]), liczba_nominalna("M1"), m1],
        ["M2", "dep(M1) ∪ z3c, z3q, z3m, z5, z5z, z8", liczba_nominalna("M2"), m2],
        ["M3", "dep(M2) ∪ " + ", ".join(ROZSZERZENIA_M3), liczba_nominalna("M3"), m3],
        ["M4", "-", 1, 1]]))
    alts = alternatywy(rej)
    łącznie = f"{m3 * len(alts):,}".replace(",", " ")
    s.append(f"\nAlternatywy danych A (przyporządkowania wakatów, po utożsamieniu wakatów "
             f"nierozróżnialnych): {len(alts)}. Łącznie do przeglądu: M3 × A = {łącznie}.\n")
    s.append("## 5. Ustalenia z danych istotne dla parametrów\n")
    for o in obserwacje_danych(rej, ad):
        s.append(f"- {o}")
    s.append("\n## 6. Warunki NIEPOKRYTE (P8)\n")
    for x in ["W1: zakaz ponownego wyboru - rejestr nie obejmuje wyborów sprzed 2006 r.",
              "W1: kryterium „wiedzy prawniczej” - ocenne, poza obliczeniem",
              "W2: odrębne głosowanie nad uchwałą ZO - wymóg ustawowy (P2), reguła nie wczytana",
              "W5: art. 131 ust. 1 - poza zakresem testu",
              "W6a: ostateczność orzeczeń - brak danych o kwestionowaniu",
              "Z11b: kworum i liczebność składów (gdy wybrany wariant b)",
              "Z12b: reguły ustawy i regulaminu Sejmu (D11) - nie wczytane, wynik NIEUSTALONY"]:
        s.append(f"- {x}")
    s.append("\n## 7. Co dalej\n")
    s.append("1. Uzupełnić dane: wakaty wyborów oznaczonych `?`, ślubowania (D3), protokoły ZO "
             "z listami obecnych (D5), składy i wyniki głosowania orzeczeń (D6), akty D11.\n"
             "2. Recenzja prawnika: parametry Z1–Z14, R-PUB, założenia AD1–AD6 i konwencja dat "
             "(pkt 5 niniejszego raportu).\n"
             "3. Po zatwierdzeniu: `python3 tk_test.py oblicz --roboczo` (pełny przegląd, ok. "
             "2–3 min) i zapis do `TK/Wynik_testu_ciaglosci.md`.\n")
    return "\n".join(s) + "\n"


def _zależność(jednolity: bool, wpływ: list[str]) -> str:
    if jednolity:
        return "jednolity"
    return ", ".join(wpływ) if wpływ else ("łącznie kilka parametrów (miara marginalna nie "
                                           "wskazuje pojedynczego)")


def wynik(rej: Rejestr, W: Wynik) -> str:
    s = ["# Wynik testu ciągłości TK (roboczy)\n", NAGŁÓWEK_ROBOCZY,
         f"Wygenerowano: {dt.date.today().isoformat()}. Warianty: "
         + ", ".join(f"{k} {v:,}".replace(",", " ") for k, v in W.liczba_wariantów.items())
         + f"; alternatywy danych A: {len(W.alternatywy)}.\n"]
    s.append("## Tabela A. Przyporządkowania wakatów (alternatywy A)\n")
    for n, a in enumerate(W.alternatywy):
        s.append(f"- A{n}: " + ", ".join(f"{o}→{v}" for o, v in sorted(a.items())
                                       if v and rej.wybór(o).wakat not in ("",)))
    s.append("\n## Tabela B. Liczniki T, F, B, W, Z, U (obwiednia po wszystkich wariantach)\n")
    poprz = None
    wiersze = []
    for t, ob in sorted(W.obwiednia.items()):
        sig = tuple(sorted(ob.items()))
        if sig == poprz:
            continue
        poprz = sig
        wiersze.append([t] + [f"{ob[k][0]}–{ob[k][1]}" if ob[k][0] != ob[k][1] else ob[k][0]
                              for k in "TFBWZU"])
    s.append(_tabela(["od dnia", "T", "F", "B", "W", "Z", "U"], wiersze))
    s.append("\n## Tabela C. Oceny wymogów (krok 5 i 6)\n")
    rows = []
    for k, a in sorted(W.agregaty.items()):
        if k.startswith(("E1:", "ocena:", "kierownictwo:")):
            wpływ = sorted(W.wpływ_dokładny.get(k, set())) or a.wpływające()
            rows.append([k, "; ".join(f"{v}: {n}" for v, n in a.liczby.most_common()),
                         _zależność(a.jednolity(), wpływ)])
    s.append(_tabela(["wymóg / czynność", "wynik: liczba wariantów", "zależy od"], rows))
    s.append("\n## Tabela D. Orzeczenia: skutek łączny (krok 7)\n")
    rows = []
    for k, a in sorted(W.agregaty.items()):
        if k.startswith("orzeczenie:"):
            rows.append([k[11:], "; ".join(f"{v}: {n:,}".replace(",", " ")
                                           for v, n in a.liczby.most_common()),
                         _zależność(a.jednolity(), a.wpływające())])
    s.append(_tabela(["sprawa", "skutek łączny: liczba wariantów", "zależy od"], rows))
    s.append("\n## Tabela E. Publikacja (krok 8, R-PUB)\n")
    s.append(_tabela(["sprawa", "data", "czas oczekiwania (dni)", "przekroczenia N1", "W6b",
                      "przyczyna", "uwagi"],
                     [[p["sprawa"], p["data"], p.get("czas"), p.get("przekroczenia"), p["w6b"],
                       p.get("przyczyna"), "; ".join(p.get("uwagi", []))] for p in W.publikacja]))
    s.append("\n## Tabela F. Odporność\n")
    jedn = sum(1 for a in W.agregaty.values() if a.jednolity())
    s.append(f"Wyniki jednolite w zbadanym zbiorze wariantów: {jedn} z {len(W.agregaty)}. "
             "„Zależy od” w tabelach C i D: dla wyników M1 - test zmiany jednego parametru; "
             "dla M2 i M3 - miara marginalna (różne zbiory wyników dla wartości parametru). "
             "Odporność dotyczy wyłącznie zbadanego zbioru (krok 10).\n")
    s.append("## Tabela G. Pokrycie\nZob. `TK/Przygotowanie_testu.md`, sekcja 6.\n")
    s.append("## Klasyfikacja pomocnicza K (pkt 9)\n")
    for kk, dni in W.k_dni.items():
        rows, poprz = [], None
        for t, vs in sorted(dni.items()):
            v = ", ".join(sorted(vs))
            if v != poprz:
                rows.append([t, v])
                poprz = v
        s.append(f"### {kk}\n")
        s.append(_tabela(["od dnia", "wartości w zbadanych wariantach"], rows))
        s.append("")
    s.append("### K4\n")
    s.append(_tabela(["rok", "K4"], [[r, v] for r, v in k4(W, rej).items()]))
    return "\n".join(s) + "\n"
