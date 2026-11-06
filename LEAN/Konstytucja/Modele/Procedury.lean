import Konstytucja.Twierdzenia.TworzenieRządu
import Konstytucja.Twierdzenia.Ustawodawstwo
import Konstytucja.Twierdzenia.ZmianaKonstytucji
import Konstytucja.Twierdzenia.OdpowiedzialnośćRządu
import Konstytucja.Twierdzenia.Referendum
import Konstytucja.Modele.Kalendarz30

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
  sejmRozpatruje := true
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
  Ustawodawstwo.zakończenie ⟨rfl, rfl, rfl, rfl⟩ (m := 1) rfl s

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

/-- Odpowiedzialność rządu w uproszczonym kalendarzu, organy działają. -/
def odpowiedzialnośćWedługTekstu : OdpowiedzialnośćRządu.Założenia where
  kalendarz := kalendarz30
  mianownik := .wszyscyGłosujący
  sejmDziała := true
  prezydentDziała := true
  limit := none
  prógPowtórnyMinistra := 115

def odpowiedzialnośćBezPrezydenta : OdpowiedzialnośćRządu.Założenia :=
  { odpowiedzialnośćWedługTekstu with prezydentDziała := false }

theorem warunki_rozstrzygnięcia_spełnialne :
    OdpowiedzialnośćRządu.WarunkiRozstrzygnięcia odpowiedzialnośćWedługTekstu := ⟨rfl, rfl⟩

theorem nowy_rząd_przez_wotum :
    ∃ u, OdpowiedzialnośćRządu.Osiągalny odpowiedzialnośćWedługTekstu u ∧
      u.etap = .nowyRząd 0 :=
  OdpowiedzialnośćRządu.wotum_daje_nowy_rząd rfl rfl

example := OdpowiedzialnośćRządu.bezczynność_blokuje_powołanie
  (Z := odpowiedzialnośćBezPrezydenta) rfl rfl

/-- Pełne złożenie z art. 154–155 przy spełnialnych warunkach. -/
theorem dymisja_w_modelu (t) :
    ∃ u, Przebieg (OdpowiedzialnośćRządu.PełnyKrok odpowiedzialnośćWedługTekstu rządWedługTekstu)
      (.inl ⟨.dymisjaPrzyjęta, t, none, none, 0⟩) (.inr u) ∧
      (u.etap = .rząd ∨ u.etap = .kadencjaSkrócona) :=
  OdpowiedzialnośćRządu.dymisja_prowadzi_do_wyniku warunki_zakończenia_spełnialne t _ _ _

/-- Referendum w sprawie o szczególnym znaczeniu, bez okresu ochronnego. -/
def referendumWedługTekstu : Referendum.Założenia where
  szczególneZnaczenie := true
  mianownik := .wszyscyGłosujący
  sejmDziała := true
  senatDziała := true
  prezydentDziała := true
  sądDziała := true
  okresOchronny := fun _ => false
  limit := none

def referendumWOkresieOchronnym : Referendum.Założenia :=
  { referendumWedługTekstu with okresOchronny := fun _ => true }

def referendumBezZnaczenia : Referendum.Założenia :=
  { referendumWedługTekstu with szczególneZnaczenie := false }

def referendumZLimitem : Referendum.Założenia :=
  { referendumWedługTekstu with limit := some 30 }

theorem warunki_referendum_spełnialne :
    Referendum.WarunkiZakończenia referendumWedługTekstu := ⟨rfl, rfl, fun _ => rfl⟩

/-- Udział 60 na 100 uprawnionych. -/
def wynikWiążący : Referendum.Wynik := ⟨100, 60, 40, 20, by decide, by decide⟩

theorem referendum_wiążące :
    Referendum.Osiągalny referendumWedługTekstu ⟨.wiążące wynikWiążący, 0⟩ :=
  Referendum.wynik_wiążący_osiągalny rfl rfl rfl rfl _ (by simp [Referendum.wiąże, wynikWiążący])

example := Referendum.okres_ochronny_blokuje
  (Z := referendumWOkresieOchronnym) rfl rfl (fun _ => rfl)

theorem bez_znaczenia_w_modelu {s} (h : Referendum.Osiągalny referendumBezZnaczenia s) :
    s.etap = .sprawa ∨ s.etap = .niezarządzone :=
  Referendum.bez_znaczenia_brak_zarządzenia rfl h

theorem limit_daje_granicę_referendum {s} (h : Referendum.Osiągalny referendumZLimitem s) :
    s.dzień ≤ 120 :=
  Referendum.granica_czasu (L := 30) rfl h

end Konstytucja.Modele
