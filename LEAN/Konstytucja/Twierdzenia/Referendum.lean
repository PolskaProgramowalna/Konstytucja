import Konstytucja.Procedury.Referendum
import Konstytucja.Procedury.ZmianaKonstytucji

/-! # Własności referendum ogólnokrajowego -/

namespace Konstytucja.Referendum

open Konstytucja Mianownik

variable {Z : Założenia}

private theorem refl (t : Nat) : wLimicie Z t t := wLimicieCzasu_refl _ t

private def pusty : Głosowanie .sejm := ⟨0, 0, 0, by decide⟩
private def pełny : Głosowanie .sejm := ⟨460, 0, 0, by decide⟩
private def pustySenat : Głosowanie .senat := ⟨0, 0, 0, by decide⟩
private def pełnySenat : Głosowanie .senat := ⟨100, 0, 0, by decide⟩

private theorem pełny_uchwala (m) : zarządzenieSejmu m pełny := by
  cases m <;>
    simp [zarządzenieSejmu, kworum, większośćBezwzględna, pełny, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba]

private theorem pusty_nie_uchwala (m) : ¬ zarządzenieSejmu m pusty := by
  simp [zarządzenieSejmu, kworum, pusty, Głosowanie.głosujący, Izba.ustawowaLiczba]

private theorem pełnySenat_zgoda (m) : zgodaSenatu m pełnySenat := by
  cases m <;>
    simp [zgodaSenatu, kworum, większośćBezwzględna, pełnySenat, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba]

private theorem pustySenat_brak (m) : ¬ zgodaSenatu m pustySenat := by
  simp [zgodaSenatu, kworum, pustySenat, Głosowanie.głosujący, Izba.ustawowaLiczba]

/-! ## Progi i wynik -/

/-- Art. 125 ust. 2: droga przez Sejm. -/
theorem min_sejm : JestMinimum (zarządzenieSejmu wszyscyGłosujący) 116 :=
  ⟨⟨⟨116, 114, 0, by decide⟩, by
    simp [zarządzenieSejmu, kworum, większośćBezwzględna, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba], rfl⟩, fun g h => by
    simp only [zarządzenieSejmu, kworum, większośćBezwzględna, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba] at h
    omega⟩

/-- Art. 125 ust. 2: zgoda Senatu. -/
theorem min_senat : JestMinimum (zgodaSenatu wszyscyGłosujący) 26 :=
  ⟨⟨⟨26, 24, 0, by decide⟩, by
    simp [zgodaSenatu, kworum, większośćBezwzględna, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba], rfl⟩, fun g h => by
    simp only [zgodaSenatu, kworum, większośćBezwzględna, Głosowanie.głosujący,
      Głosowanie.mianownik, Izba.ustawowaLiczba] at h
    omega⟩

/-- Art. 125 ust. 3: dokładnie połowa uprawnionych nie wystarcza. -/
theorem połowa_nie_wiąże (w : Wynik) (h : 2 * w.udział = w.uprawnieni) : ¬ wiąże w := by
  simp only [wiąże]
  omega

/-- Remis nie rozstrzyga (założenie Q1). -/
theorem remis_nie_rozstrzyga (w : Wynik) (h : w.za = w.przeciw) : ¬ rozstrzyga w := by
  simp only [rozstrzyga]
  omega

/-- Wiążący udział nie wymaga większości uprawnionych „za”: przy głosach nieważnych
w modelu rozstrzyga jeden głos (założenia Q1–Q2). -/
theorem wiążące_jednym_głosem :
    ∃ w : Wynik, wiąże w ∧ rozstrzyga w ∧ w.za = 1 ∧ w.uprawnieni = 100 :=
  ⟨⟨100, 51, 1, 0, by decide, by decide⟩, by simp [wiąże], by simp [rozstrzyga], rfl, rfl⟩

/-- Art. 235 ust. 6 jest łagodniejszy niż art. 125 ust. 3: ten sam wynik przyjmuje zmianę
Konstytucji, choć w referendum z art. 125 nie byłby wiążący. -/
theorem art235_łagodniejszy_od_art125 :
    ∃ w : Wynik, ¬ wiąże w ∧ ZmianaKonstytucji.przyjęta ⟨w.za, w.przeciw⟩ :=
  ⟨⟨100, 1, 1, 0, by decide, by decide⟩, by simp [wiąże],
   by simp [ZmianaKonstytucji.przyjęta]⟩

/-! ## Osiągalność -/

theorem zarządzone_przez_sejm (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true) :
    Osiągalny Z ⟨.zarządzone, 0⟩ :=
  .krok .start (.zarządzenie pełny q s (pełny_uchwala _) (refl 0))

theorem do_senatu (q : Z.szczególneZnaczenie = true) (p : Z.prezydentDziała = true) :
    Osiągalny Z ⟨.zgodaSenatu, 0⟩ :=
  .krok .start (.wniosekPrezydenta q p (refl 0))

theorem zarządzone_przez_prezydenta (q : Z.szczególneZnaczenie = true)
    (p : Z.prezydentDziała = true) (e : Z.senatDziała = true) :
    Osiągalny Z ⟨.zarządzone, 0⟩ :=
  .krok (do_senatu q p) (.zgodaUdzielona pełnySenat e (pełnySenat_zgoda _) (refl 0))

theorem senat_może_odmówić (q : Z.szczególneZnaczenie = true) (p : Z.prezydentDziała = true)
    (e : Z.senatDziała = true) : Osiągalny Z ⟨.niezarządzone, 0⟩ :=
  .krok (do_senatu q p) (.zgodaNieudzielona pustySenat e (pustySenat_brak _) (refl 0))

theorem sejm_może_nie_zarządzić (s : Z.sejmDziała = true) : Osiągalny Z ⟨.niezarządzone, 0⟩ :=
  .krok .start (.brakWiększości pusty s (pusty_nie_uchwala _) (refl 0))

theorem wynik_wiążący_osiągalny (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true)
    (d : Z.sądDziała = true) (o : Z.okresOchronny 0 = false) (w : Wynik) (h : wiąże w) :
    Osiągalny Z ⟨.wiążące w, 0⟩ :=
  .krok (.krok (zarządzone_przez_sejm q s) (.głosowanie w o (refl 0)))
    (.wynikWiążący d h (refl 0))

theorem wynik_niewiążący_osiągalny (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true)
    (d : Z.sądDziała = true) (o : Z.okresOchronny 0 = false) (w : Wynik) (h : ¬ wiąże w) :
    Osiągalny Z ⟨.niewiążące w, 0⟩ :=
  .krok (.krok (zarządzone_przez_sejm q s) (.głosowanie w o (refl 0)))
    (.wynikNiewiążący d h (refl 0))

theorem nieważne_osiągalne (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true)
    (d : Z.sądDziała = true) (o : Z.okresOchronny 0 = false) (w : Wynik) :
    Osiągalny Z ⟨.nieważne, 0⟩ :=
  .krok (.krok (zarządzone_przez_sejm q s) (.głosowanie w o (refl 0)))
    (.nieważność d (refl 0))

/-! ## Ograniczenia -/

/-- Art. 125 ust. 3: wynik wiążący mają tylko głosowania z udziałem ponad połowy. -/
theorem wiążące_wymaga_udziału {w s} (h : Osiągalny Z s) (e : s.etap = .wiążące w) :
    wiąże w := by
  cases h with
  | start => cases e
  | krok _ k =>
    cases k with
    | wynikWiążący _ b _ => cases e; exact b
    | _ => cases e

/-- Art. 125 ust. 2: bezpośrednio ze sprawy zarządza tylko Sejm wymaganą większością.
Prezydent sam tego nie robi. -/
theorem ze_sprawy_tylko_sejm {t s} (k : Krok Z ⟨.sprawa, t⟩ s) (e : s.etap = .zarządzone) :
    ∃ g, zarządzenieSejmu Z.mianownik g := by
  cases k with
  | zarządzenie g _ _ h _ => exact ⟨g, h⟩
  | brakWiększości => cases e
  | wniosekPrezydenta => cases e

/-- Art. 125 ust. 2: wniosek Prezydenta prowadzi do zarządzenia tylko przez zgodę Senatu. -/
theorem z_wniosku_tylko_zgoda_senatu {t s} (k : Krok Z ⟨.zgodaSenatu, t⟩ s)
    (e : s.etap = .zarządzone) : ∃ g, zgodaSenatu Z.mianownik g := by
  cases k with
  | zgodaUdzielona g _ h _ => exact ⟨g, h⟩
  | zgodaNieudzielona => cases e

/-- Art. 228 ust. 7: głosowanie tylko poza okresem ochronnym. -/
theorem głosowanie_poza_okresem {a b w} (k : Krok Z a b) (e : b.etap = .ważność w) :
    Z.okresOchronny b.dzień = false := by
  cases k with
  | głosowanie _ h _ => exact h
  | _ => cases e

/-- Art. 125 ust. 1: bez sprawy o szczególnym znaczeniu nie ma drogi do zarządzenia. -/
theorem bez_znaczenia_brak_zarządzenia (q : Z.szczególneZnaczenie = false) {s}
    (h : Osiągalny Z s) : s.etap = .sprawa ∨ s.etap = .niezarządzone := by
  induction h with
  | start => simp
  | krok _ k ih =>
    cases k <;> simp_all

/-- Wyniki są ostateczne: stan ustalony nie ma dalszych kroków, poza etapem `sprawa`. -/
theorem wyniki_bez_kroków {t u w} : ¬ Krok Z ⟨.wiążące w, t⟩ u := by
  intro k
  cases k

/-- Żaden krok nie cofa czasu. -/
theorem czas_nie_cofa {a b} (k : Krok Z a b) : a.dzień ≤ b.dzień := by
  cases k <;> simp_all [wLimicie, wLimicieCzasu]

/-! ## Blokady -/

/-- Art. 125 ust. 2 nie podaje terminu Senatowi. -/
theorem bierność_senatu_blokuje (q : Z.szczególneZnaczenie = true)
    (p : Z.prezydentDziała = true) (e : Z.senatDziała = false) :
    Osiągalny Z ⟨.zgodaSenatu, 0⟩ ∧ ∀ u, ¬ Krok Z ⟨.zgodaSenatu, 0⟩ u := by
  refine ⟨do_senatu q p, fun u k => ?_⟩
  cases k <;> simp_all

/-- Art. 228 ust. 7: zarządzone referendum staje przy trwałym okresie ochronnym.
Tekst nie mówi, co dzieje się z takim zarządzeniem. -/
theorem okres_ochronny_blokuje (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true)
    (o : ∀ t, Z.okresOchronny t = true) :
    Osiągalny Z ⟨.zarządzone, 0⟩ ∧ ∀ u, ¬ Krok Z ⟨.zarządzone, 0⟩ u := by
  refine ⟨zarządzone_przez_sejm q s, fun u k => ?_⟩
  cases k with
  | głosowanie _ h _ => rw [o] at h; cases h

/-- Art. 125 ust. 4 nie podaje terminu Sądowi Najwyższemu. -/
theorem bierność_sądu_blokuje (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true)
    (d : Z.sądDziała = false) (b : Z.okresOchronny 0 = false) (w : Wynik) :
    Osiągalny Z ⟨.ważność w, 0⟩ ∧ ∀ u, ¬ Krok Z ⟨.ważność w, 0⟩ u := by
  refine ⟨.krok (zarządzone_przez_sejm q s) (.głosowanie w b (refl 0)), fun u k => ?_⟩
  cases k <;> simp_all

/-! ## Zakończenie i czas -/

theorem krok_zmniejsza {a b} (k : Krok Z a b) : b.etap.ranga < a.etap.ranga := by
  cases k <;> simp [Etap.ranga]

theorem brak_nieskończonego_przebiegu (f : Nat → Stan) :
    ¬ ∀ n, Krok Z (f n) (f (n + 1)) :=
  brak_nieskończonego (fun s => s.etap.ranga) krok_zmniejsza f

structure WarunkiZakończenia (Z : Założenia) : Prop where
  senat : Z.senatDziała = true
  sąd : Z.sądDziała = true
  bezOkresuOchronnego : ∀ t, Z.okresOchronny t = false

theorem postęp (w : WarunkiZakończenia Z) (s : Stan) (n : s.etap.ustalony = false) :
    ∃ u, Krok Z s u := by
  obtain ⟨e, t⟩ := s
  cases e with
  | zgodaSenatu =>
    exact ⟨_, .zgodaNieudzielona pustySenat w.senat (pustySenat_brak _) (refl t)⟩
  | zarządzone =>
    exact ⟨_, .głosowanie ⟨0, 0, 0, 0, by decide, by decide⟩ (w.bezOkresuOchronnego t) (refl t)⟩
  | ważność v => exact ⟨_, .nieważność w.sąd (refl t)⟩
  | sprawa | wiążące _ | niewiążące _ | nieważne | niezarządzone =>
    simp [Etap.ustalony] at n

/-- Przy jawnych warunkach każda sprawa w toku prowadzi do stanu ustalonego. Etap `sprawa`
jest ustalony, bo art. 125 ust. 1 nie nakłada obowiązku działania. -/
theorem zakończenie (w : WarunkiZakończenia Z) (s : Stan) :
    ∃ u, Przebieg (Krok Z) s u ∧ u.etap.ustalony = true :=
  dojście_do_końca (fun s => s.etap.ranga) (fun s => s.etap.ustalony = true) krok_zmniejsza
    (fun s n => postęp w s (by simpa using n)) s

/-- Art. 125 nie podaje terminu: bez limitu głosowanie może nastąpić dowolnie późno. -/
theorem brak_górnej_granicy (q : Z.szczególneZnaczenie = true) (s : Z.sejmDziała = true)
    (b : ∀ t, Z.okresOchronny t = false) (l : Z.limit = none) (n : Nat) (w : Wynik) :
    ∃ u, Osiągalny Z u ∧ u.etap = .ważność w ∧ u.dzień > n := by
  have a : wLimicie Z 0 (n + 1) := by simp [wLimicie, wLimicieCzasu, l]
  exact ⟨_, .krok (zarządzone_przez_sejm q s) (.głosowanie w (b _) a), rfl, by simp⟩

/-- Definicja pomocnicza: górna granica pozostałego czasu przy limicie `L`. -/
def potencjał (L : Nat) (s : Stan) : Nat := L * s.etap.ranga

theorem inwariant_czasu {L s} (l : Z.limit = some L) (h : Osiągalny Z s) :
    s.dzień + potencjał L s ≤ 4 * L := by
  induction h with
  | start => simp [potencjał, Etap.ranga, Nat.mul_comm]
  | krok _ k ih =>
    cases k <;>
      simp only [potencjał, Etap.ranga, wLimicie, wLimicieCzasu, l] at * <;> omega

/-- Przy limicie `L` na każdą czynność procedura trwa najwyżej `4L` dni. -/
theorem granica_czasu {L s} (l : Z.limit = some L) (h : Osiągalny Z s) : s.dzień ≤ 4 * L := by
  have := inwariant_czasu l h
  omega

end Konstytucja.Referendum
