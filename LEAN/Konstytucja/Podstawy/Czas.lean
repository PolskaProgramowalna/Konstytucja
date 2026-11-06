/-! # Czas i terminy (założenia C1–C4) -/

namespace Konstytucja

/-- C2: „w ciągu n dni od dnia d”. Dni są liczbami naturalnymi (C1). -/
def wCiągu (d : Nat) (n : Nat) (t : Nat) : Prop := d ≤ t ∧ t ≤ d + n

/-- „Nie wcześniej niż n-tego dnia od dnia d” (np. art. 235 ust. 3). -/
def nieWcześniejNiż (d : Nat) (n : Nat) (t : Nat) : Prop := d + n ≤ t

/-- Dwa kolejne terminy dają termin będący ich sumą. -/
theorem wCiągu_składanie {d t u : Nat} {a b : Nat}
    (h₁ : wCiągu d a t) (h₂ : wCiągu t b u) : wCiągu d (a + b) u := by
  simp only [wCiągu] at *; omega

/-- C4: miesiące i lata są parametrem. Składania (+1 + 1 = +2) celowo nie żądamy,
bo nie zachodzi ono w rzeczywistym kalendarzu. -/
structure Kalendarz where
  poMiesiącach : Nat → Nat → Nat
  poLatach : Nat → Nat → Nat
  miesiące_zero : ∀ d, poMiesiącach d 0 = d
  lata_zero : ∀ d, poLatach d 0 = d
  miesiące_rosną : ∀ d n, 0 < n → d < poMiesiącach d n
  lata_rosną : ∀ d n, 0 < n → d < poLatach d n

/-- Art. 230: stan wyjątkowy trwa do 90 dni, a jedyne przedłużenie do 60 dni. -/
structure StanWyjątkowy where
  czasPodstawowy : Nat
  przedłużenie : Nat
  podstawowyWLimicie : czasPodstawowy ≤ 90
  przedłużenieWLimicie : przedłużenie ≤ 60

def StanWyjątkowy.czasŁączny (s : StanWyjątkowy) : Nat := s.czasPodstawowy + s.przedłużenie

end Konstytucja
