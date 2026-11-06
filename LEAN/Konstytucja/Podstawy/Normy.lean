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

/-- Wybór czynności `w` spełnia działającą normę. Dozwolenie niczego nie wymaga. -/
def Norma.spełniona (n : Norma S C) (w : C → Bool) (s : S) : Prop :=
  n.działa s → match n.modalność with
    | .nakaz => w n.czyn = true
    | .zakaz => w n.czyn = false
    | .dozwolenie => True

/-- Istnieje wybór czynności spełniający naraz wszystkie normy z listy. -/
def Wykonalny (l : List (Norma S C)) (s : S) : Prop :=
  ∃ w : C → Bool, ∀ n ∈ l, n.spełniona w s

/-- Działający nakaz i zakaz tego samego czynu wykluczają wykonalność. -/
theorem nakaz_i_zakaz_niewykonalne {l : List (Norma S C)} {a b : Norma S C} {s : S}
    (ma : a ∈ l) (mb : b ∈ l) (na : a.modalność = .nakaz) (zb : b.modalność = .zakaz)
    (c : a.czyn = b.czyn) (da : a.działa s) (db : b.działa s) : ¬ Wykonalny l s := by
  rintro ⟨w, h⟩
  have p := h a ma da
  have q := h b mb db
  simp only [na, zb] at p q
  rw [c, q] at p
  cases p

/-- Bez działającej pary nakaz i zakaz tego samego czynu lista jest wykonalna. -/
theorem brak_pary_daje_wykonalność (l : List (Norma S C)) (s : S)
    (h : ∀ a ∈ l, ∀ b ∈ l, a.modalność = .nakaz → b.modalność = .zakaz →
      a.działa s → b.działa s → a.czyn ≠ b.czyn) : Wykonalny l s := by
  classical
  refine ⟨fun c => decide (∃ a ∈ l, a.modalność = .nakaz ∧ a.działa s ∧ a.czyn = c), ?_⟩
  intro n m d
  cases q : n.modalność with
  | nakaz =>
    simp only
    exact decide_eq_true ⟨n, m, q, d, rfl⟩
  | zakaz =>
    simp only
    apply decide_eq_false
    rintro ⟨a, ma, na, da, e⟩
    exact h a ma n m na q da d e
  | dozwolenie => simp only

end Konstytucja
