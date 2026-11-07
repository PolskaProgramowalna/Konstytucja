import Konstytucja.Twierdzenia.UrządPrezydenta

/-! # Scenariusze wyborów prezydenckich

Dowodzą osiągalności wyników automatu art. 127–130 i spełnialności warunków zakończenia.
Liczby głosów są przykładowe.
-/

namespace Konstytucja.Modele

open WybórPrezydenta

private def kandydatPrzykładowy : Kandydat := ⟨true, 40, true, 100000, 0⟩

private theorem przykładowy_dopuszczalny : dopuszczalny kandydatPrzykładowy := by
  simp [dopuszczalny, kandydatPrzykładowy]

/-- Dwóch kandydatów, kandydat 0 zdobywa całość głosów. -/
def wyboryJednejTury : Założenia where
  tryb := .opróżnienie
  kandydaci := [0, 1]
  bezPowtórzeń := by simp
  dane := fun _ => kandydatPrzykładowy
  wszyscyDopuszczalni := fun _ _ => przykładowy_dopuszczalny
  głosyI := fun k => if k = 0 then 10 else 0
  głosyII := id
  zapas := 0
  dzieńWolny := fun _ => true
  okresOchronny := fun _ => false
  marszałekDziała := true
  sądDziała := true
  limit := none

/-- Trzech kandydatów bez większości: 4, 3 i 3 głosy, a w drugiej turze wygrywa kandydat 1. -/
def wyboryDwóchTur : Założenia :=
  { wyboryJednejTury with
    kandydaci := [0, 1, 2]
    bezPowtórzeń := by simp
    wszyscyDopuszczalni := fun _ _ => przykładowy_dopuszczalny
    głosyI := fun k => if k = 0 then 4 else 3
    zapas := 1 }

/-- Remis w drugiej turze, bez zapasowego kandydata. -/
def wyboryZRemisem : Założenia :=
  { wyboryDwóchTur with głosyII := fun _ => 5, zapas := 0 }

private theorem termin_jednej : terminZarządzenia wyboryJednejTury.tryb 0 0 0 := by
  simp [terminZarządzenia, wyboryJednejTury]

private theorem termin_dwóch : terminZarządzenia wyboryDwóchTur.tryb 0 0 0 := by
  simp [terminZarządzenia, wyboryDwóchTur, wyboryJednejTury]

private theorem termin_remisu : terminZarządzenia wyboryZRemisem.tryb 0 0 0 := by
  simp [terminZarządzenia, wyboryZRemisem, wyboryDwóchTur, wyboryJednejTury]

private theorem większość_zera : większośćI wyboryJednejTury 0 := by
  simp [większośćI, wyboryJednejTury, suma]

theorem wygrana_w_pierwszej_turze :
    Osiągalny wyboryJednejTury ⟨.prezydentWybrany 0, 0, 0⟩ :=
  .krok (.krok (.krok (.krok .start (.zarządzenie rfl termin_jednej rfl))
    (.wygrana 0 (by simp [wyboryJednejTury]) większość_zera rfl))
    (.wybórWażny rfl (wLimicieCzasu_refl _ _))) (.objęcieUrzędu (wLimicieCzasu_refl _ _))

theorem nieważność_w_scenariuszu : Osiągalny wyboryJednejTury ⟨.wybórNieważny, 0, 0⟩ :=
  .krok (.krok (.krok .start (.zarządzenie rfl termin_jednej rfl))
    (.wygrana 0 (by simp [wyboryJednejTury]) większość_zera rfl))
    (.wybórUznanyZaNieważny rfl (wLimicieCzasu_refl _ _))

private theorem bez_większości (Z : Założenia) (hk : Z.kandydaci = [0, 1, 2])
    (hg : Z.głosyI = fun k => if k = 0 then 4 else 3) :
    ∀ k ∈ Z.kandydaci, ¬ większośćI Z k := by
  intro k m
  simp only [większośćI, hk, hg, suma]
  rw [hk] at m
  simp at m
  rcases m with rfl | rfl | rfl <;> simp

private theorem najlepsi (Z : Założenia) (hk : Z.kandydaci = [0, 1, 2])
    (hg : Z.głosyI = fun k => if k = 0 then 4 else 3) : dwajNajlepsi Z 0 1 := by
  simp only [dwajNajlepsi, hk, hg]
  simp

theorem do_drugiej_tury :
    Osiągalny wyboryDwóchTur ⟨.drugaTura 0 1, 14, 1⟩ :=
  .krok (.krok .start (.zarządzenie rfl termin_dwóch rfl))
    (.ponowneGłosowanie 0 1 (najlepsi _ rfl rfl) (bez_większości _ rfl rfl) rfl)

theorem wygrana_w_drugiej_turze :
    Osiągalny wyboryDwóchTur ⟨.prezydentWybrany 1, 14, 1⟩ :=
  .krok (.krok (.krok do_drugiej_tury (.wygranaB (by decide) rfl))
    (.wybórWażny rfl (wLimicieCzasu_refl _ _))) (.objęcieUrzędu (wLimicieCzasu_refl _ _))

/-- Art. 127 ust. 5: wycofanie kandydata odracza głosowanie o 14 dni. -/
theorem wycofanie_odracza : Osiągalny wyboryDwóchTur ⟨.drugaTura 2 1, 28, 0⟩ :=
  .krok do_drugiej_tury (.zastąpienieA 2 (by simp [wyboryDwóchTur]) (by decide) (by decide))

/-- Art. 127 ust. 6 nie rozstrzyga remisu: automat staje w osiągalnym stanie. -/
theorem remis_w_scenariuszu :
    Osiągalny wyboryZRemisem ⟨.drugaTura 0 1, 14, 0⟩ ∧
      ∀ u, ¬ Krok wyboryZRemisem ⟨.drugaTura 0 1, 14, 0⟩ u :=
  ⟨.krok (.krok .start (.zarządzenie rfl termin_remisu rfl))
    (.ponowneGłosowanie 0 1 (najlepsi _ rfl rfl) (bez_większości _ rfl rfl) rfl),
   remis_blokuje rfl⟩

theorem warunki_wyborów_spełnialne : WarunkiZakończenia wyboryJednejTury where
  marszałek := rfl
  sąd := rfl
  dzieńWolny := fun _ => rfl
  bezOkresuOchronnego := fun _ => rfl
  wynikI := .inl ⟨0, by simp [wyboryJednejTury], większość_zera⟩
  bezRemisu := fun _ _ h => h

/-- Urząd z działającymi organami. -/
def urządWedługTekstu : UrządPrezydenta.Założenia where
  marszałekSejmuMoże := true
  trybunałOrzeka := true
  trybunałStanuOrzeka := true
  limit := none

def urządBezMarszałkaSejmu : UrządPrezydenta.Założenia :=
  { urządWedługTekstu with marszałekSejmuMoże := false }

/-- Złożenie: opróżnienie urzędu prowadzi do wyniku wyborów w scenariuszu. -/
theorem opróżnienie_w_modelu (t o p) :
    ∃ u, Przebieg (UrządPrezydenta.PełnyKrok urządWedługTekstu wyboryJednejTury)
      (.inl ⟨.opróżniony p, t, o⟩) (.inr u) ∧ u.etap.końcowy = true :=
  UrządPrezydenta.opróżnienie_prowadzi_do_wyników warunki_wyborów_spełnialne t o p

theorem marszałek_senatu_w_modelu :
    UrządPrezydenta.Osiągalny urządBezMarszałkaSejmu
      ⟨.przejściowaNiemożność, 0, .marszałekSenatu⟩ :=
  UrządPrezydenta.do_niemożności

end Konstytucja.Modele
