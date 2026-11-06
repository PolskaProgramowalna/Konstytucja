import Konstytucja.Podstawy.Czas

/-! # Art. 154–155: tworzenie rządu jako automat

Dni liczymy od pierwszego posiedzenia Sejmu albo przyjęcia dymisji (art. 154 ust. 1).
Założenia P1–P5 opisuje `Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.TworzenieRządu

inductive Etap where
  /-- Art. 154 ust. 1. -/
  | powołanie154
  /-- Art. 154 ust. 2. -/
  | wotum154
  /-- Art. 154 ust. 3 zd. 1. -/
  | wybórSejmu
  /-- Art. 154 ust. 3 zd. 2. -/
  | powołanieWybranych
  /-- Art. 155 ust. 1 zd. 1. -/
  | powołanie155
  /-- Art. 155 ust. 1 zd. 2. -/
  | wotum155
  /-- Art. 155 ust. 2. -/
  | skrócenie
  | rząd
  | kadencjaSkrócona
  deriving DecidableEq, Repr

def Etap.końcowy : Etap → Bool
  | .rząd | .kadencjaSkrócona => true
  | _ => false

/-- Definicja pomocnicza do dowodu zakończenia: maksymalna liczba pozostałych kroków. -/
def Etap.pozostało : Etap → Nat
  | .powołanie154 => 6
  | .wotum154 => 5
  | .wybórSejmu => 4
  | .powołanie155 => 3
  | .wotum155 => 2
  | .powołanieWybranych | .skrócenie => 1
  | .rząd | .kadencjaSkrócona => 0

/-- P5: rozstrzygnięcie kolizji opisanej w `Twierdzenia/Kolizje.lean`. -/
inductive Rozstrzygnięcie where
  | pierwszeństwoArt228
  | pierwszeństwoArt155
  deriving DecidableEq, Repr

/-- Założenia, od których zależą wyniki. Nic z tego nie jest ukryte w przejściach. -/
structure Założenia where
  /-- Czy Prezydent wykonuje czynności. Bierność Sejmu opisują same przejścia (P2). -/
  prezydentDziała : Bool
  /-- Stan nadzwyczajny albo 90 dni po nim (art. 228 ust. 7). -/
  okresOchronny : Nat → Bool
  rozstrzygnięcie : Rozstrzygnięcie
  /-- P4: dodatkowy limit czynności bez terminu w tekście. -/
  limit : Option Nat

structure Stan where
  etap : Etap
  dzień : Nat

variable (Z : Założenia)

/-- Czynność bez terminu w tekście: dowolnie późno, chyba że przyjęto limit (P4). -/
def wLimicie (t t' : Nat) : Prop :=
  t ≤ t' ∧ match Z.limit with
    | none => True
    | some L => t' ≤ t + L

/-- Art. 228 ust. 7 przy wybranym rozstrzygnięciu. -/
def skrócenieDozwolone (t : Nat) : Prop :=
  Z.okresOchronny t = false ∨ Z.rozstrzygnięcie = .pierwszeństwoArt155

inductive Krok : Stan → Stan → Prop where
  /-- Art. 154 ust. 1. -/
  | powołanie {t t'} : Z.prezydentDziała = true → wCiągu t 14 t' →
      Krok ⟨.powołanie154, t⟩ ⟨.wotum154, t'⟩
  /-- Art. 154 ust. 3: niepowołanie w terminie. -/
  | niepowołanie {t} : Krok ⟨.powołanie154, t⟩ ⟨.wybórSejmu, t + 14⟩
  /-- Art. 154 ust. 2, założenie P1. -/
  | wotumTak {t t'} : wCiągu t 14 t' → Krok ⟨.wotum154, t⟩ ⟨.rząd, t'⟩
  /-- Art. 154 ust. 3, założenie P2. -/
  | wotumNie {t} : Krok ⟨.wotum154, t⟩ ⟨.wybórSejmu, t + 14⟩
  /-- Art. 154 ust. 3 zd. 1. -/
  | wybór {t t'} : wCiągu t 14 t' → Krok ⟨.wybórSejmu, t⟩ ⟨.powołanieWybranych, t'⟩
  /-- Art. 155 ust. 1, założenia P2 i P3. -/
  | brakWyboru {t} : Krok ⟨.wybórSejmu, t⟩ ⟨.powołanie155, t + 14⟩
  /-- Art. 154 ust. 3 zd. 2, założenie P4. -/
  | powołanieWybranych {t t'} : Z.prezydentDziała = true → wLimicie Z t t' →
      Krok ⟨.powołanieWybranych, t⟩ ⟨.rząd, t'⟩
  /-- Art. 155 ust. 1 zd. 1. -/
  | powołanie155 {t t'} : Z.prezydentDziała = true → wCiągu t 14 t' →
      Krok ⟨.powołanie155, t⟩ ⟨.wotum155, t'⟩
  /-- Art. 155 ust. 1 zd. 2. -/
  | wotum155Tak {t t'} : wCiągu t 14 t' → Krok ⟨.wotum155, t⟩ ⟨.rząd, t'⟩
  /-- Art. 155 ust. 2, założenie P2. -/
  | wotum155Nie {t} : Krok ⟨.wotum155, t⟩ ⟨.skrócenie, t + 14⟩
  /-- Art. 155 ust. 2, art. 228 ust. 7, założenia P4 i P5. -/
  | skrócenie {t t'} : Z.prezydentDziała = true → wLimicie Z t t' →
      skrócenieDozwolone Z t' → Krok ⟨.skrócenie, t⟩ ⟨.kadencjaSkrócona, t'⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.powołanie154, 0⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

end Konstytucja.TworzenieRządu
