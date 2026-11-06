import Konstytucja.Analiza.SystemNorm

/-! # Własności b i c: wykonalność i rozstrzyganie kolizji -/

namespace Konstytucja.SystemNorm

private theorem działa_iff (i : Id) (s) : (norma i).działa s ↔ (norma i).zakres s := by
  cases i <;> simp [Norma.działa, norma, normaProsta]

/-! ## Własność b: wykonalność -/

/-- System jest wykonalny dokładnie wtedy, gdy nie działa żadna para nakaz i zakaz. -/
theorem wykonalny_iff (s : Sytuacja) : Wykonalny system s ↔ ¬ sprzeczna s := by
  constructor
  · intro w k
    rcases k with ⟨a, b | b⟩ | ⟨a, b⟩ | ⟨a, b, c⟩ | ⟨a, b⟩
    · exact nakaz_i_zakaz_niewykonalne (a := norma .nakaz155) (b := norma .zakaz228Kadencja)
        (by simp [system, wszystkie]) (by simp [system, wszystkie]) rfl rfl rfl
        ((działa_iff _ _).2 a) ((działa_iff _ _).2 b) w
    · exact nakaz_i_zakaz_niewykonalne (a := norma .nakaz155) (b := norma .zakaz131)
        (by simp [system, wszystkie]) (by simp [system, wszystkie]) rfl rfl rfl
        ((działa_iff _ _).2 a) ((działa_iff _ _).2 b) w
    · exact nakaz_i_zakaz_niewykonalne (a := norma .nakaz128) (b := norma .zakaz228Wybory)
        (by simp [system, wszystkie]) (by simp [system, wszystkie]) rfl rfl rfl
        ((działa_iff _ _).2 a) ((działa_iff _ _).2 b) w
    · exact nakaz_i_zakaz_niewykonalne (a := norma .nakaz235Referendum)
        (b := norma .zakaz228Referendum)
        (by simp [system, wszystkie]) (by simp [system, wszystkie]) rfl rfl rfl
        ((działa_iff _ _).2 a) ((działa_iff _ _).2 ⟨b, c⟩) w
    · exact nakaz_i_zakaz_niewykonalne (a := norma .nakaz235Podpis) (b := norma .zakaz228Zmiana)
        (by simp [system, wszystkie]) (by simp [system, wszystkie]) rfl rfl rfl
        ((działa_iff _ _).2 a) ((działa_iff _ _).2 b) w
  · intro n
    apply brak_pary_daje_wykonalność
    intro a ma b mb na zb da db e
    simp only [system, wszystkie, List.mem_map, List.mem_cons, List.not_mem_nil, or_false] at ma mb
    obtain ⟨i, hi, rfl⟩ := ma
    obtain ⟨j, hj, rfl⟩ := mb
    have di := (działa_iff _ _).1 da
    have dj := (działa_iff _ _).1 db
    apply n
    rcases hi with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
      rcases hj with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
      simp_all [norma, normaProsta, sprzeczna]

/-- Zwykła sytuacja bez stanu i bez zastępstwa jest wykonalna. -/
theorem zwykła_sytuacja_wykonalna :
    Wykonalny system ⟨true, false, false, false, true, true, true, true, false⟩ :=
  (wykonalny_iff _).2 (by simp [sprzeczna])

/-- Kolizja art. 155 ust. 2 z art. 228 ust. 7 czyni system niewykonalnym. -/
theorem kolizja_kadencji_niewykonalna :
    ¬ Wykonalny system ⟨true, true, true, false, false, false, false, false, false⟩ := by
  rw [wykonalny_iff]
  simp [sprzeczna]

/-- Wariant V5 zmienia wynik: bez objęcia referendum zakazem system jest wykonalny. -/
theorem wariant_V5_w_systemie :
    Wykonalny system ⟨false, true, false, false, false, true, false, false, false⟩ ∧
      ¬ Wykonalny system ⟨false, true, false, false, false, true, true, false, false⟩ := by
  constructor
  · exact (wykonalny_iff _).2 (by simp [sprzeczna])
  · rw [wykonalny_iff]
    simp [sprzeczna]

/-- Art. 228 ust. 6 nie koliduje z art. 235 ust. 7 po zakończeniu stanu, mimo okresu 90 dni. -/
theorem okres_przejściowy_w_systemie :
    Wykonalny system ⟨false, true, false, false, false, false, false, true, false⟩ :=
  (wykonalny_iff _).2 (by simp [sprzeczna])

/-- Kolizja nie musi znaczyć niewykonalności: art. 225 dozwala, art. 228 ust. 7 zakazuje,
a oba przepisy można spełnić, nie skracając kadencji. -/
theorem dozwolenie_nie_blokuje :
    Kolizja (norma .dozwolenie225) (norma .zakaz228Kadencja)
        ⟨false, true, true, false, false, false, false, false, true⟩ ∧
      Wykonalny system ⟨false, true, true, false, false, false, false, false, true⟩ := by
  constructor
  · simp [Kolizja, Norma.działa, norma, normaProsta, Modalność.sprzeczna]
  · exact (wykonalny_iff _).2 (by simp [sprzeczna])

/-! ## Własność c: rozstrzyganie kolizji -/

/-- Lista par jest pełna: każda działająca para nakaz i zakaz to jedna z pięciu par. -/
theorem pary_pełne (a b : Id) (na : (norma a).modalność = .nakaz)
    (zb : (norma b).modalność = .zakaz) (c : (norma a).czyn = (norma b).czyn) :
    (a, b) ∈ paryNiewykonalne := by
  cases a <;> cases b <;> simp_all [norma, normaProsta, paryNiewykonalne]

/-- Bez dodatkowej reguły żadna para nie jest rozstrzygnięta. -/
theorem tekst_nie_rozstrzyga : ¬ Rozstrzygnięty bezReguł := by
  intro h
  have := h (.nakaz155, .zakaz228Kadencja) (by decide)
  simp [bezReguł] at this

theorem zakazy_rozstrzygają : Rozstrzygnięty zakazyPierwsze := by
  intro p m
  exact .inl (by simpa [zakazyPierwsze] using m)

theorem nakazy_rozstrzygają : Rozstrzygnięty nakazyPierwsze := by
  intro p m
  exact .inr (by simpa [nakazyPierwsze] using m)

/-- Pierwszeństwo zakazów czyni cały system wykonalnym w każdej sytuacji. -/
theorem zakazy_dają_wykonalność (s : Sytuacja) : Wykonalny (systemPo zakazyPierwsze) s := by
  apply brak_pary_daje_wykonalność
  intro a ma b mb na zb da db e
  simp only [systemPo, List.mem_map] at ma mb
  obtain ⟨i, _, rfl⟩ := ma
  obtain ⟨j, _, rfl⟩ := mb
  have zj : (norma j).działa s := by
    refine ⟨db.1, ?_⟩
    simp [norma] at *
    cases j <;> simp [normaProsta]
  have p := pary_pełne i j na zb e
  exact da.2 (Or.inr ⟨j, by simpa [zakazyPierwsze] using p, zj⟩)

/-- Pierwszeństwo nakazów też daje wykonalność, więc logika nie wybiera między nimi. -/
theorem nakazy_dają_wykonalność (s : Sytuacja) : Wykonalny (systemPo nakazyPierwsze) s := by
  apply brak_pary_daje_wykonalność
  intro a ma b mb na zb da db e
  simp only [systemPo, List.mem_map] at ma mb
  obtain ⟨i, _, rfl⟩ := ma
  obtain ⟨j, _, rfl⟩ := mb
  have zi : (norma i).działa s := by
    refine ⟨da.1, ?_⟩
    simp [norma] at *
    cases i <;> simp [normaProsta]
  have p := pary_pełne i j na zb e
  exact db.2 (Or.inr ⟨i, by simpa [nakazyPierwsze] using p, zi⟩)

end Konstytucja.SystemNorm
