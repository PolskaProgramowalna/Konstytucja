import Konstytucja.Twierdzenia.TworzenieRządu
import Konstytucja.Twierdzenia.Ustawodawstwo
import Konstytucja.Twierdzenia.ZmianaKonstytucji

/-! # Instancje założeń procedur

Potwierdzają spełnialność warunków z twierdzeń warunkowych (własność a z etapu 6).
Nie dowodzą spójności wszystkich norm ani prawnej trafności wariantów.
-/

namespace Konstytucja.Modele

/-- Tekst bez dodatkowych limitów, wszystkie organy działają. -/
def ustawaWedługTekstu : Ustawodawstwo.Założenia where
  rodzaj := .zwykły
  pilny := false
  pilnośćDopuszczalna := by simp
  mianownik := .wszyscyGłosujący
  sejmDziała := true
  prezydentDziała := true
  trybunałOrzeka := true
  limit := none
  maksPowrotów := none
  powrótPrzezSenat := false

/-- Założenia U6 i U7: limit 30 dni i jeden zwrot. -/
def ustawaZLimitami : Ustawodawstwo.Założenia :=
  { ustawaWedługTekstu with limit := some 30, maksPowrotów := some 1 }

/-- Tryb pilny z powrotem przez Senat. -/
def ustawaPilna : Ustawodawstwo.Założenia :=
  { ustawaWedługTekstu with
    pilny := true
    pilnośćDopuszczalna := fun _ => rfl
    powrótPrzezSenat := true }

def ustawaBezOrzeczenia : Ustawodawstwo.Założenia :=
  { ustawaWedługTekstu with trybunałOrzeka := false }

def ustawaBezPrezydenta : Ustawodawstwo.Założenia :=
  { ustawaWedługTekstu with prezydentDziała := false }

theorem tekst_nie_ogranicza_powrotów (n : Nat) :
    ∃ u, Ustawodawstwo.Osiągalny ustawaWedługTekstu u ∧ u.etap = .prezydent ∧ u.powroty = n :=
  Ustawodawstwo.dowolnie_wiele_powrotów rfl rfl rfl rfl n

theorem pilna_też_może_wracać (n : Nat) :
    ∃ u, Ustawodawstwo.Osiągalny ustawaPilna u ∧ u.etap = .prezydent ∧ u.powroty = n :=
  Ustawodawstwo.dowolnie_wiele_powrotów rfl rfl rfl rfl n

theorem tekst_nie_ogranicza_czasu (n : Nat) :
    ∃ u, Ustawodawstwo.Osiągalny ustawaWedługTekstu u ∧ u.etap = .podpisana ∧ u.dzień > n :=
  Ustawodawstwo.brak_górnej_granicy rfl rfl rfl rfl n

theorem limity_dają_granicę {s} (h : Ustawodawstwo.Osiągalny ustawaZLimitami s) :
    s.dzień ≤ 356 :=
  Ustawodawstwo.granica_przy_limitach (L := 30) (m := 1) rfl rfl h

theorem limity_dają_zakończenie (s : Ustawodawstwo.Stan) :
    ∃ u, Przebieg (Ustawodawstwo.Krok ustawaZLimitami) s u ∧ u.etap.końcowy = true :=
  Ustawodawstwo.zakończenie ⟨rfl, rfl, rfl⟩ (m := 1) rfl s

example :=
  Ustawodawstwo.brak_orzeczenia_blokuje (Z := ustawaBezOrzeczenia) rfl rfl rfl

example :=
  Ustawodawstwo.bezczynność_prezydenta_blokuje (Z := ustawaBezPrezydenta) rfl rfl

/-- Tworzenie rządu poza stanem nadzwyczajnym, bez dodatkowego limitu. -/
def rządWedługTekstu : TworzenieRządu.Założenia where
  prezydentDziała := true
  okresOchronny := fun _ => false
  rozstrzygnięcie := .pierwszeństwoArt228
  limit := none

/-- Trwały okres ochronny przy pierwszeństwie art. 228 ust. 7. -/
def rządWOkresieOchronnym : TworzenieRządu.Założenia :=
  { rządWedługTekstu with okresOchronny := fun _ => true }

theorem warunki_zakończenia_spełnialne : TworzenieRządu.WarunkiZakończenia rządWedługTekstu :=
  ⟨rfl, fun t => ⟨t, wLimicieCzasu_refl _ t, Or.inl rfl⟩⟩

theorem blokada_okresu_ochronnego (s t) :
    ¬ TworzenieRządu.Krok rządWOkresieOchronnym ⟨.skrócenie, t⟩ s :=
  TworzenieRządu.trwały_okres_ochronny_blokuje rfl (fun _ => rfl) s t

/-- Zmiana spoza rozdziałów I, II i XII, bez stanu nadzwyczajnego i bez limitu. -/
def zmianaZwykła : ZmianaKonstytucji.Założenia where
  chroniona := false
  wnioskodawca := .posłowie 92
  wnioskodawcaUprawniony := by
    simp [ZmianaKonstytucji.Wnioskodawca.uprawniony, Izba.ustawowaLiczba]
  mianownik := .wszyscyGłosujący
  sejmDziała := true
  prezydentDziała := true
  sądDziała := true
  trybunałOrzeka := true
  trybunałPrzedPodpisem := false
  stanNadzwyczajny := fun _ => false
  okresOchronny := fun _ => false
  stanWOkresie := by simp
  zakazDotyczyReferendum := true
  limit := none

def zmianaChroniona : ZmianaKonstytucji.Założenia :=
  { zmianaZwykła with chroniona := true }

/-- Tryb chroniony z limitem 30 dni. -/
def zmianaZLimitem : ZmianaKonstytucji.Założenia :=
  { zmianaChroniona with limit := some 30 }

/-- Trwały okres ochronny bez stanu nadzwyczajnego, z zakazem referendum. -/
def zmianaWOkresieOchronnym : ZmianaKonstytucji.Założenia :=
  { zmianaChroniona with
    okresOchronny := fun _ => true
    stanWOkresie := fun _ _ => rfl }

/-- Ten sam okres ochronny, ale zakaz nie obejmuje referendum z art. 235 ust. 6. -/
def zmianaBezZakazu : ZmianaKonstytucji.Założenia :=
  { zmianaWOkresieOchronnym with zakazDotyczyReferendum := false }

theorem warunki_zmiany_spełnialne : ZmianaKonstytucji.WarunkiZakończenia zmianaChroniona :=
  ⟨rfl, rfl, rfl, rfl, fun _ => rfl⟩

theorem zwykła_30_dni :
    ∃ u, ZmianaKonstytucji.Osiągalny zmianaZwykła u ∧ u.etap = .podpisana ∧ u.dzień = 30 :=
  ZmianaKonstytucji.podpisana_zwykła rfl rfl rfl (fun _ => rfl)

theorem chroniona_135_dni :
    ∃ u, ZmianaKonstytucji.Osiągalny zmianaChroniona u ∧ u.etap = .podpisana ∧
      u.dzień = 135 ∧ u.referendum = false :=
  ZmianaKonstytucji.podpisana_chroniona rfl rfl rfl (fun _ => rfl)

theorem chroniona_90_dni_z_referendum :
    ∃ u, ZmianaKonstytucji.Osiągalny zmianaChroniona u ∧ u.etap = .podpisana ∧
      u.dzień = 90 ∧ u.referendum = true :=
  ZmianaKonstytucji.podpisana_z_referendum rfl rfl rfl rfl (fun _ => rfl)

theorem limit_daje_granicę_zmiany {s} (h : ZmianaKonstytucji.Osiągalny zmianaZLimitem s) :
    s.dzień ≤ 426 :=
  ZmianaKonstytucji.granica_czasu (L := 30) rfl h

example := ZmianaKonstytucji.okres_ochronny_blokuje_referendum
  (Z := zmianaWOkresieOchronnym) rfl rfl rfl (fun _ => rfl)

theorem zakaz_nie_obejmuje_referendum :
    ∃ u, ZmianaKonstytucji.Osiągalny zmianaBezZakazu u ∧ u.etap = .ważność :=
  ZmianaKonstytucji.bez_zakazu_referendum_możliwe rfl rfl rfl

end Konstytucja.Modele
