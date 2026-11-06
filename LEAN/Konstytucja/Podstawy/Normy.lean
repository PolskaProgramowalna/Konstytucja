/-! # Normy: nakaz, zakaz, dozwolenie i wyjątki -/

namespace Konstytucja

structure Przepis where
  art : Nat
  ust : Nat := 0
  pkt : Nat := 0
  deriving DecidableEq, Repr

inductive Modalność where
  | nakaz
  | zakaz
  | dozwolenie
  deriving DecidableEq, Repr

/-- Czy dwie modalności tego samego czynu wykluczają się. -/
def Modalność.sprzeczna : Modalność → Modalność → Bool
  | .zakaz, .nakaz | .nakaz, .zakaz | .zakaz, .dozwolenie | .dozwolenie, .zakaz => true
  | _, _ => false

/-- Norma nad sytuacjami `S` i czynami `C`. -/
structure Norma (S C : Type) where
  źródło : Przepis
  modalność : Modalność
  czyn : C
  zakres : S → Prop
  wyjątek : S → Prop

variable {S C : Type}

/-- Norma działa, gdy sytuacja jest w zakresie i nie ma wyjątku. -/
def Norma.działa (n : Norma S C) (s : S) : Prop := n.zakres s ∧ ¬ n.wyjątek s

/-- Kolizja: dwie działające normy wymagają sprzecznych zachowań. -/
def Kolizja (a b : Norma S C) (s : S) : Prop :=
  a.czyn = b.czyn ∧ a.działa s ∧ b.działa s ∧ a.modalność.sprzeczna b.modalność = true

/-- Reguła pierwszeństwa: `a` ustępuje `b` wszędzie tam, gdzie `b` działa. -/
def Norma.ustępuje (a b : Norma S C) : Norma S C :=
  { a with wyjątek := fun s => a.wyjątek s ∨ b.działa s }

/-- Każda reguła pierwszeństwa usuwa kolizję. Wybór reguły należy jednak do wykładni. -/
theorem ustąpienie_usuwa_kolizję (a b : Norma S C) (s : S) :
    ¬ Kolizja (a.ustępuje b) b s := by
  intro ⟨_, ha, hb, _⟩
  exact ha.2 (Or.inr hb)

end Konstytucja
