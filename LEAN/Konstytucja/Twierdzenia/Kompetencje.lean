import Konstytucja.Kompetencje.Kontrasygnata
import Konstytucja.Kompetencje.Trybunał
import Konstytucja.Twierdzenia.Hierarchia

/-! # Własności kompetencji

Odpowiedzi na pytania „czy ten akt wymaga kontrasygnaty” i „czy ten podmiot może złożyć
wniosek” są funkcjami rozstrzygalnymi, więc poniższe przykłady liczy sam Lean.
-/

namespace Konstytucja

namespace Kontrasygnata

open Prerogatywa

/-! ## Art. 144 ust. 3 -/

theorem jest_30_punktów : wszystkie.length = 30 := rfl

/-- Lista obejmuje każdą prerogatywę. -/
theorem lista_kompletna (p : Prerogatywa) : p ∈ wszystkie := by
  cases p <;> simp [wszystkie]

/-- Punkty idą kolejno od 1 do 30, więc nic nie jest pominięte ani powtórzone. -/
theorem punkty_kolejne : wszystkie.map Prerogatywa.punkt = List.range' 1 30 := by decide

theorem bez_powtórzeń : wszystkie.Nodup := by decide

/-- Art. 144 ust. 3: żadna prerogatywa nie wymaga kontrasygnaty. -/
theorem prerogatywa_bez_kontrasygnaty (w) (p : Prerogatywa) :
    wymagaKontrasygnaty w (.prerogatywa p) = false := rfl

/-- Art. 144 ust. 2: bez podpisu akt spoza katalogu nie spełnia warunku kontrasygnaty (K2). -/
theorem bez_podpisu_warunek_niespełniony (w) (a : Akt) (h : wymagaKontrasygnaty w a = true) :
    spełniaWarunekKontrasygnaty w a false = false := by
  simp [spełniaWarunekKontrasygnaty, h]

/-- Art. 144 ust. 2: podpis Prezesa spełnia ten warunek, ale nie inne warunki ważności. -/
theorem podpis_spełnia_warunek (w) (a : Akt) : spełniaWarunekKontrasygnaty w a true = true := by
  simp [spełniaWarunekKontrasygnaty]

/-- Prerogatywa spełnia warunek bez podpisu. Teza nie mówi o pozostałych warunkach ważności. -/
theorem prerogatywa_spełnia_warunek (w) (p : Prerogatywa) :
    spełniaWarunekKontrasygnaty w (.prerogatywa p) false = true := rfl

/-- Art. 229 i art. 230 wymagają kontrasygnaty, niezależnie od wariantu K1. -/
theorem stany_wymagają_kontrasygnaty (w) :
    wymagaKontrasygnaty w .wprowadzenieStanuWojennego = true ∧
      wymagaKontrasygnaty w .wprowadzenieStanuWyjątkowego = true := ⟨rfl, rfl⟩

/-- Art. 133 ust. 1, art. 134, art. 142. -/
theorem inne_akty_wymagają (w) :
    wymagaKontrasygnaty w .ratyfikacjaUmowy = true ∧
      wymagaKontrasygnaty w .mianowaniePrzedstawiciela = true ∧
      wymagaKontrasygnaty w .mianowanieDowódców = true ∧
      wymagaKontrasygnaty w .rozporządzenie = true := ⟨rfl, rfl, rfl, rfl⟩

/-- Wariant K1 rozstrzyga tylko o wecie. -/
theorem weto_zależy_od_wariantu :
    wymagaKontrasygnaty true .wniosekOPonowneRozpatrzenie = false ∧
      wymagaKontrasygnaty false .wniosekOPonowneRozpatrzenie = true := ⟨rfl, rfl⟩

/-- Czynności Prezydenta z automatów objęte katalogiem. -/
theorem czynności_z_automatów (w) :
    wymagaKontrasygnaty w (.prerogatywa podpisywanieAlboOdmowaPodpisania) = false ∧
      wymagaKontrasygnaty w (.prerogatywa wniosekDoTrybunałuKonstytucyjnego) = false ∧
      wymagaKontrasygnaty w (.prerogatywa desygnowanieIPowoływaniePrezesaRM) = false ∧
      wymagaKontrasygnaty w (.prerogatywa przyjmowanieDymisjiRady) = false ∧
      wymagaKontrasygnaty w (.prerogatywa skracanieKadencjiSejmu) = false ∧
      wymagaKontrasygnaty w (.prerogatywa zarządzanieReferendum) = false ∧
      wymagaKontrasygnaty w (.prerogatywa odwoływanieMinistraPoWotum) = false :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end Kontrasygnata

namespace Trybunał

/-- Okoliczności bez szczególnych warunków. -/
def bezWarunków : Okoliczności := ⟨false, false, false, false, false, false⟩

/-- Akt w zakresie działania podmiotu. -/
def wZakresie : Okoliczności := { bezWarunków with zakresDziałania := true }

/-! ## Art. 191 -/

/-- Art. 191 ust. 1 pkt 1: progi 50 posłów i 30 senatorów. -/
theorem progi_parlamentarzystów :
    (możeWystąpić (.posłowie 50) .zgodnośćZKonstytucją bezWarunków = true) ∧
    (możeWystąpić (.posłowie 49) .zgodnośćZKonstytucją bezWarunków = false) ∧
    (możeWystąpić (.senatorowie 30) .zgodnośćZKonstytucją bezWarunków = true) ∧
    (możeWystąpić (.senatorowie 29) .zgodnośćZKonstytucją bezWarunków = false) := by decide

/-- Art. 191 ust. 2: podmioty z pkt 3–5 tylko w zakresie swojego działania. -/
theorem szczególni_tylko_w_zakresie (p : Podmiot) (o : Okoliczności) (h : p.szczególny = true)
    (z : o.zakresDziałania = false) (s) : możeWystąpić p s o = false := by
  cases p <;> simp [Podmiot.szczególny] at h <;> cases s <;>
    simp [możeWystąpić, Podmiot.ogólny, Podmiot.szczególny, Podmiot.wSporze, z]

/-- Art. 191 ust. 2: w swoim zakresie mogą wystąpić o akty normatywne. -/
theorem szczególni_w_zakresie :
    możeWystąpić .kościół .zgodnośćZKonstytucją wZakresie = true ∧
      możeWystąpić .związekWyznaniowy .zgodnośćZKonstytucją wZakresie = true ∧
      możeWystąpić (.organSamorządu true) .zgodnośćZKonstytucją wZakresie = true ∧
      możeWystąpić (.związekZawodowy true) .przepisyCentralneZKonstytucją wZakresie = true ∧
      możeWystąpić (.organizacjaPracodawców true) .zgodnośćZUmową wZakresie = true ∧
      możeWystąpić (.organizacjaZawodowa true) .przepisyCentralneZUmowąLubUstawą wZakresie = true := by
  decide

/-- Art. 191 ust. 1 pkt 3–4: organ wykonawczy i organy nieogólnokrajowe nie są uprawnione. -/
theorem kwalifikacje_wnioskodawców (s : Sprawa) (o : Okoliczności) :
    możeWystąpić (.organSamorządu false) s o = false ∧
      możeWystąpić (.związekZawodowy false) s o = false ∧
      możeWystąpić (.organizacjaPracodawców false) s o = false ∧
      możeWystąpić (.organizacjaZawodowa false) s o = false := by
  cases s <;> simp [możeWystąpić, Podmiot.ogólny, Podmiot.szczególny, Podmiot.wSporze]

/-- Art. 186 ust. 2: oba zakresy uprawnienia Krajowej Rady Sądownictwa. -/
theorem krs_oba_zakresy :
    możeWystąpić .krajowaRadaSądownictwa .zgodnośćZKonstytucją
        { bezWarunków with niezależnośćSądów := true } = true ∧
      możeWystąpić .krajowaRadaSądownictwa .przepisyCentralneZKonstytucją
        { bezWarunków with niezawisłośćSędziów := true } = true ∧
      możeWystąpić .krajowaRadaSądownictwa .zgodnośćZKonstytucją bezWarunków = false := by
  decide

/-- Art. 186 ust. 2: Krajowa Rada Sądownictwa bada tylko zgodność z Konstytucją. -/
theorem krs_tylko_względem_konstytucji (o) :
    możeWystąpić .krajowaRadaSądownictwa .zgodnośćZUmową o = false ∧
      możeWystąpić .krajowaRadaSądownictwa .przepisyCentralneZUmowąLubUstawą o = false := by
  simp [możeWystąpić, Podmiot.ogólny, Podmiot.szczególny]

/-- Art. 191 ust. 1 pkt 1 wymienia dziewięć organów oraz grupy posłów i senatorów. -/
theorem ogólni_w_wykazie (p : Podmiot) (h : p.ogólny = true) :
    p ∈ [Podmiot.prezydent, .marszałekSejmu, .marszałekSenatu, .prezesRadyMinistrów,
      .pierwszyPrezesSN, .prezesNSA, .prokuratorGeneralny, .prezesNIK,
      .rzecznikPrawObywatelskich] ∨ (∃ n, n ≥ 50 ∧ p = .posłowie n) ∨
      (∃ n, n ≥ 30 ∧ p = .senatorowie n) := by
  cases p <;> simp_all [Podmiot.ogólny]

/-- Podmiot spoza wykazów nie ma żadnej drogi do Trybunału. -/
theorem inny_bez_drogi (s o) : możeWystąpić .inny s o = false := by
  cases s <;> simp [możeWystąpić, Podmiot.ogólny, Podmiot.szczególny, Podmiot.wSporze]

/-! ## Art. 192 -/

/-- Art. 192: spór kompetencyjny nie jest dostępny Rzecznikowi ani parlamentarzystom. -/
theorem spór_węższy (o) :
    możeWystąpić .prezesNIK .sporKompetencyjny o = true ∧
      możeWystąpić .rzecznikPrawObywatelskich .sporKompetencyjny o = false ∧
      możeWystąpić .prokuratorGeneralny .sporKompetencyjny o = false ∧
      możeWystąpić (.posłowie 460) .sporKompetencyjny o = false := ⟨rfl, rfl, rfl, rfl⟩

/-- Art. 192 jest węższy od art. 191 ust. 1 pkt 1. -/
theorem spór_w_ogólnych (p : Podmiot) (h : p.wSporze = true) : p.ogólny = true := by
  cases p <;> simp_all [Podmiot.wSporze, Podmiot.ogólny]

/-! ## Wnioski zastrzeżone -/

/-- Art. 122 ust. 3 i art. 133 ust. 2: kontrola prewencyjna tylko na wniosek Prezydenta. -/
theorem prewencyjna_tylko_prezydent (p o s)
    (r : s = Sprawa.ustawaPrzedPodpisaniem ∨ s = Sprawa.umowaPrzedRatyfikacją)
    (h : możeWystąpić p s o = true) : p = .prezydent := by
  rcases r with rfl | rfl <;> simpa [możeWystąpić] using h

/-- Art. 131 ust. 1: przeszkodę w sprawowaniu urzędu zgłasza tylko Marszałek Sejmu. -/
theorem przeszkoda_tylko_marszałek (p o)
    (h : możeWystąpić p .przeszkodaWSprawowaniuUrzędu o = true) : p = .marszałekSejmu := by
  simpa [możeWystąpić] using h

/-- Art. 79: skarga wymaga naruszenia i ostatecznego orzeczenia, bez praw z art. 56. -/
theorem skarga_wymaga (p o) (h : możeWystąpić p .skarga o = true) :
    p = .osoba ∧ o.naruszenie = true ∧ o.orzeczenieOstateczne = true ∧
      o.prawoZArt56 = false := by
  simpa [możeWystąpić, Bool.and_eq_true, and_assoc] using h

/-- Art. 79 ust. 2: prawa z art. 56 są wyłączone. -/
theorem art56_wyłączony (p o) (h : o.prawoZArt56 = true) :
    możeWystąpić p .skarga o = false := by
  simp [możeWystąpić, h]

/-- Założenie K4: Prezydent nie wnosi skargi, choć art. 191 ust. 1 pkt 1 tego nie wyłącza. -/
theorem prezydent_bez_skargi (o) : możeWystąpić .prezydent .skarga o = false := by
  simp [możeWystąpić]

/-- Założenie K6: podmioty z pkt 3–5 nie wystąpią w sprawie partii politycznej. -/
theorem partia_tylko_ogólni (o) :
    możeWystąpić .kościół .partiaPolityczna o = false ∧
      możeWystąpić .prezydent .partiaPolityczna o = true := ⟨rfl, rfl⟩

/-- Art. 193: pytanie tylko sądu i tylko przy zależności rozstrzygnięcia. -/
theorem pytanie_tylko_sądu (p z) (h : pytanieDopuszczalne p z = true) :
    p = .sąd ∧ z = true := by
  simpa [pytanieDopuszczalne, Bool.and_eq_true] using h

/-- Sąd nie składa wniosku z art. 191 i nie ma drogi poza pytaniem prawnym. -/
theorem sąd_bez_wniosku (s o) (n : s ≠ Sprawa.skarga) : możeWystąpić .sąd s o = false := by
  cases s <;> simp_all [możeWystąpić, Podmiot.ogólny, Podmiot.szczególny, Podmiot.wSporze]

/-! ## Art. 188: wzorce kontroli -/

open RodzajAktu

/-- Każda kontrola z art. 188 idzie od aktu niższego do wyższego. -/
theorem kontrola_zgodna_z_hierarchią (a w : RodzajAktu) (h : kontrolowalny a w = true) :
    Wyższy w a := by
  cases a <;> cases w <;> first
    | (simp [kontrolowalny] at h; done)
    | exact .wprost (.konstytucjaNajwyższa _ (by decide))
    | exact .wprost .umowaPrzedUstawą
    | exact .wprost .ustawaPrzedRozporządzeniem
    | exact .wprost .ustawaPrzedZarządzeniem
    | exact .wprost .ustawaPrzedUchwałą
    | exact .wprost .umowaPrzedRozporządzeniem
    | exact .wprost .umowaPrzedZarządzeniem
    | exact .wprost .umowaPrzedUchwałą
    | exact .przez (.wprost .umowaPrzedUstawą) (.wprost .ustawaPrzedRozporządzeniem)
    | exact .przez (.wprost .umowaPrzedUstawą) (.wprost .ustawaPrzedZarządzeniem)
    | exact .przez (.wprost .umowaPrzedUstawą) (.wprost .ustawaPrzedUchwałą)

/-- Art. 188 pkt 2 obejmuje tylko umowy za zgodą ustawową. -/
theorem umowa_bez_zgody_nie_wzorcem_ustawy : kontrolowalny ustawa umowaBezZgody = false := rfl

/-- Akt prawa miejscowego nie jest przepisem centralnym z art. 188 pkt 3. Teza dotyczy tylko
tego trybu, a nie skargi z art. 79 ani pytania z art. 193. -/
theorem akt_miejscowy_poza_art188_pkt1do3 (w) : kontrolowalny aktPrawaMiejscowego w = false := by
  cases w <;> rfl

/-- Art. 79 ust. 1 mówi o innym akcie normatywnym, więc akt miejscowy o takim charakterze
może być przedmiotem skargi (założenie K8). -/
theorem akt_miejscowy_w_skardze : przedmiotSkargi aktPrawaMiejscowego = true := rfl

/-- Skarga bada akt względem Konstytucji, czyli zawsze od aktu niższego do wyższego. -/
theorem skarga_zgodna_z_hierarchią (a) (h : przedmiotSkargi a = true) : Wyższy konstytucja a := by
  cases a <;> first
    | (simp [przedmiotSkargi] at h; done)
    | exact .wprost (.konstytucjaNajwyższa _ (by decide))

/-- Art. 193: wzorce pytania prawnego to Konstytucja, umowy ratyfikowane i ustawa. -/
theorem wzorce_pytania :
    wzorzecPytania konstytucja = true ∧ wzorzecPytania ustawa = true ∧
      wzorzecPytania umowaBezZgody = true ∧ wzorzecPytania rozporządzenie = false := by decide

/-- Art. 188 pkt 1–3 nie wymieniają prawa organizacji międzynarodowej. -/
theorem prawo_organizacji_poza_art188_pkt1do3 (w) :
    kontrolowalny prawoOrganizacjiMiędzynarodowej w = false := by
  cases w <;> rfl

end Trybunał

end Konstytucja
