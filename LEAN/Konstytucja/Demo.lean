/-! # Szkic T6, do zastąpienia automatem z etapu 3 -/

namespace Konstytucja

/-! Art. 154–155: tworzenie rządu jako automat skończony. -/
inductive Wynik | rząd | skrócenieKadencji deriving DecidableEq

/-- Argumenty: czy powiodła się I, II i III procedura. -/
def tworzenieRządu : Bool → Bool → Bool → Wynik
  | true,  _,     _     => .rząd                 -- art. 154 ust. 1–2
  | false, true,  _     => .rząd                 -- art. 154 ust. 3
  | false, false, true  => .rząd                 -- art. 155 ust. 1
  | false, false, false => .skrócenieKadencji    -- art. 155 ust. 2

theorem tworzenie_rządu_rozstrzygnięte (a b c) :
    tworzenieRządu a b c = .rząd ∨ tworzenieRządu a b c = .skrócenieKadencji := by
  cases a <;> cases b <;> cases c <;> simp [tworzenieRządu]

end Konstytucja
