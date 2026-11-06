import Konstytucja.Twierdzenia.TworzenieRządu
import Konstytucja.Twierdzenia.Ustawodawstwo

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

end Konstytucja.Modele
