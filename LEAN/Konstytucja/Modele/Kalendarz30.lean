import Konstytucja.Podstawy.Czas

/-! # Model kalendarza: dowód, że wymagania `Kalendarz` są niesprzeczne -/

namespace Konstytucja

/-- Uproszczony kalendarz: miesiąc to 30 dni, rok to 365 dni. -/
def kalendarz30 : Kalendarz where
  poMiesiącach d n := d + 30 * n
  poLatach d n := d + 365 * n
  miesiące_zero _ := rfl
  lata_zero _ := rfl
  miesiące_rosną _ _ _ := by omega
  lata_rosną _ _ _ := by omega

end Konstytucja
