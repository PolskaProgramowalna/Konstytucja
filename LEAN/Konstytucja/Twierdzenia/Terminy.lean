import Konstytucja.Podstawy.Czas

/-! # Terminy -/

namespace Konstytucja

/-- T7: art. 230. -/
theorem stan_wyjątkowy_max (s : StanWyjątkowy) : s.czasŁączny ≤ 150 := by
  have := s.podstawowyWLimicie
  have := s.przedłużenieWLimicie
  simp only [StanWyjątkowy.czasŁączny]
  omega

/-- Granica 150 dni jest osiągalna. -/
theorem stan_wyjątkowy_150 : ∃ s : StanWyjątkowy, s.czasŁączny = 150 :=
  ⟨⟨90, 60, by decide, by decide⟩, rfl⟩

/-- Art. 231 zd. 1: przedstawienie w chwili podpisania mieści się w terminie. -/
theorem przedstawienie_od_razu (K : Kalendarz) (c : Nat) :
    przedstawienieRozporządzenia K c c := by
  simp [przedstawienieRozporządzenia, wTerminie, koniecTerminu]

end Konstytucja
