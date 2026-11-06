import Konstytucja.Modele.Wybory
import Konstytucja.Modele.Procedury
import Konstytucja.Modele.StanyNadzwyczajne
import Konstytucja.Twierdzenia.Prawa
import Konstytucja.Twierdzenia.OgłoszenieOrzeczenia

/-! # Własności a i d z etapu 6

Własność a oznacza tylko spełnialność warunków zapisanych w typach. Nie dowodzi spójności
wszystkich norm ani trafności wariantów. Własności b i c są w `Twierdzenia/SystemNorm.lean`.
-/

namespace Konstytucja.Analiza

open Modele

/-! ## Własność a: spełnialność założeń -/

theorem a_warunki_procedur_spełnialne :
    (∃ Z, TworzenieRządu.WarunkiZakończenia Z) ∧
    (∃ Z, Ustawodawstwo.WarunkiZakończenia Z) ∧
    (∃ Z, ZmianaKonstytucji.WarunkiZakończenia Z) ∧
    (∃ Z, OdpowiedzialnośćRządu.WarunkiRozstrzygnięcia Z) ∧
    (∃ Z, Referendum.WarunkiZakończenia Z) ∧
    (∃ Z, WybórPrezydenta.WarunkiZakończenia Z) ∧
    (∃ Z, StanyNadzwyczajne.WarunkiZakończenia Z) :=
  ⟨⟨_, warunki_zakończenia_spełnialne⟩, ⟨ustawaWedługTekstu, ⟨rfl, rfl, rfl, rfl⟩⟩,
   ⟨_, warunki_zmiany_spełnialne⟩, ⟨_, warunki_rozstrzygnięcia_spełnialne⟩,
   ⟨_, warunki_referendum_spełnialne⟩, ⟨_, warunki_wyborów_spełnialne⟩,
   ⟨_, warunki_stanów_spełnialne⟩⟩

/-- Art. 31 ust. 3 jest spełnialny, a także możliwy do niespełnienia. -/
theorem a_ograniczenia_spełnialne :
    ∃ (I J : Interpretacja) (o : Ograniczenie),
      dopuszczalne .łącznie I o = true ∧ dopuszczalne .łącznie J o = false :=
  ⟨przychylna, surowa, ⟨⟨54, 1, 0⟩, true, .porządekPubliczny, .ogólna⟩, by decide, by decide⟩

/-! ## Własność d: brak blokad przy spełnionych warunkach -/

theorem d_bez_blokad_tworzenie (s : TworzenieRządu.Stan) (n : s.etap.końcowy = false) :
    ∃ u, TworzenieRządu.Krok rządWedługTekstu s u :=
  TworzenieRządu.postęp warunki_zakończenia_spełnialne s n

theorem d_bez_blokad_ustawodawstwo (s : Ustawodawstwo.Stan) (n : s.etap.końcowy = false) :
    ∃ u, Ustawodawstwo.Krok ustawaWedługTekstu s u :=
  Ustawodawstwo.postęp ⟨rfl, rfl, rfl, rfl⟩ s n

theorem d_bez_blokad_zmiana (s : ZmianaKonstytucji.Stan) (n : s.etap.końcowy = false) :
    ∃ u, ZmianaKonstytucji.Krok zmianaChroniona s u :=
  ZmianaKonstytucji.postęp warunki_zmiany_spełnialne s n

theorem d_bez_blokad_referendum (s : Referendum.Stan) (n : s.etap.ustalony = false) :
    ∃ u, Referendum.Krok referendumWedługTekstu s u :=
  Referendum.postęp warunki_referendum_spełnialne s n

theorem d_bez_blokad_odpowiedzialność (s : OdpowiedzialnośćRządu.Stan)
    (n : s.etap.ustalony = false) :
    ∃ u, OdpowiedzialnośćRządu.Rozstrzygnięcie odpowiedzialnośćWedługTekstu s u :=
  OdpowiedzialnośćRządu.postęp_rozstrzygania warunki_rozstrzygnięcia_spełnialne s n

/-! ## Własność d: osiągalne blokady przy bezczynności -/

/-- Bezczynność Prezydenta w art. 155 ust. 1. -/
def rządBezPrezydenta : TworzenieRządu.Założenia :=
  { rządWedługTekstu with prezydentDziała := false }

theorem d_blokada_tworzenia :
    ∃ s, TworzenieRządu.Osiągalny rządBezPrezydenta s ∧ s.etap.końcowy = false ∧
      ∀ u, ¬ TworzenieRządu.Krok rządBezPrezydenta s u :=
  have h := TworzenieRządu.bezczynność_blokuje_art155 (Z := rządBezPrezydenta) rfl
  ⟨_, h.1, rfl, h.2⟩

/-- Bierność Sejmu wobec stanowiska Senatu. -/
def ustawaBezRozpatrzenia : Ustawodawstwo.Założenia :=
  { ustawaWedługTekstu with sejmRozpatruje := false }

theorem d_blokada_stanowiska_senatu :
    ∃ s, Ustawodawstwo.Osiągalny ustawaBezRozpatrzenia s ∧ s.etap.końcowy = false ∧
      ∀ u, ¬ Ustawodawstwo.Krok ustawaBezRozpatrzenia s u :=
  have h := Ustawodawstwo.bierność_sejmu_blokuje (Z := ustawaBezRozpatrzenia) rfl rfl
  ⟨_, h.1, rfl, h.2⟩

theorem d_blokada_trybunału :
    ∃ s, Ustawodawstwo.Osiągalny ustawaBezOrzeczenia s ∧ s.etap.końcowy = false ∧
      ∀ u, ¬ Ustawodawstwo.Krok ustawaBezOrzeczenia s u :=
  have h := Ustawodawstwo.brak_orzeczenia_blokuje (Z := ustawaBezOrzeczenia) rfl rfl rfl
  ⟨_, h.1, rfl, h.2⟩

/-- Art. 122 ust. 2: brak podpisu ustawy, jak w planie etapu 6. -/
theorem d_blokada_podpisu :
    ∃ s, Ustawodawstwo.Osiągalny ustawaBezPrezydenta s ∧ s.etap.końcowy = false ∧
      ∀ u, ¬ Ustawodawstwo.Krok ustawaBezPrezydenta s u :=
  have h := Ustawodawstwo.bezczynność_prezydenta_blokuje (Z := ustawaBezPrezydenta) rfl rfl
  ⟨_, h.1, rfl, h.2⟩

theorem d_blokada_referendum_zatwierdzającego :
    ∃ s, ZmianaKonstytucji.Osiągalny zmianaWOkresieOchronnym s ∧ s.etap.końcowy = false ∧
      ∀ u, ¬ ZmianaKonstytucji.Krok zmianaWOkresieOchronnym s u :=
  have h := ZmianaKonstytucji.okres_ochronny_blokuje_referendum
    (Z := zmianaWOkresieOchronnym) rfl rfl rfl (fun _ => rfl)
  ⟨_, h.1, rfl, h.2⟩

theorem d_blokada_referendum :
    ∃ s, Referendum.Osiągalny referendumWOkresieOchronnym s ∧ s.etap.ustalony = false ∧
      ∀ u, ¬ Referendum.Krok referendumWOkresieOchronnym s u :=
  have h := Referendum.okres_ochronny_blokuje (Z := referendumWOkresieOchronnym)
    rfl rfl (fun _ => rfl)
  ⟨_, h.1, rfl, h.2⟩

theorem d_blokada_wyborów :
    ∃ s, WybórPrezydenta.Osiągalny wyboryZRemisem s ∧ s.etap.końcowy = false ∧
      ∀ u, ¬ WybórPrezydenta.Krok wyboryZRemisem s u :=
  ⟨_, remis_w_scenariuszu.1, rfl, remis_w_scenariuszu.2⟩

/-- Bezczynność Prezydenta po wotum nieufności. -/
def odpowiedzialnośćPoWotum := odpowiedzialnośćBezPrezydenta

theorem d_blokada_wotum :
    ∃ s, OdpowiedzialnośćRządu.Osiągalny odpowiedzialnośćPoWotum s ∧
      s.etap.ustalony = false ∧ ∀ u, ¬ OdpowiedzialnośćRządu.Krok odpowiedzialnośćPoWotum s u := by
  obtain ⟨v, o, e, k⟩ := OdpowiedzialnośćRządu.bezczynność_blokuje_powołanie
    (Z := odpowiedzialnośćPoWotum) rfl rfl
  refine ⟨v, o, ?_, k⟩
  rw [e]
  rfl

/-- Art. 145: brak orzeczenia Trybunału Stanu. -/
def urządBezTrybunałuStanu : UrządPrezydenta.Założenia :=
  { urządWedługTekstu with trybunałStanuOrzeka := false }

theorem d_blokada_zawieszenia :
    ∃ s, UrządPrezydenta.Osiągalny urządBezTrybunałuStanu s ∧ s.etap = .zawieszony ∧
      ∀ u, ¬ UrządPrezydenta.Krok urządBezTrybunałuStanu s u :=
  have h := UrządPrezydenta.brak_orzeczenia_stanu_blokuje (Z := urządBezTrybunałuStanu) rfl
  ⟨_, h.1, rfl, h.2⟩

/-- Art. 190 ust. 2–3: brak ogłoszenia orzeczenia, jak w planie etapu 6. -/
def ogłoszenieBezOrganu : OgłoszenieOrzeczenia.Założenia :=
  ⟨false, 1, kalendarz30⟩

theorem d_blokada_ogłoszenia (a : OgłoszenieOrzeczenia.RodzajAktu)
    (w : OgłoszenieOrzeczenia.Wynik) :
    OgłoszenieOrzeczenia.Osiągalny ogłoszenieBezOrganu a w ⟨.wydane, 0, a, w⟩ ∧
      ∀ u, ¬ OgłoszenieOrzeczenia.Krok ogłoszenieBezOrganu ⟨.wydane, 0, a, w⟩ u :=
  OgłoszenieOrzeczenia.nieogłoszenie_blokuje rfl a w

/-! ## Spór art. 122 i art. 235 ust. 7 -/

/-- Wariant V8 z dopuszczonym wnioskiem do Trybunału. -/
def zmianaZTrybunałem : ZmianaKonstytucji.Założenia :=
  { zmianaZwykła with trybunałPrzedPodpisem := true }

/-- Przy V8 wniosek do Trybunału jest osiągalny, a bez V8 Prezydent może tylko podpisać. -/
theorem wariant_V8 :
    (∃ s, ZmianaKonstytucji.Osiągalny zmianaZTrybunałem s ∧ s.etap = .trybunał) ∧
      (∀ t r x s, ZmianaKonstytucji.Krok zmianaZwykła ⟨.prezydent, t, r, x⟩ s →
        s.etap = .podpisana) := by
  constructor
  · obtain ⟨⟨e, t, r, x⟩, o, q⟩ := ZmianaKonstytucji.do_prezydenta (Z := zmianaZTrybunałem) rfl rfl
    simp only at q
    subst q
    exact ⟨_, .krok o (.wniosekDoTrybunału (d := 0) rfl (Nat.zero_le _) rfl), rfl⟩
  · intro t r x s k
    exact ZmianaKonstytucji.tylko_podpis rfl k

end Konstytucja.Analiza
