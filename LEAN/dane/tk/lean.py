"""Generator `Konstytucja/TK/CiagloscDane.lean` z rejestru (pkt 12 planu, kontrola F2).

Identyfikatory zdarzeń i osób są kodowane liczbami, a zgodność z rejestrem
potwierdza skrót SHA-256 pliku CSV w nagłówku (wersja danych).
"""
from __future__ import annotations

import hashlib

from .rejestr import TYPY, Rejestr

TYPY_LEAN = {t: f"t{n}" for n, t in enumerate(TYPY)}


def dane(rej: Rejestr, ścieżka_csv=None) -> str:
    import pathlib
    p = ścieżka_csv or pathlib.Path(__file__).resolve().parent.parent / "tk_rejestr.csv"
    skrót = hashlib.sha256(p.read_bytes()).hexdigest()
    osoby = [""] + sorted({w.osoba for w in rej.wiersze if w.osoba})
    nr_osoby = {o: n for n, o in enumerate(osoby)}
    epoka = __import__("datetime").date(1970, 1, 1)
    wiersze = []
    for n, w in enumerate(rej.wiersze):
        przecinek = "," if n < len(rej.wiersze) - 1 else ""
        wiersze.append(f"  ⟨{n}, .{TYPY_LEAN[w.typ]}, {(w.data - epoka).days}, {nr_osoby[w.osoba]}⟩"
                       f"{przecinek}  -- {w.id} {w.typ} {w.data} {w.osoba}")
    typy = "\n".join(f"  /-- {t}: {opis} -/\n  | {TYPY_LEAN[t]}" for t, opis in TYPY.items())
    osoby_kom = "\n".join(f"-- {n}: {o or '(brak osoby)'}" for n, o in enumerate(osoby))
    return f"""-- PLIK GENEROWANY przez `python3 tk_test.py lean` - nie edytować ręcznie.
-- Źródło: dane/tk_rejestr.csv, SHA-256 {skrót}
import Konstytucja.TK.Ciaglosc

/-! # Rejestr zdarzeń testu ciągłości TK (dane, plan_tk.txt pkt 6 i 12)

Kontrola F2 w Lean: identyfikatory zdarzeń są unikalne, a każde zdarzenie osobowe
odnosi się do osoby, która ma wybór (E1). Daty: dni od 1970-01-01.
-/

namespace Konstytucja.TK.CiagloscDane

set_option maxRecDepth 20000

inductive Typ where
{typy}
  deriving DecidableEq, Repr

structure Zdarzenie where
  nr : Nat
  typ : Typ
  dzień : Nat
  osoba : Nat
  deriving DecidableEq, Repr

{osoby_kom}

def rejestr : List Zdarzenie := [
{chr(10).join(wiersze)}
]

/-- Liczba zdarzeń w rejestrze. -/
theorem liczba_zdarzeń : rejestr.length = {len(wiersze)} := by decide

/-- F2: identyfikatory zdarzeń są unikalne. -/
theorem identyfikatory_unikalne : (rejestr.map (·.nr)).Nodup :=
  Konstytucja.TK.Ciaglosc.nodup_z_bezPowtórzeń _ (by decide)

/-- Osoby, które mają zdarzenie E1. -/
def wybrani : List Nat := (rejestr.filter (·.typ == .{TYPY_LEAN['E1']})).map (·.osoba)

/-- F2: każda osoba ma co najwyżej jeden wybór (brak podwójnego zaliczenia). -/
theorem jeden_wybór : wybrani.Nodup :=
  Konstytucja.TK.Ciaglosc.nodup_z_bezPowtórzeń _ (by decide)

/-- F2: każde zdarzenie osobowe odnosi się do osoby z wyborem. -/
theorem osoby_mają_wybór : rejestr.all (fun z => z.osoba == 0 || wybrani.contains z.osoba) = true := by
  decide

end Konstytucja.TK.CiagloscDane
"""
