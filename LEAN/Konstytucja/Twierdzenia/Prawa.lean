import Konstytucja.Prawa.Ograniczenia
import Konstytucja.Twierdzenia.StanyNadzwyczajne

/-! # Własności ograniczeń wolności i praw -/

namespace Konstytucja

open Cel

/-- Interpretacja, przy której ograniczenie przechodzi test: istota nienaruszona. -/
def przychylna : Interpretacja := fun c _ => c != .istota

/-- Interpretacja, przy której żadna przesłanka nie jest spełniona. -/
def surowa : Interpretacja := fun c _ => c == .istota

private def wolnośćSłowa : Ograniczenie := ⟨⟨54, 1, 0⟩, true, .porządekPubliczny, .ogólna⟩

/-! ## Warunki bezwzględne -/

private theorem klauzula_bez_ustawy (I) (o : Ograniczenie) (h : o.wUstawie = false) (k) :
    warunekKlauzuli I o k = false := by
  cases k <;> simp [warunekKlauzuli, h]

/-- Art. 31 ust. 3: bez ustawy ograniczenie jest niedopuszczalne przy każdej interpretacji. -/
theorem bez_ustawy_niedopuszczalne (t I) (o : Ograniczenie) (h : o.wUstawie = false) :
    dopuszczalne t I o = false := by
  cases k : klauzule o.prawo o.czynność with
  | nil => cases t <;> simp [dopuszczalne, spełniaKlauzule, warunekOgólny, h, k]
  | cons a r => simp [dopuszczalne, spełniaKlauzule, k, klauzula_bez_ustawy I o h]

/-- Założenie E2: czynność objęta zakazem nie podlega ograniczeniom przy żadnej interpretacji. -/
theorem zakaz_bez_ograniczeń (t I) (o : Ograniczenie)
    (h : klauzule o.prawo o.czynność = [.zakaz]) : dopuszczalne t I o = false := by
  simp [dopuszczalne, spełniaKlauzule, h, warunekKlauzuli]

/-- Art. 31 ust. 3: cel spoza katalogu nie przechodzi przepisów bez klauzuli szczególnej. -/
theorem cel_poza_katalogiem (t I) (o : Ograniczenie) (h : klauzule o.prawo o.czynność = [])
    (c : celOgólny o.cel = false) : dopuszczalne t I o = false := by
  cases t <;> simp [dopuszczalne, h, warunekOgólny, c]

/-- Art. 31 ust. 3: naruszenie istoty wyklucza ograniczenie w przepisach ogólnych. -/
theorem naruszenie_istoty (t I) (o : Ograniczenie) (h : klauzule o.prawo o.czynność = [])
    (c : I .istota o = true) : dopuszczalne t I o = false := by
  cases t <;> simp [dopuszczalne, h, warunekOgólny, c]

/-! ## Podział przepisów -/

/-- Czynności z zakazem z założenia E2. -/
theorem przepisy_z_zakazem :
    (podlegaOgraniczeniom ⟨30, 0, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨39, 0, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨40, 0, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨34, 2, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨52, 4, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨53, 6, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨53, 7, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨54, 2, 0⟩ .cenzuraPrewencyjna = false) ∧
    (podlegaOgraniczeniom ⟨54, 2, 0⟩ .koncesjonowaniePrasy = false) := by decide

/-- Art. 54 ust. 2: ten sam ustęp zawiera zakaz i dozwoloną koncesję ustawową. -/
theorem art54_ust2_dwie_normy :
    podlegaOgraniczeniom ⟨54, 2, 0⟩ .koncesjaRadiowoTelewizyjna = true ∧
      klauzule ⟨54, 2, 0⟩ .koncesjaRadiowoTelewizyjna = [.ustawowa] ∧
      dopuszczalne .łącznie przychylna
        ⟨⟨54, 2, 0⟩, true, .porządekPubliczny, .koncesjaRadiowoTelewizyjna⟩ = true ∧
      dopuszczalne .łącznie przychylna
        ⟨⟨54, 2, 0⟩, true, .porządekPubliczny, .koncesjonowaniePrasy⟩ = false := by decide

/-- Przepisy podlegające ograniczeniom, w tym z własnymi warunkami. -/
theorem przepisy_z_klauzulą :
    (klauzule ⟨49, 0, 0⟩ .ogólna = [.ustawowa]) ∧ (klauzule ⟨57, 0, 0⟩ .ogólna = [.ustawowa]) ∧
    (klauzule ⟨64, 3, 0⟩ .własność = [.istotaPrawa]) ∧
    (klauzule ⟨64, 1, 0⟩ .ogólna = []) ∧
    (klauzule ⟨22, 0, 0⟩ .ogólna = [.przesłanka .ważnyInteresPubliczny]) ∧
    (klauzule ⟨54, 1, 0⟩ .ogólna = []) ∧ (klauzule ⟨47, 0, 0⟩ .ogólna = []) := by decide

/-- Art. 81 wymienia dokładnie art. 65 ust. 4–5, art. 66, 69, 71 i 74–76. -/
theorem art81_wykaz :
    (wGranicachUstawy ⟨65, 4, 0⟩ = true) ∧ (wGranicachUstawy ⟨65, 5, 0⟩ = true) ∧
    (wGranicachUstawy ⟨65, 1, 0⟩ = false) ∧ (wGranicachUstawy ⟨66, 1, 0⟩ = true) ∧
    (wGranicachUstawy ⟨69, 0, 0⟩ = true) ∧ (wGranicachUstawy ⟨71, 1, 0⟩ = true) ∧
    (wGranicachUstawy ⟨74, 3, 0⟩ = true) ∧ (wGranicachUstawy ⟨76, 0, 0⟩ = true) ∧
    (wGranicachUstawy ⟨77, 1, 0⟩ = false) ∧ (wGranicachUstawy ⟨68, 1, 0⟩ = false) := by decide

/-- Art. 81: pełna charakterystyka katalogu, dla każdego przepisu. -/
theorem art81_pełny (p : Przepis) :
    wGranicachUstawy p = true ↔
      (p.art = 65 ∧ (p.ust = 4 ∨ p.ust = 5)) ∨
        p.art = 66 ∨ p.art = 69 ∨ p.art = 71 ∨ p.art = 74 ∨ p.art = 75 ∨ p.art = 76 := by
  simp [wGranicachUstawy]

/-- Art. 31 ust. 3: dokładnie sześć celów ogólnych. -/
theorem cele_ogólne_pełne (c : Cel) :
    celOgólny c = true ↔ c ∈ [Cel.bezpieczeństwoPaństwa, .porządekPubliczny, .ochronaŚrodowiska,
      .zdrowie, .moralność, .wolnościInnych] := by
  cases c <;> simp [celOgólny]

/-! ## Art. 59 -/

private def strajk : Ograniczenie := ⟨⟨59, 3, 0⟩, true, .porządekPubliczny, .ogólna⟩
private def rokowania : Ograniczenie := ⟨⟨59, 2, 0⟩, true, .porządekPubliczny, .ogólna⟩

/-- Art. 59 ust. 3–4: ograniczenie strajku musi spełnić oba warunki, także w trybie zamiennym. -/
theorem strajk_wymaga_obu_warunków (t I) (u : I .dopuszczalnePrzezUmowy strajk = false) :
    dopuszczalne t I strajk = false := by
  simp [dopuszczalne, spełniaKlauzule, strajk, klauzule, warunekKlauzuli] at *
  simp [u]

/-- Art. 59 ust. 4: prawo do rokowań też ma warunek umów, a nie tylko art. 31 ust. 3. -/
theorem rokowania_wymagają_umów (t I) (u : I .dopuszczalnePrzezUmowy rokowania = false) :
    dopuszczalne t I rokowania = false := by
  simp [dopuszczalne, spełniaKlauzule, rokowania, klauzule, warunekKlauzuli] at *
  simp [u]

/-- Wynik dla strajku zależy od obu pojęć. -/
theorem strajk_zależy_od_obu :
    ZależyOd (fun I => dopuszczalne .klauzulaZamiast I strajk) .dobroPubliczne ∧
      ZależyOd (fun I => dopuszczalne .klauzulaZamiast I strajk) .dopuszczalnePrzezUmowy := by
  constructor
  · refine ⟨przychylna, zeZmianą przychylna .dobroPubliczne false, ?_, by decide, by decide⟩
    intro d h
    funext o
    simp [zeZmianą, h]
  · refine ⟨przychylna, zeZmianą przychylna .dopuszczalnePrzezUmowy false, ?_, by decide, by decide⟩
    intro d h
    funext o
    simp [zeZmianą, h]

/-! ## Od których pojęć zależy wynik -/

/-- Wynik przepisu ogólnego zależy od „konieczności”. -/
theorem ogólny_zależy_od_konieczności :
    ZależyOd (fun I => dopuszczalne .łącznie I wolnośćSłowa) .konieczne := by
  refine ⟨przychylna, zeZmianą przychylna .konieczne false, ?_, by decide, by decide⟩
  intro d h
  funext o
  simp [zeZmianą, h]

/-- Wynik przepisu ogólnego zależy od „istoty”. -/
theorem ogólny_zależy_od_istoty :
    ZależyOd (fun I => dopuszczalne .łącznie I wolnośćSłowa) .istota := by
  refine ⟨przychylna, zeZmianą przychylna .istota true, ?_, by decide, by decide⟩
  intro d h
  funext o
  simp [zeZmianą, h]

/-- Dla przepisu ogólnego ważne są tylko dwa pojęcia, a nie np. godność. -/
theorem ogólny_tylko_dwa_pojęcia (c : Pojęcie) (a : c ≠ .konieczne) (b : c ≠ .istota) :
    NieZależyOd (fun I => dopuszczalne .łącznie I wolnośćSłowa) c := by
  intro I J h
  have p := congrFun (h .konieczne (Ne.symm a)) wolnośćSłowa
  have q := congrFun (h .istota (Ne.symm b)) wolnośćSłowa
  simp [dopuszczalne, spełniaKlauzule, wolnośćSłowa, klauzule, warunekOgólny, celOgólny] at *
  rw [p, q]

private def wolnośćGospodarcza : Ograniczenie := ⟨⟨22, 0, 0⟩, true, .inny, .ogólna⟩
private def własność : Ograniczenie := ⟨⟨64, 3, 0⟩, true, .ochronaŚrodowiska, .własność⟩

/-- Założenie E1: art. 22 daje szerszą podstawę niż art. 31 ust. 3, jeśli go zastępuje. -/
theorem tryb_zmienia_wynik_art22 :
    dopuszczalne .klauzulaZamiast przychylna wolnośćGospodarcza = true ∧
      dopuszczalne .łącznie przychylna wolnośćGospodarcza = false := by decide

/-- Art. 22 zależy od „ważnego interesu publicznego”. -/
theorem art22_zależy_od_interesu :
    ZależyOd (fun I => dopuszczalne .klauzulaZamiast I wolnośćGospodarcza)
      .ważnyInteresPubliczny := by
  refine ⟨przychylna, zeZmianą przychylna .ważnyInteresPubliczny false, ?_, by decide, by decide⟩
  intro d h
  funext o
  simp [zeZmianą, h]

/-- Art. 64 ust. 3 w trybie zamiennym nie zależy od „konieczności”. -/
theorem art64_zamiast_bez_konieczności :
    NieZależyOd (fun I => dopuszczalne .klauzulaZamiast I własność) .konieczne := by
  intro I J h
  have q := congrFun (h .istota (by decide)) własność
  simp [dopuszczalne, spełniaKlauzule, własność, klauzule, warunekKlauzuli, zastępujeOgólny] at *
  rw [q]

/-- W trybie łącznym ta sama sprawa od niej zależy. -/
theorem art64_łącznie_z_koniecznością :
    ZależyOd (fun I => dopuszczalne .łącznie I własność) .konieczne := by
  refine ⟨przychylna, zeZmianą przychylna .konieczne false, ?_, by decide, by decide⟩
  intro d h
  funext o
  simp [zeZmianą, h]

/-- T8: to samo ograniczenie jest dopuszczalne albo nie, zależnie od interpretacji. -/
theorem dwie_interpretacje :
    ∃ I J : Interpretacja, dopuszczalne .łącznie I wolnośćSłowa = true ∧
      dopuszczalne .łącznie J wolnośćSłowa = false :=
  ⟨przychylna, surowa, by decide, by decide⟩

/-! ## Klauzule szczególne -/

/-- Art. 53 ust. 5 nie zna ochrony środowiska, a art. 31 ust. 3 tak. -/
theorem art53_węższy_od_art31 (t : Tryb) :
    dopuszczalne t przychylna
        ⟨⟨53, 2, 0⟩, true, .ochronaŚrodowiska, .uzewnętrznianieReligii⟩ = false ∧
      dopuszczalne t przychylna ⟨⟨54, 1, 0⟩, true, .ochronaŚrodowiska, .ogólna⟩ = true := by
  cases t <;> decide

/-- Art. 61 ust. 3 dopuszcza ważny interes gospodarczy państwa, którego nie ma w art. 31. -/
theorem art61_interes_gospodarczy :
    dopuszczalne .klauzulaZamiast przychylna
        ⟨⟨61, 1, 0⟩, true, .interesGospodarczyPaństwa, .ogólna⟩ = true ∧
      dopuszczalne .łącznie przychylna
        ⟨⟨61, 1, 0⟩, true, .interesGospodarczyPaństwa, .ogólna⟩ = false := by decide

/-- Art. 45 ust. 2 dotyczy tylko jawności, a nie całego prawa do sądu. -/
theorem art45_katalog :
    dopuszczalne .klauzulaZamiast przychylna
        ⟨⟨45, 1, 0⟩, true, .interesPrywatny, .jawnośćRozprawy⟩ = true ∧
      dopuszczalne .klauzulaZamiast przychylna
        ⟨⟨45, 1, 0⟩, true, .zdrowie, .jawnośćRozprawy⟩ = false ∧
      klauzule ⟨45, 1, 0⟩ .ogólna = [] := by decide

/-! ## Art. 233 i warianty E3, E7 -/

open StanyNadzwyczajne

/-- Przepisy z zakazem z art. 30, 39 i 40 są też chronione przez art. 233 ust. 1. -/
theorem zakazy_w_art233 :
    (nienaruszalne ⟨30, 0, 0⟩ = true) ∧ (nienaruszalne ⟨39, 0, 0⟩ = true) ∧
    (nienaruszalne ⟨40, 0, 0⟩ = true) := by decide

/-- Art. 52 ust. 4 i art. 54 ust. 2 nie są wymienione w art. 233 ust. 1. -/
theorem zakazy_poza_art233 :
    (nienaruszalne ⟨52, 4, 0⟩ = false) ∧ (nienaruszalne ⟨54, 2, 0⟩ = false) ∧
    (podlegaOgraniczeniom ⟨52, 4, 0⟩ .ogólna = false) ∧
    (podlegaOgraniczeniom ⟨54, 2, 0⟩ .cenzuraPrewencyjna = false) := by decide

private def cenzura : Ograniczenie :=
  ⟨⟨54, 2, 0⟩, true, .bezpieczeństwoPaństwa, .cenzuraPrewencyjna⟩

/-- Wariant E7: o cenzurze w stanie wojennym decyduje dalsze obowiązywanie zakazu, a nie
art. 31 ust. 3, bo jego warunek jest tu spełniony. -/
theorem wariant_E7_izoluje_zakaz (a : Bool) :
    warunekOgólny przychylna cenzura = true ∧
      dopuszczalneWStanie ⟨a, false⟩ .wojenny .inny przychylna cenzura = true ∧
      dopuszczalneWStanie ⟨a, true⟩ .wojenny .inny przychylna cenzura = false := by
  cases a <;> decide

private def celSpozaKatalogu : Ograniczenie := ⟨⟨54, 1, 0⟩, true, .inny, .ogólna⟩

/-- Wariant E3: przy celu spoza art. 31 ust. 3 wynik zmienia tylko ten wariant. -/
theorem wariant_E3_izoluje_art31 (b : Bool) :
    dopuszczalneWStanie ⟨false, b⟩ .wyjątkowy .inny przychylna celSpozaKatalogu = true ∧
      dopuszczalneWStanie ⟨true, b⟩ .wyjątkowy .inny przychylna celSpozaKatalogu = false := by
  cases b <;> decide

/-- Art. 233 ust. 1: godność chroniona w każdym stanie, niezależnie od wariantów. -/
theorem godność_w_każdym_stanie (R r m I) (o : Ograniczenie)
    (h : o.prawo = ⟨30, 0, 0⟩) : dopuszczalneWStanie R r m I o = false := by
  have a : nienaruszalne ⟨30, 0, 0⟩ = true := by decide
  have b : dozwoloneWKlęsce ⟨30, 0, 0⟩ = false := by decide
  cases r <;> simp [dopuszczalneWStanie, ograniczenieDopuszczalne, możnaOgraniczyć, h, a, b]

/-- Art. 228 ust. 5: wynik w stanie nadzwyczajnym zależy od odpowiedniości. -/
theorem stan_zależy_od_odpowiedniości :
    ZależyOd (fun I => dopuszczalneWStanie ⟨false, false⟩ .wyjątkowy .inny I wolnośćSłowa)
      .odpowiedniośćDoZagrożenia := by
  refine ⟨przychylna, zeZmianą przychylna .odpowiedniośćDoZagrożenia false, ?_,
    by decide, by decide⟩
  intro d h
  funext o
  simp [zeZmianą, h]

end Konstytucja
