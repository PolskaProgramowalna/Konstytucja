import Konstytucja.Procedury.ZmianaKonstytucji

/-! # Własności procedury zmiany Konstytucji

Grupy wyników: osiągalność, ograniczenia i najwcześniejsze terminy, blokady
oraz zakończenie i granica czasu przy jawnych założeniach.
-/

namespace Konstytucja.ZmianaKonstytucji

open Konstytucja

variable {Z : Założenia}

private theorem refl (t : Nat) : wLimicie Z t t := wLimicieCzasu_refl _ t

private theorem okno (t n : Nat) : wOknie Z t n (t + n) := wLimicieCzasu_refl _ _

private theorem wCiągu_refl (t n : Nat) : wCiągu t n t := by simp [wCiągu]

private def pełnySejm : Głosowanie .sejm := ⟨460, 0, 0, by decide⟩
private def pełnySenat : Głosowanie .senat := ⟨100, 0, 0, by decide⟩
private def pustySenat : Głosowanie .senat := ⟨0, 0, 0, by decide⟩

private theorem pełnySejm_uchwala (m) : zmianaKonstytucjiSejm m pełnySejm := by
  cases m <;>
    simp [zmianaKonstytucjiSejm, kworum, większośćUłamkowa, pełnySejm, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba]

private theorem pełnySenat_uchwala (m) : zmianaKonstytucjiSenat m pełnySenat := by
  cases m <;>
    simp [zmianaKonstytucjiSenat, kworum, większośćBezwzględna, pełnySenat,
      Głosowanie.głosujący, Głosowanie.mianownik, Izba.ustawowaLiczba]

private theorem pustySenat_nie_uchwala (m) : ¬ zmianaKonstytucjiSenat m pustySenat := by
  simp [zmianaKonstytucjiSenat, kworum, pustySenat, Głosowanie.głosujący, Izba.ustawowaLiczba]

/-! ## Referendum -/

/-- Art. 235 ust. 6 nie ma progu frekwencji: wystarczy jeden ważny głos „za”. -/
theorem referendum_bez_frekwencji : przyjęta ⟨1, 0⟩ := by simp [przyjęta]

theorem brak_głosów_nie_wystarcza : ¬ przyjęta ⟨0, 0⟩ := by simp [przyjęta]

theorem remis_nie_wystarcza (n : Nat) : ¬ przyjęta ⟨n, n⟩ := by
  simp only [przyjęta]
  omega

/-! ## Osiągalność -/

theorem do_senatu (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.senat, 30 + odstępSejmu Z, 0, false⟩ := by
  have a := Osiągalny.krok .start (.pierwszeCzytanie s (okno 0 30))
  exact .krok a (.uchwalenieSejmu pełnySejm s (pełnySejm_uchwala _) (okno _ _))

theorem podpisana_zwykła (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true)
    (c : Z.chroniona = false) (b : ∀ t, Z.stanNadzwyczajny t = false) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana ∧ u.dzień = 30 := by
  have a := Osiągalny.krok (do_senatu s)
    (.senatUchwala pełnySenat (pełnySenat_uchwala _) (wCiągu_refl _ _) c)
  have d := Osiągalny.krok a (.przedstawienie s (refl _))
  refine ⟨_, .krok d (.podpis (d := 0) p (Nat.zero_le _) (b _)), rfl, ?_⟩
  simp [odstępSejmu, c]

/-- Ustawa chroniona bez referendum: najwcześniej 135. dnia. -/
theorem podpisana_chroniona (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true)
    (c : Z.chroniona = true) (b : ∀ t, Z.stanNadzwyczajny t = false) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana ∧ u.dzień = 135 ∧ u.referendum = false := by
  have a := Osiągalny.krok (do_senatu s)
    (.senatUchwalaChronioną pełnySenat (pełnySenat_uchwala _) (wCiągu_refl _ _) c)
  have e := Osiągalny.krok a .brakŻądania
  have d := Osiągalny.krok e (.przedstawienie s (refl _))
  refine ⟨_, .krok d (.podpis (d := 0) p (Nat.zero_le _) (b _)), rfl, ?_, rfl⟩
  simp [odstępSejmu, c]

theorem do_referendum (s : Z.sejmDziała = true) (c : Z.chroniona = true) :
    Osiągalny Z ⟨.referendum, 30 + odstępSejmu Z, 0, true⟩ :=
  .krok (.krok (do_senatu s)
    (.senatUchwalaChronioną pełnySenat (pełnySenat_uchwala _) (wCiągu_refl _ _) c))
    (.żądanie .senat trivial (wCiągu_refl _ _))

/-- Ustawa chroniona z referendum: najwcześniej 90. dnia, w teorii tego samego dnia. -/
theorem podpisana_z_referendum (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true)
    (d : Z.sądDziała = true) (c : Z.chroniona = true)
    (b : ∀ t, Z.okresOchronny t = false) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana ∧ u.dzień = 90 ∧ u.referendum = true := by
  have nb : ∀ t, Z.stanNadzwyczajny t = false := fun t => by
    cases q : Z.stanNadzwyczajny t with
    | false => rfl
    | true =>
      have := Z.stanWOkresie t q
      rw [b t] at this
      cases this
  have a := Osiągalny.krok (do_referendum s c)
    (.referendumPrzyjęte ⟨1, 0⟩ s referendum_bez_frekwencji (wCiągu_refl _ _) (Or.inl (b _)))
  have e := Osiągalny.krok a (.ważnośćStwierdzona d (refl _))
  have f := Osiągalny.krok e (.przedstawienie s (refl _))
  refine ⟨_, .krok f (.podpis (d := 0) p (Nat.zero_le _) (nb _)), rfl, ?_, rfl⟩
  simp [odstępSejmu, c]

/-- Odrzucenie przez Senat kończy procedurę. -/
theorem upadła_w_senacie (s : Z.sejmDziała = true) :
    ∃ u, Osiągalny Z u ∧ u.etap = .upadła :=
  ⟨_, .krok (do_senatu s)
    (.senatOdrzuca pustySenat (pustySenat_nie_uchwala _) (wCiągu_refl _ _)), rfl⟩

/-- Odrzucenie w referendum kończy procedurę. -/
theorem upadła_w_referendum (s : Z.sejmDziała = true) (c : Z.chroniona = true)
    (b : ∀ t, Z.okresOchronny t = false) :
    ∃ u, Osiągalny Z u ∧ u.etap = .upadła :=
  ⟨_, .krok (do_referendum s c) (.referendumOdrzucone ⟨0, 0⟩ s brak_głosów_nie_wystarcza
    (wCiągu_refl _ _) (Or.inl (b _))), rfl⟩

/-! ## Ograniczenia -/

/-- Art. 235 ust. 2: milczenie Senatu kończy procedurę, inaczej niż art. 121 ust. 2. -/
theorem milczenie_senatu_kończy (t r x) :
    Krok Z ⟨.senat, t, r, x⟩ ⟨.upadła, t + 60, r, x⟩ := .senatMilczy

/-- Art. 235 ust. 7: bez wariantu V8 Prezydent może tylko podpisać. Weta nie ma. -/
theorem tylko_podpis {t r x s} (v : Z.trybunałPrzedPodpisem = false)
    (k : Krok Z ⟨.prezydent, t, r, x⟩ s) : s.etap = .podpisana := by
  cases k with
  | podpis => rfl
  | wniosekDoTrybunału _ _ w => rw [v] at w; cases w

/-- W wariancie V8 z Trybunałem też nie ma drogi z powrotem do Sejmu. -/
theorem brak_powrotu_do_sejmu {t r x s} (k : Krok Z ⟨.prezydent, t, r, x⟩ s) :
    s.etap = .podpisana ∨ s.etap = .trybunał := by
  cases k <;> simp

/-- Art. 228 ust. 6 (V4): nie ma podpisania w czasie stanu nadzwyczajnego. -/
theorem podpis_poza_stanem {a b} (k : Krok Z a b) (e : b.etap = .podpisana) :
    Z.stanNadzwyczajny b.dzień = false := by
  cases k <;> first | assumption | cases e

/-- Niezmiennik: chroniony tryb i najwcześniejsze dni kolejnych etapów. -/
def kres (Z : Założenia) (x : Bool) : Nat :=
  if Z.chroniona then (if x then 90 else 135) else 30

def inwariant (Z : Założenia) (s : Stan) : Prop :=
  match s.etap with
  | .upadła => True
  | .przedCzytaniem => s.referendum = false
  | .poCzytaniu => 30 ≤ s.dzień ∧ s.referendum = false
  | .senat => 30 + odstępSejmu Z ≤ s.dzień ∧ s.referendum = false
  | .oczekiwanie => Z.chroniona = true ∧ 90 ≤ s.dzień ∧ s.referendum = false
  | .referendum | .ważność => Z.chroniona = true ∧ 90 ≤ s.dzień ∧ s.referendum = true
  | .marszałek | .prezydent | .trybunał | .podpisPoTrybunale | .podpisana =>
      kres Z s.referendum ≤ s.dzień

theorem inwariant_procedury {s} (h : Osiągalny Z s) : inwariant Z s := by
  induction h with
  | start => simp [inwariant]
  | krok _ k ih =>
    cases l : Z.limit <;> cases c : Z.chroniona <;> cases k <;>
      simp_all [inwariant, kres, odstępSejmu, wCiągu, wOknie, wLimicie, wLimicieCzasu] <;> omega

/-- Art. 235 ust. 3: bez trybu chronionego ustawa nie może być podpisana przed 30. dniem. -/
theorem najwcześniej_zwykła {s} (h : Osiągalny Z s) (e : s.etap = .podpisana) : 30 ≤ s.dzień := by
  have i := inwariant_procedury h
  obtain ⟨u, t, r, x⟩ := s
  simp only at e
  subst e
  show 30 ≤ t
  simp only [inwariant, kres] at i
  split at i
  · split at i <;> omega
  · omega

/-- Art. 235 ust. 3 i 5–7: ustawa chroniona bez referendum najwcześniej 135. dnia. -/
theorem najwcześniej_chroniona {s} (c : Z.chroniona = true) (h : Osiągalny Z s)
    (e : s.etap = .podpisana) (r : s.referendum = false) : 135 ≤ s.dzień := by
  have i := inwariant_procedury h
  obtain ⟨u, t, q, x⟩ := s
  simp only at e r
  subst e r
  simpa [inwariant, kres, c] using i

/-- Art. 235 ust. 3 i 5: ustawa chroniona z referendum najwcześniej 90. dnia. -/
theorem najwcześniej_z_referendum {s} (c : Z.chroniona = true) (h : Osiągalny Z s)
    (e : s.etap = .podpisana) : 90 ≤ s.dzień := by
  have i := inwariant_procedury h
  obtain ⟨u, t, q, x⟩ := s
  simp only at e
  subst e
  show 90 ≤ t
  cases x <;> simp [inwariant, kres, c] at i <;> omega

/-- Referendum tylko dla ustaw z rozdziałów I, II lub XII. -/
theorem referendum_tylko_chronione {s} (h : Osiągalny Z s) (e : s.etap = .referendum) :
    Z.chroniona = true := by
  have i := inwariant_procedury h
  obtain ⟨u, t, q, x⟩ := s
  simp only at e
  subst e
  exact i.1

/-! ## Blokady -/

/-- Art. 235 ust. 6 a art. 228 ust. 7: przy wariancie V5 z zakazem i trwałym okresie
ochronnym referendum nie może się odbyć, a procedura staje. -/
theorem okres_ochronny_blokuje_referendum (s : Z.sejmDziała = true) (c : Z.chroniona = true)
    (v : Z.zakazDotyczyReferendum = true) (o : ∀ t, Z.okresOchronny t = true) :
    Osiągalny Z ⟨.referendum, 30 + odstępSejmu Z, 0, true⟩ ∧
      ∀ u, ¬ Krok Z ⟨.referendum, 30 + odstępSejmu Z, 0, true⟩ u := by
  refine ⟨do_referendum s c, fun u k => ?_⟩
  cases k with
  | referendumPrzyjęte _ _ _ _ d => simp [referendumDozwolone, o, v] at d
  | referendumOdrzucone _ _ _ _ d => simp [referendumDozwolone, o, v] at d

/-- Przy wariancie V5 bez zakazu ten sam okres ochronny referendum nie blokuje. -/
theorem bez_zakazu_referendum_możliwe (s : Z.sejmDziała = true) (c : Z.chroniona = true)
    (v : Z.zakazDotyczyReferendum = false) :
    ∃ u, Osiągalny Z u ∧ u.etap = .ważność :=
  ⟨_, .krok (do_referendum s c) (.referendumPrzyjęte ⟨1, 0⟩ s referendum_bez_frekwencji
    (wCiągu_refl _ _) (Or.inr v)), rfl⟩

/-- Art. 235 ust. 7 nie przewiduje skutku bezczynności Prezydenta. -/
theorem bezczynność_prezydenta_blokuje (p : Z.prezydentDziała = false) (t r x u) :
    ¬ Krok Z ⟨.prezydent, t, r, x⟩ u := by
  intro k
  cases k <;> simp_all

/-- Podpis w ostatnim dniu może nie być możliwy, gdy trwa stan nadzwyczajny. -/
theorem stan_nadzwyczajny_blokuje_podpis (b : ∀ t, Z.stanNadzwyczajny t = true)
    (v : Z.trybunałPrzedPodpisem = false) (t r x u) :
    ¬ Krok Z ⟨.prezydent, t, r, x⟩ u := by
  intro k
  cases k with
  | podpis _ _ s => rw [b] at s; cases s
  | wniosekDoTrybunału _ _ w => rw [v] at w; cases w

/-! ## Zakończenie i czas -/

theorem krok_zmniejsza {a b} (k : Krok Z a b) : b.etap.ranga < a.etap.ranga := by
  cases k <;> simp [Etap.ranga]

/-- Inaczej niż art. 122 ust. 4, ta procedura nie ma powrotów. -/
theorem brak_nieskończonego_przebiegu (f : Nat → Stan) :
    ¬ ∀ n, Krok Z (f n) (f (n + 1)) :=
  brak_nieskończonego (fun s => s.etap.ranga) krok_zmniejsza f

structure WarunkiZakończenia (Z : Założenia) : Prop where
  sejm : Z.sejmDziała = true
  prezydent : Z.prezydentDziała = true
  sąd : Z.sądDziała = true
  trybunał : Z.trybunałOrzeka = true
  bezOkresuOchronnego : ∀ t, Z.okresOchronny t = false

theorem postęp (w : WarunkiZakończenia Z) (s : Stan) (n : s.etap.końcowy = false) :
    ∃ u, Krok Z s u := by
  obtain ⟨e, t, r, x⟩ := s
  have hs := w.sejm
  have hp := w.prezydent
  have hd := w.sąd
  have ht := w.trybunał
  have nb : ∀ t, Z.stanNadzwyczajny t = false := fun t => by
    cases q : Z.stanNadzwyczajny t with
    | false => rfl
    | true =>
      have := Z.stanWOkresie t q
      rw [w.bezOkresuOchronnego t] at this
      cases this
  cases e with
  | przedCzytaniem => exact ⟨_, .pierwszeCzytanie hs (okno t 30)⟩
  | poCzytaniu => exact ⟨_, .uchwalenieSejmu pełnySejm hs (pełnySejm_uchwala _) (okno t _)⟩
  | senat => exact ⟨_, .senatMilczy⟩
  | oczekiwanie => exact ⟨_, .brakŻądania⟩
  | referendum =>
    exact ⟨_, .referendumOdrzucone ⟨0, 0⟩ hs brak_głosów_nie_wystarcza (wCiągu_refl t 60)
      (Or.inl (w.bezOkresuOchronnego t))⟩
  | ważność => exact ⟨_, .nieważność hd (refl t)⟩
  | marszałek => exact ⟨_, .przedstawienie hs (refl t)⟩
  | prezydent => exact ⟨_, .podpis (d := 0) hp (Nat.zero_le _) (nb _)⟩
  | trybunał => exact ⟨_, .orzeczenieNiezgodna ht (refl t)⟩
  | podpisPoTrybunale => exact ⟨_, .podpisPoZgodności (d := 0) hp (Nat.zero_le _) (nb _)⟩
  | podpisana | upadła => simp [Etap.końcowy] at n

/-- Przy jawnych warunkach z każdego stanu prowadzi przebieg do wyniku. -/
theorem zakończenie (w : WarunkiZakończenia Z) (s : Stan) :
    ∃ u, Przebieg (Krok Z) s u ∧ u.etap.końcowy = true :=
  dojście_do_końca (fun s => s.etap.ranga) (fun s => s.etap.końcowy = true) krok_zmniejsza
    (fun s n => postęp w s (by simpa using n)) s

/-- Definicja pomocnicza: górna granica pozostałego czasu przy limicie `L`. -/
def potencjał (L : Nat) (s : Stan) : Nat :=
  match s.etap with
  | .przedCzytaniem => 5 * L + 276
  | .poCzytaniu => 4 * L + 246
  | .senat => 3 * L + 186
  | .oczekiwanie => 3 * L + 126
  | .referendum => 3 * L + 81
  | .ważność => 3 * L + 21
  | .marszałek => 2 * L + 21
  | .prezydent => s.pozostało + L
  | .trybunał => s.pozostało + L
  | .podpisPoTrybunale => s.pozostało
  | .podpisana | .upadła => 0

theorem odstęp_le (Z : Założenia) : odstępSejmu Z ≤ 60 := by
  simp only [odstępSejmu]
  split <;> omega

set_option maxRecDepth 4000 in
theorem inwariant_czasu {L s} (l : Z.limit = some L) (h : Osiągalny Z s) :
    s.dzień + potencjał L s ≤ 5 * L + 276 := by
  induction h with
  | start => simp [potencjał]
  | krok _ k ih =>
    have o := odstęp_le Z
    cases k <;>
      simp only [potencjał, wLimicie, wOknie, wLimicieCzasu, wCiągu, l] at * <;> omega

/-- Przy limicie `L` dla czynności bez terminu cała procedura trwa najwyżej `5L + 276` dni. -/
theorem granica_czasu {L s} (l : Z.limit = some L) (h : Osiągalny Z s) :
    s.dzień ≤ 5 * L + 276 := by
  have := inwariant_czasu l h
  omega

/-- Art. 235 ust. 3 nie podaje górnej granicy: bez limitu procedura może trwać dowolnie długo. -/
theorem brak_górnej_granicy (s : Z.sejmDziała = true) (p : Z.prezydentDziała = true)
    (c : Z.chroniona = false) (b : ∀ t, Z.stanNadzwyczajny t = false)
    (l : Z.limit = none) (n : Nat) :
    ∃ u, Osiągalny Z u ∧ u.etap = .podpisana ∧ u.dzień > n := by
  have o : wOknie Z 0 30 (30 + n + 1) := by
    simp only [wOknie, wLimicieCzasu, l]
    exact ⟨by omega, trivial⟩
  have a := Osiągalny.krok .start (.pierwszeCzytanie s o)
  have d := Osiągalny.krok a (.uchwalenieSejmu pełnySejm s (pełnySejm_uchwala _) (okno _ _))
  have e := Osiągalny.krok d
    (.senatUchwala pełnySenat (pełnySenat_uchwala _) (wCiągu_refl _ _) c)
  have f := Osiągalny.krok e (.przedstawienie s (refl _))
  refine ⟨_, .krok f (.podpis (d := 0) p (Nat.zero_le _) (b _)), rfl, ?_⟩
  show 30 + n + 1 + odstępSejmu Z + 0 > n
  omega

end Konstytucja.ZmianaKonstytucji
