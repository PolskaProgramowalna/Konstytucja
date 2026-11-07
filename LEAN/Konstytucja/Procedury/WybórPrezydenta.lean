import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat

/-! # Art. 127–130: wybór Prezydenta jako automat

Automat opisuje jedną procedurę wyborczą przy ustalonym scenariuszu głosowania.
Założenia W1–W6 opisuje `Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.WybórPrezydenta

/-- Art. 127 ust. 2–3. -/
structure Kandydat where
  obywatel : Bool
  wiekWDniuWyborów : Nat
  pełniaPraw : Bool
  podpisy : Nat
  poprzednieKadencje : Nat

/-- Art. 127 ust. 2–3, założenie W2. -/
def dopuszczalny (c : Kandydat) : Prop :=
  c.obywatel = true ∧ c.wiekWDniuWyborów ≥ 35 ∧ c.pełniaPraw = true ∧
    c.podpisy ≥ 100000 ∧ c.poprzednieKadencje ≤ 1

/-- Suma głosów na kandydatów z listy. -/
def suma (g : Nat → Nat) : List Nat → Nat
  | [] => 0
  | x :: r => g x + suma g r

/-- Art. 128 ust. 2. -/
inductive Tryb where
  /-- Upływ kadencji w dniu `koniec`. -/
  | zwykły (koniec : Nat)
  | opróżnienie
  deriving DecidableEq, Repr

structure Założenia where
  tryb : Tryb
  kandydaci : List Nat
  bezPowtórzeń : kandydaci.Nodup
  dane : Nat → Kandydat
  wszyscyDopuszczalni : ∀ k ∈ kandydaci, dopuszczalny (dane k)
  /-- Założenie W3. -/
  głosyI : Nat → Nat
  /-- Założenie W3. -/
  głosyII : Nat → Nat
  /-- Założenie W4. -/
  zapas : Nat
  /-- Art. 128 ust. 2. -/
  dzieńWolny : Nat → Bool
  /-- Art. 228 ust. 7. -/
  okresOchronny : Nat → Bool
  marszałekDziała : Bool
  sądDziała : Bool
  /-- Terminy art. 129 i art. 130 nie mają wartości liczbowej. -/
  limit : Option Nat

inductive Etap where
  /-- Tryb należy do procedury, bo po nieważności zmienia się na tryb opróżnienia. -/
  | przedZarządzeniem (m : Tryb)
  /-- `data` to dzień pierwszego głosowania. -/
  | pierwszaTura (data : Nat)
  /-- Art. 127 ust. 4–5. -/
  | drugaTura (a b : Nat)
  /-- Art. 129 ust. 1. -/
  | ważność (wybrany : Nat)
  /-- Art. 130. -/
  | objęcie (wybrany : Nat)
  | prezydentWybrany (wybrany : Nat)
  /-- Art. 129 ust. 3. -/
  | wybórNieważny

def Etap.końcowy : Etap → Bool
  | .prezydentWybrany _ | .wybórNieważny => true
  | _ => false

/-- Definicja pomocnicza do miary. -/
def Etap.ranga : Etap → Nat
  | .przedZarządzeniem _ => 6
  | .pierwszaTura _ => 5
  | .drugaTura _ _ => 4
  | .ważność _ => 2
  | .objęcie _ => 1
  | .prezydentWybrany _ | .wybórNieważny => 0

structure Stan where
  etap : Etap
  dzień : Nat
  /-- Pozostałe możliwe zastąpienia kandydata (W4). -/
  zapas : Nat

variable (Z : Założenia)

/-- Czynność bez terminu w tekście. -/
def wLimicie (t t' : Nat) : Prop := wLimicieCzasu Z.limit t t'

/-- Art. 128 ust. 2, założenie W1. `z` to dzień zarządzenia, a `d` dzień wyborów. -/
def terminZarządzenia (m : Tryb) (t z d : Nat) : Prop :=
  t ≤ z ∧ z ≤ d ∧ d ≤ z + 60 ∧ match m with
    | .zwykły k => k ≤ d + 100 ∧ d + 75 ≤ k
    | .opróżnienie => z ≤ t + 14

/-- Art. 127 ust. 4 zd. 1. -/
def większośćI (w : Nat) : Prop := 2 * Z.głosyI w > suma Z.głosyI Z.kandydaci

/-- Art. 127 ust. 5 zd. 1. -/
def dwajNajlepsi (a b : Nat) : Prop :=
  a ∈ Z.kandydaci ∧ b ∈ Z.kandydaci ∧ a ≠ b ∧
    ∀ k ∈ Z.kandydaci, k ≠ a → k ≠ b → Z.głosyI k ≤ Z.głosyI a ∧ Z.głosyI k ≤ Z.głosyI b

inductive Krok : Stan → Stan → Prop where
  /-- Art. 128 ust. 2. -/
  | zarządzenie {t z d p m} : Z.marszałekDziała = true → terminZarządzenia m t z d →
      Z.dzieńWolny d = true →
      Krok ⟨.przedZarządzeniem m, t, p⟩ ⟨.pierwszaTura d, z, p⟩
  /-- Art. 127 ust. 4 zd. 1, art. 228 ust. 7. -/
  | wygrana {z d p} (w : Nat) : w ∈ Z.kandydaci → większośćI Z w →
      Z.okresOchronny d = false →
      Krok ⟨.pierwszaTura d, z, p⟩ ⟨.ważność w, d, p⟩
  /-- Art. 127 ust. 4 zd. 2, art. 228 ust. 7. -/
  | ponowneGłosowanie {z d p} (a b : Nat) : dwajNajlepsi Z a b →
      (∀ k ∈ Z.kandydaci, ¬ większośćI Z k) → Z.okresOchronny d = false →
      Krok ⟨.pierwszaTura d, z, p⟩ ⟨.drugaTura a b, d + 14, p⟩
  /-- Art. 127 ust. 5 zd. 2–3, założenie W4. -/
  | zastąpienieA {t a b p} (c : Nat) : c ∈ Z.kandydaci → c ≠ a → c ≠ b →
      Krok ⟨.drugaTura a b, t, p + 1⟩ ⟨.drugaTura c b, t + 14, p⟩
  /-- Art. 127 ust. 5 zd. 2–3, założenie W4. -/
  | zastąpienieB {t a b p} (c : Nat) : c ∈ Z.kandydaci → c ≠ a → c ≠ b →
      Krok ⟨.drugaTura a b, t, p + 1⟩ ⟨.drugaTura a c, t + 14, p⟩
  /-- Art. 127 ust. 6, art. 228 ust. 7. -/
  | wygranaA {t a b p} : Z.głosyII a > Z.głosyII b → Z.okresOchronny t = false →
      Krok ⟨.drugaTura a b, t, p⟩ ⟨.ważność a, t, p⟩
  /-- Art. 127 ust. 6, art. 228 ust. 7. -/
  | wygranaB {t a b p} : Z.głosyII b > Z.głosyII a → Z.okresOchronny t = false →
      Krok ⟨.drugaTura a b, t, p⟩ ⟨.ważność b, t, p⟩
  /-- Art. 129 ust. 1. -/
  | wybórWażny {t t' w p} : Z.sądDziała = true → wLimicie Z t t' →
      Krok ⟨.ważność w, t, p⟩ ⟨.objęcie w, t', p⟩
  /-- Art. 129 ust. 3. -/
  | wybórUznanyZaNieważny {t t' w p} : Z.sądDziała = true → wLimicie Z t t' →
      Krok ⟨.ważność w, t, p⟩ ⟨.wybórNieważny, t', p⟩
  /-- Art. 130. -/
  | objęcieUrzędu {t t' w p} : wLimicie Z t t' →
      Krok ⟨.objęcie w, t, p⟩ ⟨.prezydentWybrany w, t', p⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.przedZarządzeniem Z.tryb, 0, Z.zapas⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

end Konstytucja.WybórPrezydenta
