import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat
import Konstytucja.Twierdzenia.Progi

/-! # Art. 118–123: postępowanie ustawodawcze jako automat

Zakres to zwykła ustawa, także w trybie pilnym. Założenia U1–U8 i C1–C5 opisuje
`Konstytucja/Założenia.lean`. Pole `pozostało` to zegar terminu podpisania: przejścia
do Trybunału i do Sejmu go zatrzymują (art. 122 ust. 6, założenie U1).
-/

namespace Konstytucja.Ustawodawstwo

/-- Art. 123 ust. 1: rodzaje projektów, które nie mogą być pilne, oraz pozostałe. -/
inductive RodzajProjektu where
  | zwykły
  | podatkowy
  | wyborczy
  | ustrojowy
  | kodeks
  deriving DecidableEq, Repr

def RodzajProjektu.możePilny : RodzajProjektu → Bool
  | .zwykły => true
  | _ => false

inductive Etap where
  /-- Art. 119–120. -/
  | sejm
  /-- Art. 121 ust. 2. -/
  | senat
  /-- Art. 121 ust. 3: poprawki Senatu. -/
  | sejmPoPoprawkach
  /-- Art. 121 ust. 3: uchwała odrzucająca. -/
  | sejmPoOdrzuceniu
  /-- Art. 122 ust. 1. -/
  | marszałek
  /-- Art. 122 ust. 2, 3 i 5. -/
  | prezydent
  /-- Art. 122 ust. 3. -/
  | trybunał
  /-- Art. 122 ust. 3 zd. 2: Prezydent nie może odmówić podpisu. -/
  | podpisPoTrybunale
  /-- Art. 122 ust. 4 zd. 2: niezgodność poszczególnych przepisów. -/
  | wybórPoTrybunale
  /-- Art. 122 ust. 4: zwrot w celu usunięcia niezgodności. -/
  | sejmUsuwa
  /-- Art. 122 ust. 5 zd. 1. -/
  | sejmPoWecie
  /-- Art. 122 ust. 5 zd. 2–3. -/
  | prezydentPoWecie
  | podpisana
  | podpisanaCzęściowo
  | upadła
  | wycofana
  deriving DecidableEq, Repr

def Etap.końcowy : Etap → Bool
  | .podpisana | .podpisanaCzęściowo | .upadła | .wycofana => true
  | _ => false

/-- Definicja pomocnicza do miary dowodu zakończenia. -/
def Etap.ranga : Etap → Nat
  | .sejmUsuwa => 9
  | .sejm => 8
  | .senat => 7
  | .sejmPoPoprawkach | .sejmPoOdrzuceniu => 6
  | .marszałek => 5
  | .prezydent => 4
  | .trybunał => 3
  | .wybórPoTrybunale | .sejmPoWecie => 2
  | .podpisPoTrybunale | .prezydentPoWecie => 1
  | .podpisana | .podpisanaCzęściowo | .upadła | .wycofana => 0

structure Założenia where
  rodzaj : RodzajProjektu
  /-- Art. 123 ust. 1. -/
  pilny : Bool
  pilnośćDopuszczalna : pilny = true → rodzaj.możePilny = true
  /-- Założenie G2. -/
  mianownik : Mianownik
  sejmDziała : Bool
  /-- Założenie U9. -/
  sejmRozpatruje : Bool
  prezydentDziała : Bool
  trybunałOrzeka : Bool
  /-- Założenie U6. -/
  limit : Option Nat
  /-- Założenie U7. -/
  maksPowrotów : Option Nat
  /-- Założenie U4. -/
  powrótPrzezSenat : Bool

/-- Art. 121 ust. 2 i art. 123 ust. 3. -/
def terminSenatu (Z : Założenia) : Nat := if Z.pilny then 14 else 30

/-- Art. 122 ust. 2 i art. 123 ust. 3. -/
def terminPodpisu (Z : Założenia) : Nat := if Z.pilny then 7 else 21

/-- Założenie U7. -/
def możnaZwrócić (Z : Założenia) (p : Nat) : Prop :=
  match Z.maksPowrotów with
  | none => True
  | some m => p < m

structure Stan where
  etap : Etap
  dzień : Nat
  /-- Dni pozostałe na podpis. -/
  pozostało : Nat
  /-- Czy Prezydent wystąpił do Trybunału. -/
  wystąpił : Bool
  /-- Liczba zwrotów z art. 122 ust. 4. -/
  powroty : Nat

variable (Z : Założenia)

/-- U6. -/
def wLimicie (t t' : Nat) : Prop := wLimicieCzasu Z.limit t t'

inductive Krok : Stan → Stan → Prop where
  /-- Art. 120, art. 121 ust. 1. -/
  | uchwalenie {t t' r w p} (g) : Z.sejmDziała = true → uchwalenieUstawy g → wLimicie Z t t' →
      Krok ⟨.sejm, t, r, w, p⟩ ⟨.senat, t', r, w, p⟩
  /-- Art. 120. -/
  | nieuchwalenie {t t' r w p} (g) : Z.sejmDziała = true → ¬ uchwalenieUstawy g →
      wLimicie Z t t' → Krok ⟨.sejm, t, r, w, p⟩ ⟨.upadła, t', r, w, p⟩
  /-- Art. 119 ust. 4. Moment wycofania nie jest modelowany (U2). -/
  | wycofanie {t t' r w p} : wLimicie Z t t' → Krok ⟨.sejm, t, r, w, p⟩ ⟨.wycofana, t', r, w, p⟩
  /-- Art. 121 ust. 2. -/
  | senatPrzyjmuje {t t' r w p} : wCiągu t (terminSenatu Z) t' →
      Krok ⟨.senat, t, r, w, p⟩ ⟨.marszałek, t', r, w, p⟩
  /-- Art. 121 ust. 2 zd. 2: milczenie Senatu. -/
  | senatMilczy {t r w p} :
      Krok ⟨.senat, t, r, w, p⟩ ⟨.marszałek, t + terminSenatu Z, r, w, p⟩
  /-- Art. 121 ust. 2. -/
  | senatPoprawia {t t' r w p} : wCiągu t (terminSenatu Z) t' →
      Krok ⟨.senat, t, r, w, p⟩ ⟨.sejmPoPoprawkach, t', r, w, p⟩
  /-- Art. 121 ust. 2. -/
  | senatOdrzuca {t t' r w p} : wCiągu t (terminSenatu Z) t' →
      Krok ⟨.senat, t, r, w, p⟩ ⟨.sejmPoOdrzuceniu, t', r, w, p⟩
  /-- Art. 121 ust. 3: ustawa idzie dalej, z poprawką lub bez niej. -/
  | poprawkiRozpatrzone {t t' r w p} : Z.sejmRozpatruje = true → wLimicie Z t t' →
      Krok ⟨.sejmPoPoprawkach, t, r, w, p⟩ ⟨.marszałek, t', r, w, p⟩
  /-- Art. 121 ust. 3. -/
  | odrzucenieOdrzucone {t t' r w p} (g) : Z.sejmRozpatruje = true →
      odrzucenieStanowiskaSenatu Z.mianownik g → wLimicie Z t t' →
      Krok ⟨.sejmPoOdrzuceniu, t, r, w, p⟩ ⟨.marszałek, t', r, w, p⟩
  /-- Art. 121 ust. 3. -/
  | odrzucenieUtrzymane {t t' r w p} (g) : Z.sejmRozpatruje = true →
      ¬ odrzucenieStanowiskaSenatu Z.mianownik g → wLimicie Z t t' →
      Krok ⟨.sejmPoOdrzuceniu, t, r, w, p⟩ ⟨.upadła, t', r, w, p⟩
  /-- Art. 122 ust. 1–2, art. 123 ust. 3. Zegar startuje od nowa. -/
  | przedstawienie {t t' r w p} : Z.sejmDziała = true → wLimicie Z t t' →
      Krok ⟨.marszałek, t, r, w, p⟩ ⟨.prezydent, t', terminPodpisu Z, w, p⟩
  /-- Art. 122 ust. 2. -/
  | podpis {t d r w p} : Z.prezydentDziała = true → d ≤ r →
      Krok ⟨.prezydent, t, r, w, p⟩ ⟨.podpisana, t + d, r - d, w, p⟩
  /-- Art. 122 ust. 3 i 6. -/
  | wniosekDoTrybunału {t d r w p} : Z.prezydentDziała = true → d ≤ r →
      Krok ⟨.prezydent, t, r, w, p⟩ ⟨.trybunał, t + d, r - d, true, p⟩
  /-- Art. 122 ust. 5 zd. 1 i ust. 6. -/
  | weto {t d r p} : Z.prezydentDziała = true → d ≤ r →
      Krok ⟨.prezydent, t, r, false, p⟩ ⟨.sejmPoWecie, t + d, r - d, false, p⟩
  /-- Art. 122 ust. 3 zd. 2, założenie U1. -/
  | orzeczenieZgodna {t t' r w p} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.trybunał, t, r, w, p⟩ ⟨.podpisPoTrybunale, t', r, w, p⟩
  /-- Art. 122 ust. 4 zd. 1. -/
  | orzeczenieNiezgodna {t t' r w p} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.trybunał, t, r, w, p⟩ ⟨.upadła, t', r, w, p⟩
  /-- Art. 122 ust. 4 zd. 2, założenie U1. -/
  | orzeczenieCzęściowa {t t' r w p} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.trybunał, t, r, w, p⟩ ⟨.wybórPoTrybunale, t', r, w, p⟩
  /-- Art. 122 ust. 3 zd. 2. -/
  | podpisPoZgodności {t d r w p} : Z.prezydentDziała = true → d ≤ r →
      Krok ⟨.podpisPoTrybunale, t, r, w, p⟩ ⟨.podpisana, t + d, r - d, w, p⟩
  /-- Art. 122 ust. 4 zd. 2. -/
  | podpisZPominięciem {t d r w p} : Z.prezydentDziała = true → d ≤ r →
      Krok ⟨.wybórPoTrybunale, t, r, w, p⟩ ⟨.podpisanaCzęściowo, t + d, r - d, w, p⟩
  /-- Art. 122 ust. 4 zd. 2, założenie U7. -/
  | zwrot {t d r w p} : Z.prezydentDziała = true → d ≤ r → możnaZwrócić Z p →
      Krok ⟨.wybórPoTrybunale, t, r, w, p⟩ ⟨.sejmUsuwa, t + d, r - d, w, p + 1⟩
  /-- Założenia U3 i U4. -/
  | usunięcie {t t' r w p} : Z.sejmDziała = true → wLimicie Z t t' →
      Z.powrótPrzezSenat = false → Krok ⟨.sejmUsuwa, t, r, w, p⟩ ⟨.marszałek, t', r, w, p⟩
  /-- Założenia U3 i U4. -/
  | usunięcieZSenatem {t t' r w p} : Z.sejmDziała = true → wLimicie Z t t' →
      Z.powrótPrzezSenat = true → Krok ⟨.sejmUsuwa, t, r, w, p⟩ ⟨.senat, t', r, w, p⟩
  /-- Art. 122 ust. 5 zd. 2. -/
  | ponowneUchwalenie {t t' r w p} (g) : Z.sejmDziała = true →
      odrzucenieWeta Z.mianownik g → wLimicie Z t t' →
      Krok ⟨.sejmPoWecie, t, r, w, p⟩ ⟨.prezydentPoWecie, t', 7, w, p⟩
  /-- Art. 122 ust. 5 zd. 2. -/
  | wetoUtrzymane {t t' r w p} (g) : Z.sejmDziała = true →
      ¬ odrzucenieWeta Z.mianownik g → wLimicie Z t t' →
      Krok ⟨.sejmPoWecie, t, r, w, p⟩ ⟨.upadła, t', r, w, p⟩
  /-- Art. 122 ust. 5 zd. 2–3: tylko podpis. -/
  | podpisPoWecie {t d r w p} : Z.prezydentDziała = true → d ≤ r →
      Krok ⟨.prezydentPoWecie, t, r, w, p⟩ ⟨.podpisana, t + d, r - d, w, p⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.sejm, 0, 0, false, 0⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

end Konstytucja.Ustawodawstwo
