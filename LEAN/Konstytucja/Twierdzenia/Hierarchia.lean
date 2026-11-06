import Konstytucja.Podstawy.Akty

/-! # Własności hierarchii aktów -/

namespace Konstytucja

open RodzajAktu

theorem ranga_maleje {a b} (h : MaPierwszeństwo a b) : ranga b < ranga a := by
  cases h with
  | konstytucjaNajwyższa _ hne => cases b <;> first | exact absurd rfl hne | decide
  | _ => decide

theorem ranga_maleje_pośrednio {a b} (h : Wyższy a b) : ranga b < ranga a := by
  induction h with
  | wprost h => exact ranga_maleje h
  | przez _ _ h₁ h₂ => omega

/-- W hierarchii nie ma cykli. -/
theorem brak_cyklu (a) : ¬ Wyższy a a := fun h => by
  have := ranga_maleje_pośrednio h
  omega

/-- Konstytucja jest wyżej od każdego innego aktu (art. 8 ust. 1). -/
theorem konstytucja_najwyższa (a) (h : a ≠ konstytucja) : Wyższy konstytucja a :=
  .wprost (.konstytucjaNajwyższa a h)

/-- Także od prawa organizacji międzynarodowej, bo art. 91 ust. 3 mówi tylko o ustawach. -/
theorem konstytucja_przed_prawem_organizacji :
    Wyższy konstytucja prawoOrganizacjiMiędzynarodowej :=
  konstytucja_najwyższa _ (by decide)

/-- Umowa za zgodą jest pośrednio wyżej od rozporządzenia. -/
theorem umowa_przed_rozporządzeniem : Wyższy umowaZaZgodą rozporządzenie :=
  .przez (.wprost .umowaPrzedUstawą) (.wprost .ustawaPrzedRozporządzeniem)

/-- Tekst nie ustala stosunku umowy bez zgody do ustawy. -/
theorem umowa_bez_zgody_nieporównywalna_z_ustawą :
    ¬ Wyższy umowaBezZgody ustawa ∧ ¬ Wyższy ustawa umowaBezZgody :=
  ⟨fun h => by have := ranga_maleje_pośrednio h; simp [ranga] at this,
   fun h => by have := ranga_maleje_pośrednio h; simp [ranga] at this⟩

/-- W samym modelu A1 nie ma też pierwszeństwa między ustawą a rozporządzeniem z mocą ustawy. -/
theorem rozporządzenie_z_mocą_nieporównywalne_z_ustawą :
    ¬ Wyższy rozporządzenieZMocąUstawy ustawa ∧ ¬ Wyższy ustawa rozporządzenieZMocąUstawy :=
  ⟨fun h => by have := ranga_maleje_pośrednio h; simp [ranga] at this,
   fun h => by have := ranga_maleje_pośrednio h; simp [ranga] at this⟩

/-- Art. 93 ust. 1: zarządzenia nie są źródłem powszechnie obowiązującym. -/
theorem zarządzenie_wewnętrzne : zarządzenie.źródłoPowszechne = false := rfl

end Konstytucja
