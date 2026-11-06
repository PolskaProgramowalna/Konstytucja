/-! # Czas i terminy (założenia C1–C5)

Dni i chwile są liczbami naturalnymi. Chwila to numer godziny (C1), a dzień
kalendarzowy chwili `c` to `c / 24`.
-/

namespace Konstytucja

/-- C2: „w ciągu n dni od dnia d”, dla dat bez godziny. -/
def wCiągu (d n t : Nat) : Prop := d ≤ t ∧ t ≤ d + n

/-- „Nie wcześniej niż n-tego dnia od dnia d” (np. art. 235 ust. 3). -/
def nieWcześniejNiż (d n t : Nat) : Prop := d + n ≤ t

/-- Czynność bez terminu w tekście: dowolnie późno, chyba że założono limit. -/
def wLimicieCzasu (limit : Option Nat) (t t' : Nat) : Prop :=
  t ≤ t' ∧ match limit with
    | none => True
    | some L => t' ≤ t + L

theorem wLimicieCzasu_refl (limit : Option Nat) (t : Nat) : wLimicieCzasu limit t t := by
  simp only [wLimicieCzasu]
  split <;> simp

/-- Dwa kolejne terminy dają termin będący ich sumą. -/
theorem wCiągu_składanie {d t u a b : Nat}
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

/-- Długość terminu w jednostce użytej w przepisie. -/
inductive Okres where
  | godziny (n : Nat)
  | dni (n : Nat)
  | miesiące (n : Nat)
  | lata (n : Nat)

/-- Ostatnia chwila terminu biegnącego od chwili `c`. Terminy kalendarzowe kończą się
wraz z końcem ostatniego dnia, a terminy godzinowe dokładnie po `n` godzinach. -/
def koniecTerminu (K : Kalendarz) (c : Nat) : Okres → Nat
  | .godziny n => c + n
  | .dni n => (c / 24 + n) * 24 + 23
  | .miesiące n => K.poMiesiącach (c / 24) n * 24 + 23
  | .lata n => K.poLatach (c / 24) n * 24 + 23

/-- Czynność w chwili `t` mieści się w terminie `o` biegnącym od chwili `c`. -/
def wTerminie (K : Kalendarz) (c : Nat) (o : Okres) (t : Nat) : Prop :=
  c ≤ t ∧ t ≤ koniecTerminu K c o

/-- Termin w dniach zgadza się z `wCiągu` na poziomie dat. -/
theorem wTerminie_dni (K : Kalendarz) (c n t : Nat) :
    wTerminie K c (.dni n) t ↔ c ≤ t ∧ wCiągu (c / 24) n (t / 24) := by
  simp only [wTerminie, koniecTerminu, wCiągu]
  omega

/-- 48 godzin to nie to samo co 2 dni: czynność może zmieścić się tylko w tym drugim. -/
theorem godziny_różne_od_dni (K : Kalendarz) :
    ∃ c t, wTerminie K c (.dni 2) t ∧ ¬ wTerminie K c (.godziny 48) t :=
  ⟨1, 71, by simp [wTerminie, koniecTerminu]⟩

/-- Art. 230: stan wyjątkowy trwa do 90 dni, a jedyne przedłużenie do 60 dni. -/
structure StanWyjątkowy where
  czasPodstawowy : Nat
  przedłużenie : Nat
  podstawowyWLimicie : czasPodstawowy ≤ 90
  przedłużenieWLimicie : przedłużenie ≤ 60

def StanWyjątkowy.czasŁączny (s : StanWyjątkowy) : Nat := s.czasPodstawowy + s.przedłużenie

/-- Art. 231 zd. 1: przedstawienie rozporządzenia Sejmowi w ciągu 48 godzin od podpisania. -/
def przedstawienieRozporządzenia (K : Kalendarz) (podpisanie przedstawienie : Nat) : Prop :=
  wTerminie K podpisanie (.godziny 48) przedstawienie

end Konstytucja
