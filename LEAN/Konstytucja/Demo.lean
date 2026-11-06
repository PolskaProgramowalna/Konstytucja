namespace Konstytucja

def posłowie : Nat := 460      -- art. 96 ust. 1

structure Głosowanie where
  za : Nat
  przeciw : Nat
  wstrzymani : Nat

def Głosowanie.obecni (g : Głosowanie) : Nat := g.za + g.przeciw + g.wstrzymani

/-- „w obecności co najmniej połowy ustawowej liczby posłów” -/
def kworum (g : Głosowanie) : Prop := 2 * g.obecni ≥ posłowie

/-- Założenie spoza tekstu Konstytucji: mianownik to wszyscy głosujący. -/
def bezwzględna (g : Głosowanie) : Prop := 2 * g.za > g.obecni
def zwykła (g : Głosowanie) : Prop := g.za > g.przeciw

/-- art. 158 ust. 1 -/
def wotumNieufności (g : Głosowanie) : Prop := 2 * g.za > posłowie
/-- art. 235 ust. 4 (część sejmowa) -/
def zmianaKonstytucji (g : Głosowanie) : Prop := kworum g ∧ 3 * g.za ≥ 2 * g.obecni
/-- art. 122 ust. 5 -/
def odrzucenieWeta (g : Głosowanie) : Prop := kworum g ∧ 5 * g.za ≥ 3 * g.obecni

theorem bezwzględna_daje_zwykłą (g) (h : bezwzględna g) : zwykła g := by
  simp only [bezwzględna, zwykła, Głosowanie.obecni] at *; omega

theorem wotum_min (g) : wotumNieufności g ↔ g.za ≥ 231 := by
  simp only [wotumNieufności, posłowie]; omega

theorem zmiana_min (g) (h : zmianaKonstytucji g) : g.za ≥ 154 := by
  simp only [zmianaKonstytucji, kworum, posłowie, Głosowanie.obecni] at *; omega

theorem weto_min (g) (h : odrzucenieWeta g) : g.za ≥ 138 := by
  simp only [odrzucenieWeta, kworum, posłowie, Głosowanie.obecni] at *; omega

/-- W Sejmie zmiana Konstytucji może przejść mniejszą liczbą głosów „za”
niż wynosi próg wotum nieufności. -/
theorem zmiana_tańsza_niż_wotum :
    ∃ g, zmianaKonstytucji g ∧ ¬ wotumNieufności g ∧ g.za = 154 :=
  ⟨⟨154, 76, 0⟩, by
    simp [zmianaKonstytucji, wotumNieufności, kworum, posłowie, Głosowanie.obecni]⟩

/-- art. 230: maksymalny stan wyjątkowy -/
theorem stan_wyjątkowy_max (d p : Nat) (h₁ : d ≤ 90) (h₂ : p ≤ 60) : d + p ≤ 150 := by omega

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

/-! Art. 31 ust. 3: pojęć ocennych nie da się zdefiniować – stają się parametrami. -/
structure Ograniczenie where
  wUstawie : Bool

structure Interpretacja where
  konieczne : Ograniczenie → Prop
  naruszaIstotę : Ograniczenie → Prop

def dopuszczalne (I : Interpretacja) (o : Ograniczenie) : Prop :=
  o.wUstawie = true ∧ I.konieczne o ∧ ¬ I.naruszaIstotę o

theorem dwie_interpretacje (o : Ograniczenie) (h : o.wUstawie = true) :
    ∃ I₁ I₂ : Interpretacja, dopuszczalne I₁ o ∧ ¬ dopuszczalne I₂ o :=
  ⟨⟨fun _ => True, fun _ => False⟩, ⟨fun _ => False, fun _ => False⟩,
   ⟨h, trivial, id⟩, fun h' => h'.2.1⟩

end Konstytucja
#print axioms Konstytucja.zmiana_tańsza_niż_wotum
#print axioms Konstytucja.tworzenie_rządu_rozstrzygnięte

namespace Konstytucja
theorem weto_138_osiągalne : ∃ g, odrzucenieWeta g ∧ g.za = 138 :=
  ⟨⟨138, 92, 0⟩, by simp [odrzucenieWeta, kworum, posłowie, Głosowanie.obecni]⟩
end Konstytucja
#print axioms Konstytucja.bezwzględna_daje_zwykłą
#print axioms Konstytucja.wotum_min
#print axioms Konstytucja.zmiana_min
#print axioms Konstytucja.weto_min
#print axioms Konstytucja.weto_138_osiągalne
#print axioms Konstytucja.stan_wyjątkowy_max
#print axioms Konstytucja.dwie_interpretacje
