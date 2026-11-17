#!/usr/bin/env python3
"""Test ciągłości TK (plan_tk.txt). Uruchomienie z katalogu LEAN/dane:

  python3 tk_test.py waliduj           # krok 1: walidacja rejestru (F2); kod 1 przy błędach
  python3 tk_test.py przygotuj         # raport przygotowawczy -> TK/Przygotowanie_testu.md
  python3 tk_test.py lean              # generuje Konstytucja/TK/CiagloscDane.lean
  python3 tk_test.py testy             # testy jednostkowe (tk/test_tk.py)
  python3 tk_test.py oblicz --roboczo  # pełny przegląd wariantów -> TK/Wynik_testu_ciaglosci.md

`oblicz` wymaga flagi --roboczo, bo parametry nie są zatwierdzone (pkt 10 planu).
"""
import argparse
import pathlib
import sys

TU = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(TU))  # pakiet tk obok skryptu (uruchamiane z python3 -I)

from tk import lean, raport, rejestr  # noqa: E402
from tk.model import ZałożeniaDanych  # noqa: E402

REPO = TU.parent.parent
REJESTR = TU / "tk_rejestr.csv"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("polecenie", choices=["waliduj", "przygotuj", "lean", "testy", "oblicz"])
    ap.add_argument("--roboczo", action="store_true", help="zgoda na obliczenie przy parametrach roboczych")
    ap.add_argument("--bez-ad", action="append", default=[],
                    help="wyłącz założenie danych, np. --bez-ad ad1_brak_innych_E6")
    ap.add_argument("--wyjście", type=pathlib.Path)
    a = ap.parse_args()
    if a.polecenie == "testy":
        import unittest
        wynik = unittest.TextTestRunner(verbosity=1).run(
            unittest.defaultTestLoader.loadTestsFromName("tk.test_tk"))
        return 0 if wynik.wasSuccessful() else 1
    rej = rejestr.wczytaj(REJESTR)
    ad = ZałożeniaDanych(**{k: False for k in a.bez_ad})
    if a.polecenie == "waliduj":
        for b in rej.błędy:
            print("BŁĄD", b, file=sys.stderr)
        for o in rej.ostrzeżenia:
            print("OSTRZEŻENIE", o, file=sys.stderr)
        print(f"wiersze: {len(rej.wiersze)}, błędy: {len(rej.błędy)}, ostrzeżenia: {len(rej.ostrzeżenia)}")
        return 1 if rej.błędy else 0
    if rej.błędy:
        print("Rejestr ma błędy - uruchom `waliduj`", file=sys.stderr)
        return 1
    if a.polecenie == "przygotuj":
        cel = a.wyjście or REPO / "TK/Przygotowanie_testu.md"
        cel.write_text(raport.przygotowanie(rej, ad), encoding="utf8")
        print(f"zapisano {cel}")
        return 0
    if a.polecenie == "lean":
        cel = a.wyjście or TU.parent / "Konstytucja/TK/CiagloscDane.lean"
        cel.write_text(lean.dane(rej), encoding="utf8")
        print(f"zapisano {cel}")
        return 0
    if a.polecenie == "oblicz":
        if not a.roboczo:
            print("Parametry Z1-Z14 i R-PUB nie są zatwierdzone (plan_tk.txt, pkt 10). "
                  "Obliczenie wymaga flagi --roboczo; wynik zostanie oznaczony jako roboczy.",
                  file=sys.stderr)
            return 2
        from tk import przebieg
        W = przebieg.przebieg(rej, ad)
        cel = a.wyjście or REPO / "TK/Wynik_testu_ciaglosci.md"
        cel.write_text(raport.wynik(rej, W), encoding="utf8")
        print(f"zapisano {cel}; warianty: {W.liczba_wariantów}")
        return 0
    return 0


if __name__ == "__main__":
    sys.exit(main())
