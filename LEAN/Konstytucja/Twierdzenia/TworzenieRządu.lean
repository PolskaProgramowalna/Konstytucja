import Konstytucja.Procedury.TworzenieRządu

/-! # Własności procedury z art. 154–155

Grupy wyników: osiągalność, ograniczenia, zakończenie przy jawnych założeniach
oraz brak górnej granicy czasu. Ta ostatnia jest wynikiem analizy, a nie usterką modelu.
-/

namespace Konstytucja.TworzenieRządu

variable {Z : Założenia}

/-! ## Osiągalność -/

private theorem wLimicie_refl (t : Nat) : wLimicie Z t t := by
  simp only [wLimicie]
  split <;> simp

theorem rząd_w_art154 (h : Z.prezydentDziała = true) : Osiągalny Z ⟨.rząd, 0⟩ :=
  .krok (.krok .start (.powołanie (t' := 0) h (by simp [wCiągu]))) (.wotumTak (by simp [wCiągu]))

theorem rząd_w_art154_ust3 (h : Z.prezydentDziała = true) : Osiągalny Z ⟨.rząd, 14⟩ :=
  .krok (.krok (.krok .start .niepowołanie) (.wybór (t' := 14) (by simp [wCiągu])))
    (.powołanieWybranych h (wLimicie_refl _))

theorem rząd_w_art155 (h : Z.prezydentDziała = true) : Osiągalny Z ⟨.rząd, 28⟩ :=
  .krok (.krok (.krok (.krok .start .niepowołanie) .brakWyboru)
    (.powołanie155 (t' := 28) h (by simp [wCiągu]))) (.wotum155Tak (by simp [wCiągu]))

theorem etap_skrócenia_osiągalny (h : Z.prezydentDziała = true) :
    Osiągalny Z ⟨.skrócenie, 42⟩ :=
  .krok (.krok (.krok (.krok .start .niepowołanie) .brakWyboru)
    (.powołanie155 (t' := 28) h (by simp [wCiągu]))) .wotum155Nie

theorem skrócenie_osiągalne (h : Z.prezydentDziała = true) (d : skrócenieDozwolone Z 42) :
    Osiągalny Z ⟨.kadencjaSkrócona, 42⟩ :=
  .krok (etap_skrócenia_osiągalny h) (.skrócenie h (wLimicie_refl _) d)

/-! ## Ograniczenia -/

/-- Najpóźniejszy dzień wejścia do etapu, gdy terminy wynikają z tekstu. -/
def wGranicy (s : Stan) : Prop :=
  match s.etap with
  | .powołanie154 => s.dzień = 0
  | .wotum154 => s.dzień ≤ 14
  | .wybórSejmu => s.dzień ≤ 28
  | .powołanieWybranych | .powołanie155 => s.dzień ≤ 42
  | .wotum155 => s.dzień ≤ 56
  | .skrócenie => s.dzień ≤ 70
  | .rząd | .kadencjaSkrócona => True

/-- Do decyzji o skróceniu kadencji z art. 155 ust. 2 upływa najwyżej 70 dni. -/
theorem granice_etapów {s} (h : Osiągalny Z s) : wGranicy s := by
  induction h with
  | start => simp [wGranicy]
  | krok _ k ih =>
    cases k <;> simp only [wGranicy, wCiągu] at * <;> omega

/-- Przy pierwszeństwie art. 228 ust. 7 nie ma skrócenia w okresie ochronnym. -/
theorem skrócenie_poza_okresem_ochronnym (h : Z.rozstrzygnięcie = .pierwszeństwoArt228)
    {s t} (k : Krok Z s ⟨.kadencjaSkrócona, t⟩) : Z.okresOchronny t = false := by
  cases k with
  | skrócenie _ _ d =>
    cases d with
    | inl d => exact d
    | inr d => rw [h] at d; cases d

/-- Przy pierwszeństwie art. 155 ust. 2 skrócenie jest możliwe także w okresie ochronnym. -/
theorem skrócenie_w_okresie_ochronnym (h : Z.prezydentDziała = true)
    (r : Z.rozstrzygnięcie = .pierwszeństwoArt155) :
    Osiągalny Z ⟨.kadencjaSkrócona, 42⟩ :=
  skrócenie_osiągalne h (Or.inr r)

/-- Przy dodatkowym limicie (P4) czas całej procedury jest ograniczony. -/
theorem granica_przy_limicie {L s} (l : Z.limit = some L) (h : Osiągalny Z s) :
    (s.etap = .rząd → s.dzień ≤ 70 + L) ∧ (s.etap = .kadencjaSkrócona → s.dzień ≤ 70 + L) := by
  cases h with
  | start => simp
  | krok p k =>
    have g := granice_etapów p
    cases k <;> simp only [wGranicy, wCiągu, wLimicie, l] at * <;> simp <;> omega

/-! ## Zakończenie -/

theorem krok_zmniejsza {s s'} (k : Krok Z s s') : s'.etap.pozostało < s.etap.pozostało := by
  cases k <;> simp [Etap.pozostało]

/-- Nie ma nieskończonego przebiegu, przy każdych założeniach. -/
theorem brak_nieskończonego_przebiegu (f : Nat → Stan) :
    ¬ ∀ n, Krok Z (f n) (f (n + 1)) := by
  intro h
  have p : ∀ n, (f n).etap.pozostało + n ≤ (f 0).etap.pozostało := by
    intro n
    induction n with
    | zero => omega
    | succ n ih =>
      have := krok_zmniejsza (h n)
      omega
  have := p ((f 0).etap.pozostało + 1)
  omega

/-- Założenia zakończenia: Prezydent działa, a kadencję da się kiedyś skrócić. -/
structure WarunkiZakończenia (Z : Założenia) : Prop where
  prezydent : Z.prezydentDziała = true
  skrócenie : ∀ t, ∃ t', wLimicie Z t t' ∧ skrócenieDozwolone Z t'

/-- Przy tych warunkach każdy etap niekońcowy ma następnika. -/
theorem postęp (w : WarunkiZakończenia Z) (s : Stan) (n : s.etap.końcowy = false) :
    ∃ s', Krok Z s s' := by
  obtain ⟨e, t⟩ := s
  have p := w.prezydent
  cases e with
  | powołanie154 => exact ⟨_, .niepowołanie⟩
  | wotum154 => exact ⟨_, .wotumNie⟩
  | wybórSejmu => exact ⟨_, .brakWyboru⟩
  | powołanieWybranych => exact ⟨_, .powołanieWybranych p (wLimicie_refl t)⟩
  | powołanie155 => exact ⟨⟨.wotum155, t⟩, .powołanie155 p (by simp [wCiągu])⟩
  | wotum155 => exact ⟨_, .wotum155Nie⟩
  | skrócenie =>
    obtain ⟨t', l, d⟩ := w.skrócenie t
    exact ⟨_, .skrócenie p l d⟩
  | rząd => simp [Etap.końcowy] at n
  | kadencjaSkrócona => simp [Etap.końcowy] at n

/-- Zastępuje szkicowe T6: przy jawnych warunkach z każdego osiągalnego stanu
można dojść do rządu albo skrócenia kadencji. -/
theorem zakończenie (w : WarunkiZakończenia Z) {s} (h : Osiągalny Z s) :
    ∃ s', Osiągalny Z s' ∧ (s'.etap = .rząd ∨ s'.etap = .kadencjaSkrócona) := by
  suffices p : ∀ n s, s.etap.pozostało ≤ n → Osiągalny Z s →
      ∃ s', Osiągalny Z s' ∧ (s'.etap = .rząd ∨ s'.etap = .kadencjaSkrócona) from
    p _ s (Nat.le_refl _) h
  intro n
  induction n with
  | zero =>
    intro s l o
    refine ⟨s, o, ?_⟩
    obtain ⟨e, t⟩ := s
    cases e <;> simp_all [Etap.pozostało]
  | succ n ih =>
    intro s l o
    by_cases k : s.etap.końcowy = true
    · refine ⟨s, o, ?_⟩
      obtain ⟨e, t⟩ := s
      cases e <;> simp_all [Etap.końcowy]
    · obtain ⟨s', ks⟩ := postęp w s (by simpa using k)
      have := krok_zmniejsza ks
      exact ih s' (by omega) (.krok o ks)

/-! ## Blokady i brak górnej granicy -/

/-- Art. 154 ust. 3 nie ma terminu: bez limitu rząd może powstać dowolnie późno. -/
theorem brak_górnej_granicy (h : Z.prezydentDziała = true) (l : Z.limit = none) (n : Nat) :
    ∃ t, t > n ∧ Osiągalny Z ⟨.rząd, t⟩ := by
  refine ⟨14 + n + 1, by omega, ?_⟩
  refine .krok (.krok (.krok .start .niepowołanie) (.wybór (t' := 14) (by simp [wCiągu])))
    (.powołanieWybranych h ?_)
  simp [wLimicie, l]
  omega

/-- Bierność Prezydenta przy art. 154 ust. 1 nie blokuje, bo tekst podaje jej skutek. -/
theorem bezczynność_nie_blokuje_art154 :
    Osiągalny Z ⟨.powołanie155, 28⟩ :=
  .krok (.krok .start .niepowołanie) .brakWyboru

/-- Art. 155 ust. 1 nie przewiduje skutku bezczynności Prezydenta, więc automat staje. -/
theorem bezczynność_blokuje_art155 (h : Z.prezydentDziała = false) (s t) :
    ¬ Krok Z ⟨.powołanie155, t⟩ s := by
  intro k
  cases k with
  | powołanie155 p _ => rw [h] at p; cases p

/-- To samo dotyczy powołania rządu wybranego przez Sejm. -/
theorem bezczynność_blokuje_art154_ust3 (h : Z.prezydentDziała = false) (s t) :
    ¬ Krok Z ⟨.powołanieWybranych, t⟩ s := by
  intro k
  cases k with
  | powołanieWybranych p _ => rw [h] at p; cases p

/-- Przy pierwszeństwie art. 228 ust. 7 i trwałym okresie ochronnym skrócenia nie ma. -/
theorem trwały_okres_ochronny_blokuje (r : Z.rozstrzygnięcie = .pierwszeństwoArt228)
    (o : ∀ t, Z.okresOchronny t = true) (s t) : ¬ Krok Z ⟨.skrócenie, t⟩ s := by
  intro k
  cases k with
  | skrócenie _ _ d =>
    cases d with
    | inl d => rw [o] at d; cases d
    | inr d => rw [r] at d; cases d

end Konstytucja.TworzenieRządu
