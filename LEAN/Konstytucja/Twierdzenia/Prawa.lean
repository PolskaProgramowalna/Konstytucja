import Konstytucja.Prawa.Ograniczenia
import Konstytucja.Twierdzenia.StanyNadzwyczajne

/-! # Własności ograniczeń wolności i praw -/

namespace Konstytucja

open Cel

/-- Interpretacja, przy której ograniczenie przechodzi test: istota nienaruszona. -/
def przychylna : Interpretacja := fun c _ => c != .istota

/-- Interpretacja, przy której żadna przesłanka nie jest spełniona. -/
def surowa : Interpretacja := fun c _ => c == .istota

private def wolnośćSłowa : Ograniczenie := ⟨⟨54, 1, 0⟩, true, .porządekPubliczny⟩

/-! ## Warunki bezwzględne -/

/-- Art. 31 ust. 3: bez ustawy ograniczenie jest niedopuszczalne przy każdej interpretacji. -/
theorem bez_ustawy_niedopuszczalne (t I) (o : Ograniczenie) (h : o.wUstawie = false) :
    dopuszczalne t I o = false := by
  cases k : klauzula o.prawo <;> cases t <;>
    simp [dopuszczalne, k, warunekOgólny, warunekKlauzuli, h]

/-- Założenie E2: przepis z zakazem nie podlega ograniczeniom przy żadnej interpretacji. -/
theorem zakaz_bez_ograniczeń (t I) (o : Ograniczenie) (h : klauzula o.prawo = .zakaz) :
    dopuszczalne t I o = false := by
  simp [dopuszczalne, h]

/-- Art. 31 ust. 3: cel spoza katalogu nie przechodzi przepisów bez klauzuli szczególnej. -/
theorem cel_poza_katalogiem (t I) (o : Ograniczenie) (h : klauzula o.prawo = .ogólna)
    (c : celOgólny o.cel = false) : dopuszczalne t I o = false := by
  simp [dopuszczalne, h, warunekOgólny, c]

/-- Art. 31 ust. 3: naruszenie istoty wyklucza ograniczenie w przepisach ogólnych. -/
theorem naruszenie_istoty (t I) (o : Ograniczenie) (h : klauzula o.prawo = .ogólna)
    (c : I .istota o = true) : dopuszczalne t I o = false := by
  simp [dopuszczalne, h, warunekOgólny, c]

/-! ## Podział przepisów -/

/-- Przepisy z zakazem z założenia E2. -/
theorem przepisy_z_zakazem :
    (podlegaOgraniczeniom ⟨30, 0, 0⟩ = false) ∧ (podlegaOgraniczeniom ⟨39, 0, 0⟩ = false) ∧
    (podlegaOgraniczeniom ⟨40, 0, 0⟩ = false) ∧ (podlegaOgraniczeniom ⟨34, 2, 0⟩ = false) ∧
    (podlegaOgraniczeniom ⟨52, 4, 0⟩ = false) ∧ (podlegaOgraniczeniom ⟨53, 6, 0⟩ = false) ∧
    (podlegaOgraniczeniom ⟨53, 7, 0⟩ = false) ∧ (podlegaOgraniczeniom ⟨54, 2, 0⟩ = false) := by
  decide

/-- Przepisy podlegające ograniczeniom, w tym z własną klauzulą. -/
theorem przepisy_z_klauzulą :
    (klauzula ⟨49, 0, 0⟩ = .ustawowa) ∧ (klauzula ⟨57, 0, 0⟩ = .ustawowa) ∧
    (klauzula ⟨64, 1, 0⟩ = .istotaPrawa) ∧
    (klauzula ⟨22, 0, 0⟩ = .przesłanka .ważnyInteresPubliczny) ∧
    (klauzula ⟨59, 3, 0⟩ = .przesłanka .dobroPubliczne) ∧
    (klauzula ⟨54, 1, 0⟩ = .ogólna) ∧ (klauzula ⟨47, 0, 0⟩ = .ogólna) := by decide

/-- Art. 81 wymienia dokładnie art. 65 ust. 4–5, art. 66, 69, 71 i 74–76. -/
theorem art81_wykaz :
    (wGranicachUstawy ⟨65, 4, 0⟩ = true) ∧ (wGranicachUstawy ⟨65, 5, 0⟩ = true) ∧
    (wGranicachUstawy ⟨65, 1, 0⟩ = false) ∧ (wGranicachUstawy ⟨66, 1, 0⟩ = true) ∧
    (wGranicachUstawy ⟨69, 0, 0⟩ = true) ∧ (wGranicachUstawy ⟨71, 1, 0⟩ = true) ∧
    (wGranicachUstawy ⟨74, 3, 0⟩ = true) ∧ (wGranicachUstawy ⟨76, 0, 0⟩ = true) ∧
    (wGranicachUstawy ⟨77, 1, 0⟩ = false) ∧ (wGranicachUstawy ⟨68, 1, 0⟩ = false) := by decide

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
  simp [dopuszczalne, wolnośćSłowa, klauzula, warunekOgólny, celOgólny] at *
  rw [p, q]

private def wolnośćGospodarcza : Ograniczenie := ⟨⟨22, 0, 0⟩, true, .inny⟩
private def własność : Ograniczenie := ⟨⟨64, 3, 0⟩, true, .ochronaŚrodowiska⟩

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
  simp [dopuszczalne, własność, klauzula, warunekKlauzuli] at *
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
    dopuszczalne t przychylna ⟨⟨53, 2, 0⟩, true, .ochronaŚrodowiska⟩ = false ∧
      dopuszczalne t przychylna ⟨⟨54, 1, 0⟩, true, .ochronaŚrodowiska⟩ = true := by
  cases t <;> decide

/-- Art. 61 ust. 3 dopuszcza ważny interes gospodarczy państwa, którego nie ma w art. 31. -/
theorem art61_interes_gospodarczy :
    dopuszczalne .klauzulaZamiast przychylna
        ⟨⟨61, 1, 0⟩, true, .interesGospodarczyPaństwa⟩ = true ∧
      dopuszczalne .łącznie przychylna
        ⟨⟨61, 1, 0⟩, true, .interesGospodarczyPaństwa⟩ = false := by decide

/-- Art. 45 ust. 2 ma własny zamknięty katalog. -/
theorem art45_katalog :
    dopuszczalne .klauzulaZamiast przychylna ⟨⟨45, 1, 0⟩, true, .interesPrywatny⟩ = true ∧
      dopuszczalne .klauzulaZamiast przychylna ⟨⟨45, 1, 0⟩, true, .zdrowie⟩ = false := by decide

/-! ## Art. 233 -/

open StanyNadzwyczajne

/-- Przepisy z zakazem z art. 30, 39 i 40 są też chronione przez art. 233 ust. 1. -/
theorem zakazy_w_art233 :
    (nienaruszalne ⟨30, 0, 0⟩ = true) ∧ (nienaruszalne ⟨39, 0, 0⟩ = true) ∧
    (nienaruszalne ⟨40, 0, 0⟩ = true) := by decide

/-- Art. 52 ust. 4 i art. 54 ust. 2 nie są wymienione w art. 233 ust. 1, choć w trybie
zwykłym przyjmujemy dla nich zakaz (L62). -/
theorem zakazy_poza_art233 :
    (nienaruszalne ⟨52, 4, 0⟩ = false) ∧ (nienaruszalne ⟨54, 2, 0⟩ = false) ∧
    (podlegaOgraniczeniom ⟨52, 4, 0⟩ = false) ∧ (podlegaOgraniczeniom ⟨54, 2, 0⟩ = false) := by
  decide

private def cenzura : Ograniczenie := ⟨⟨54, 2, 0⟩, true, .bezpieczeństwoPaństwa⟩

/-- Wariant E3 rozstrzyga o wyniku: bez art. 31 ust. 3 stan wojenny mógłby objąć art. 54
ust. 2, a z art. 31 ust. 3 nie. -/
theorem wariant_E3_zmienia_wynik :
    dopuszczalneWStanie false .wojenny .inny .łącznie przychylna cenzura = true ∧
      dopuszczalneWStanie true .wojenny .inny .łącznie przychylna cenzura = false := by decide

/-- Art. 233 ust. 1: godność chroniona w każdym stanie, niezależnie od interpretacji. -/
theorem godność_w_każdym_stanie (w : Bool) (r m t I) (o : Ograniczenie)
    (h : o.prawo = ⟨30, 0, 0⟩) : dopuszczalneWStanie w r m t I o = false := by
  have a : nienaruszalne ⟨30, 0, 0⟩ = true := by decide
  have b : dozwoloneWKlęsce ⟨30, 0, 0⟩ = false := by decide
  cases r <;> simp [dopuszczalneWStanie, ograniczenieDopuszczalne, możnaOgraniczyć, h, a, b]

/-- Art. 228 ust. 5: wynik w stanie nadzwyczajnym zależy od odpowiedniości. -/
theorem stan_zależy_od_odpowiedniości :
    ZależyOd (fun I => dopuszczalneWStanie false .wyjątkowy .inny .łącznie I wolnośćSłowa)
      .odpowiedniośćDoZagrożenia := by
  refine ⟨przychylna, zeZmianą przychylna .odpowiedniośćDoZagrożenia false, ?_,
    by decide, by decide⟩
  intro d h
  funext o
  simp [zeZmianą, h]

end Konstytucja
