import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat
import Konstytucja.Podstawy.Głosowanie

/-! # Art. 125: referendum ogólnokrajowe jako automat

Założenia Q1–Q6 opisuje `Konstytucja/Założenia.lean`. Stan `sprawa` nie jest błędem:
art. 125 ust. 1 mówi „może być przeprowadzone”, więc nikt nie ma obowiązku działać.
-/

namespace Konstytucja.Referendum

/-- Wynik głosowania. Głosy ważne mieszczą się w udziale, a udział w liczbie uprawnionych. -/
structure Wynik where
  uprawnieni : Nat
  udział : Nat
  za : Nat
  przeciw : Nat
  ważneWUdziale : za + przeciw ≤ udział
  udziałWLimicie : udział ≤ uprawnieni

/-- Art. 125 ust. 3: udział więcej niż połowy uprawnionych. -/
def wiąże (w : Wynik) : Prop := 2 * w.udział > w.uprawnieni

/-- Założenie Q1. -/
def rozstrzyga (w : Wynik) : Prop := w.za > w.przeciw

/-- Art. 125 ust. 2. -/
def zarządzenieSejmu (m : Mianownik) (g : Głosowanie .sejm) : Prop :=
  kworum g ∧ większośćBezwzględna m g

/-- Art. 125 ust. 2. -/
def zgodaSenatu (m : Mianownik) (g : Głosowanie .senat) : Prop :=
  kworum g ∧ większośćBezwzględna m g

inductive Etap where
  | sprawa
  /-- Art. 125 ust. 2: wniosek Prezydenta czeka na zgodę Senatu. -/
  | zgodaSenatu
  | zarządzone
  /-- Art. 125 ust. 4. -/
  | ważność (w : Wynik)
  | wiążące (w : Wynik)
  | niewiążące (w : Wynik)
  | nieważne
  | niezarządzone

/-- Etap, w którym nic nie czeka na rozstrzygnięcie. -/
def Etap.ustalony : Etap → Bool
  | .sprawa | .wiążące _ | .niewiążące _ | .nieważne | .niezarządzone => true
  | _ => false

/-- Definicja pomocnicza: maksymalna liczba pozostałych kroków. -/
def Etap.ranga : Etap → Nat
  | .sprawa => 4
  | .zgodaSenatu => 3
  | .zarządzone => 2
  | .ważność _ => 1
  | .wiążące _ | .niewiążące _ | .nieważne | .niezarządzone => 0

structure Założenia where
  /-- Założenie Q3. -/
  szczególneZnaczenie : Bool
  /-- Założenie G2. -/
  mianownik : Mianownik
  sejmDziała : Bool
  senatDziała : Bool
  prezydentDziała : Bool
  sądDziała : Bool
  /-- Art. 228 ust. 7. -/
  okresOchronny : Nat → Bool
  /-- Założenie Q4. -/
  limit : Option Nat

structure Stan where
  etap : Etap
  dzień : Nat

variable (Z : Założenia)

/-- Czynność bez terminu w tekście. -/
def wLimicie (t t' : Nat) : Prop := wLimicieCzasu Z.limit t t'

inductive Krok : Stan → Stan → Prop where
  /-- Art. 125 ust. 1–2. -/
  | zarządzenie {t t'} (g) : Z.szczególneZnaczenie = true → Z.sejmDziała = true →
      zarządzenieSejmu Z.mianownik g → wLimicie Z t t' →
      Krok ⟨.sprawa, t⟩ ⟨.zarządzone, t'⟩
  /-- Art. 125 ust. 2. -/
  | brakWiększości {t t'} (g) : Z.sejmDziała = true → ¬ zarządzenieSejmu Z.mianownik g →
      wLimicie Z t t' → Krok ⟨.sprawa, t⟩ ⟨.niezarządzone, t'⟩
  /-- Art. 125 ust. 1–2. -/
  | wniosekPrezydenta {t t'} : Z.szczególneZnaczenie = true →
      Z.prezydentDziała = true → wLimicie Z t t' →
      Krok ⟨.sprawa, t⟩ ⟨.zgodaSenatu, t'⟩
  /-- Art. 125 ust. 2. -/
  | zgodaUdzielona {t t'} (g) : Z.senatDziała = true → zgodaSenatu Z.mianownik g →
      wLimicie Z t t' → Krok ⟨.zgodaSenatu, t⟩ ⟨.zarządzone, t'⟩
  /-- Art. 125 ust. 2. -/
  | zgodaNieudzielona {t t'} (g) : Z.senatDziała = true → ¬ zgodaSenatu Z.mianownik g →
      wLimicie Z t t' → Krok ⟨.zgodaSenatu, t⟩ ⟨.niezarządzone, t'⟩
  /-- Art. 228 ust. 7, założenie Q5. -/
  | głosowanie {t t'} (w) : Z.okresOchronny t' = false → wLimicie Z t t' →
      Krok ⟨.zarządzone, t⟩ ⟨.ważność w, t'⟩
  /-- Art. 125 ust. 3–4. -/
  | wynikWiążący {t t' w} : Z.sądDziała = true → wiąże w → wLimicie Z t t' →
      Krok ⟨.ważność w, t⟩ ⟨.wiążące w, t'⟩
  /-- Art. 125 ust. 3–4. -/
  | wynikNiewiążący {t t' w} : Z.sądDziała = true → ¬ wiąże w → wLimicie Z t t' →
      Krok ⟨.ważność w, t⟩ ⟨.niewiążące w, t'⟩
  /-- Art. 125 ust. 4. -/
  | nieważność {t t' w} : Z.sądDziała = true → wLimicie Z t t' →
      Krok ⟨.ważność w, t⟩ ⟨.nieważne, t'⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.sprawa, 0⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

end Konstytucja.Referendum
