/-! # Wspólne pojęcia automatów procedur -/

namespace Konstytucja

/-- Przebieg: zero lub więcej kroków relacji `R`. -/
inductive Przebieg {S : Type} (R : S → S → Prop) : S → S → Prop where
  | stój (s) : Przebieg R s s
  | dalej {a b c} : R a b → Przebieg R b c → Przebieg R a c

/-- Miara malejąca w każdym kroku wyklucza nieskończony przebieg. -/
theorem brak_nieskończonego {S : Type} {R : S → S → Prop} (miara : S → Nat)
    (h : ∀ {a b}, R a b → miara b < miara a) (f : Nat → S) :
    ¬ ∀ n, R (f n) (f (n + 1)) := by
  intro k
  have p : ∀ n, miara (f n) + n ≤ miara (f 0) := by
    intro n
    induction n with
    | zero => omega
    | succ n ih =>
      have := h (k n)
      omega
  have := p (miara (f 0) + 1)
  omega

/-- Malejąca miara i brak utknięcia poza stanami końcowymi dają dojście do końca. -/
theorem dojście_do_końca {S : Type} {R : S → S → Prop} (miara : S → Nat) (końcowy : S → Prop)
    (h : ∀ {a b}, R a b → miara b < miara a)
    (postęp : ∀ s, ¬ końcowy s → ∃ s', R s s') (s : S) :
    ∃ s', Przebieg R s s' ∧ końcowy s' := by
  suffices p : ∀ n s, miara s ≤ n → ∃ s', Przebieg R s s' ∧ końcowy s' from
    p _ s (Nat.le_refl _)
  intro n
  induction n with
  | zero =>
    intro s l
    by_cases k : końcowy s
    · exact ⟨s, .stój s, k⟩
    · obtain ⟨u, r⟩ := postęp s k
      have := h r
      omega
  | succ n ih =>
    intro s l
    by_cases k : końcowy s
    · exact ⟨s, .stój s, k⟩
    · obtain ⟨u, r⟩ := postęp s k
      have := h r
      obtain ⟨v, p, kv⟩ := ih u (by omega)
      exact ⟨v, .dalej r p, kv⟩

end Konstytucja
