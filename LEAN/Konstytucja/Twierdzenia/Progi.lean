import Konstytucja.Podstawy.Głosowanie

/-! # Progi głosowań -/

namespace Konstytucja

open Mianownik

/-- Art. 120. -/
def uchwalenieUstawy (g : Głosowanie .sejm) : Prop := kworum g ∧ większośćZwykła g
/-- Art. 121 ust. 3. -/
def odrzucenieStanowiskaSenatu (m : Mianownik) (g : Głosowanie .sejm) : Prop :=
  kworum g ∧ większośćBezwzględna m g
/-- Art. 122 ust. 5. -/
def odrzucenieWeta (m : Mianownik) (g : Głosowanie .sejm) : Prop := kworum g ∧ większośćUłamkowa m 3 5 g
/-- Art. 154 ust. 2 i ust. 3 mają ten sam próg. -/
def wotumZaufaniaArt154 (m : Mianownik) (g : Głosowanie .sejm) : Prop :=
  kworum g ∧ większośćBezwzględna m g
/-- Art. 155 ust. 1 (założenie G5). -/
def wotumZaufaniaArt155 (g : Głosowanie .sejm) : Prop := kworum g ∧ większośćZwykła g
/-- Art. 158 ust. 1 (założenie G6). -/
def wotumNieufności (g : Głosowanie .sejm) : Prop := większośćUstawowa g
/-- Art. 235 ust. 4, głosowanie w Sejmie. -/
def zmianaKonstytucjiSejm (m : Mianownik) (g : Głosowanie .sejm) : Prop :=
  kworum g ∧ większośćUłamkowa m 2 3 g
/-- Art. 235 ust. 4, głosowanie w Senacie. -/
def zmianaKonstytucjiSenat (m : Mianownik) (g : Głosowanie .senat) : Prop :=
  kworum g ∧ większośćBezwzględna m g
/-- Art. 156 ust. 2. -/
def odpowiedzialnośćMinistra (g : Głosowanie .sejm) : Prop := ułamekUstawowejLiczby 3 5 g
/-- Art. 98 ust. 3. -/
def skrócenieKadencjiPrzezSejm (g : Głosowanie .sejm) : Prop := ułamekUstawowejLiczby 2 3 g
/-- Art. 131 ust. 2 pkt 4 i art. 145 ust. 2. -/
def uchwałaZgromadzeniaArt145 (g : Głosowanie .zgromadzenieNarodowe) : Prop :=
  ułamekUstawowejLiczby 2 3 g

macro "głosy" : tactic => `(tactic| (
  simp only [uchwalenieUstawy, odrzucenieStanowiskaSenatu, odrzucenieWeta,
    wotumZaufaniaArt154, wotumZaufaniaArt155, wotumNieufności, zmianaKonstytucjiSejm,
    zmianaKonstytucjiSenat, odpowiedzialnośćMinistra, skrócenieKadencjiPrzezSejm,
    uchwałaZgromadzeniaArt145, kworum, większośćZwykła, większośćBezwzględna,
    większośćUłamkowa, większośćUstawowa, ułamekUstawowejLiczby, Głosowanie.mianownik,
    Głosowanie.głosujący, Izba.ustawowaLiczba] at *
  <;> try omega))

macro "minimum " z:term:max p:term:max w:term:max : tactic =>
  `(tactic| exact ⟨⟨⟨$z, $p, $w, by decide⟩, by głosy, rfl⟩, fun _ _ => by głosy⟩)

/-! ## Zależności między rodzajami większości -/

variable {i : Izba}

/-- T1, dla obu wariantów mianownika. -/
theorem bezwzględna_daje_zwykłą (m : Mianownik) (g : Głosowanie i)
    (h : większośćBezwzględna m g) : większośćZwykła g := by
  cases m <;> głosy

/-- Większość ustawowa wystarcza jako bezwzględna przy każdej frekwencji. -/
theorem ustawowa_daje_bezwzględną (m : Mianownik) (g : Głosowanie i)
    (h : większośćUstawowa g) : większośćBezwzględna m g := by
  have := g.wLimicie
  cases m <;> głosy

/-- Bez głosów wstrzymujących się w mianowniku większość bezwzględna staje się
zwykłą, choć art. 120 i art. 121 ust. 3 je rozróżniają. -/
theorem bezwzględna_bez_wstrzymanych_to_zwykła (g : Głosowanie i) :
    większośćBezwzględna zaIPrzeciw g ↔ większośćZwykła g := by
  głosy

/-- W wariancie z wszystkimi głosującymi różnica istnieje. -/
theorem bezwzględna_mocniejsza_od_zwykłej :
    ∃ g : Głosowanie .sejm, większośćZwykła g ∧ ¬ większośćBezwzględna wszyscyGłosujący g :=
  ⟨⟨2, 1, 1, by decide⟩, by głosy⟩

/-! ## Minima: wariant „wszyscy głosujący” -/

/-- Art. 120. Wynik nie zależy od mianownika. -/
theorem min_art120 : JestMinimum uchwalenieUstawy 1 := by minimum 1 0 229
theorem min_art121 : JestMinimum (odrzucenieStanowiskaSenatu wszyscyGłosujący) 116 := by
  minimum 116 114 0
/-- T4. -/
theorem min_art122 : JestMinimum (odrzucenieWeta wszyscyGłosujący) 138 := by minimum 138 92 0
theorem min_art154 : JestMinimum (wotumZaufaniaArt154 wszyscyGłosujący) 116 := by
  minimum 116 114 0
theorem min_art155 : JestMinimum wotumZaufaniaArt155 1 := by minimum 1 0 229
/-- T2. Wynik nie zależy od mianownika. -/
theorem min_art158 : JestMinimum wotumNieufności 231 := by minimum 231 0 0
/-- T3. -/
theorem min_art235_sejm : JestMinimum (zmianaKonstytucjiSejm wszyscyGłosujący) 154 := by
  minimum 154 76 0
theorem min_art235_senat : JestMinimum (zmianaKonstytucjiSenat wszyscyGłosujący) 26 := by
  minimum 26 24 0

/-! ## Minima: wariant „za i przeciw” -/

theorem min_art121_b : JestMinimum (odrzucenieStanowiskaSenatu zaIPrzeciw) 1 := by
  minimum 1 0 229
theorem min_art122_b : JestMinimum (odrzucenieWeta zaIPrzeciw) 1 := by minimum 1 0 229
theorem min_art154_b : JestMinimum (wotumZaufaniaArt154 zaIPrzeciw) 1 := by minimum 1 0 229
theorem min_art235_sejm_b : JestMinimum (zmianaKonstytucjiSejm zaIPrzeciw) 1 := by
  minimum 1 0 229
theorem min_art235_senat_b : JestMinimum (zmianaKonstytucjiSenat zaIPrzeciw) 1 := by
  minimum 1 0 49

/-! ## Progi liczone od ustawowej liczby -/

theorem min_art156 : JestMinimum odpowiedzialnośćMinistra 276 := by minimum 276 0 0
theorem min_art98 : JestMinimum skrócenieKadencjiPrzezSejm 307 := by minimum 307 0 0
theorem min_art145 : JestMinimum uchwałaZgromadzeniaArt145 374 := by minimum 374 0 0

/-- Art. 235 ust. 1: 1/5 ustawowej liczby posłów. -/
theorem wnioskodawcy_art235 (n : Nat) : 5 * n ≥ Izba.sejm.ustawowaLiczba ↔ n ≥ 92 := by
  simp only [Izba.ustawowaLiczba]; omega

/-! ## Przy pełnej obecności -/

theorem pełna_sala_art235 (g : Głosowanie .sejm) (h₁ : g.głosujący = 460)
    (h₂ : zmianaKonstytucjiSejm wszyscyGłosujący g) : g.za ≥ 307 := by
  głosy

theorem pełna_sala_art122 (g : Głosowanie .sejm) (h₁ : g.głosujący = 460)
    (h₂ : odrzucenieWeta wszyscyGłosujący g) : g.za ≥ 276 := by
  głosy

/-! ## Porównanie progów -/

/-- T5: w wariancie z wszystkimi głosującymi Sejm może przyjąć zmianę Konstytucji
mniejszą liczbą głosów, niż wymaga wotum nieufności. -/
theorem zmiana_tańsza_niż_wotum :
    ∃ g, zmianaKonstytucjiSejm wszyscyGłosujący g ∧ ¬ wotumNieufności g ∧ g.za = 154 :=
  ⟨⟨154, 76, 0, by decide⟩, by głosy, by głosy, rfl⟩

end Konstytucja
