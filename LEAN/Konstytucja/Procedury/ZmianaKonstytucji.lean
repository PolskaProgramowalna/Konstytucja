import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat
import Konstytucja.Twierdzenia.Progi

/-! # Art. 235: zmiana Konstytucji jako automat

Dzień 0 to przedłożenie projektu Sejmowi. Założenia V1–V9 opisuje
`Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.ZmianaKonstytucji

/-- Art. 235 ust. 1. -/
inductive Wnioskodawca where
  | posłowie (liczba : Nat)
  | senat
  | prezydent

/-- Art. 235 ust. 1: co najmniej 1/5 ustawowej liczby posłów. -/
def Wnioskodawca.uprawniony : Wnioskodawca → Prop
  | .posłowie n => 5 * n ≥ Izba.sejm.ustawowaLiczba
  | .senat | .prezydent => True

/-- Wynik referendum z art. 235 ust. 6, w ważnych głosach (V6). -/
structure WynikReferendum where
  za : Nat
  przeciw : Nat

/-- Art. 235 ust. 6 zd. 3. Warunku frekwencji w tym przepisie nie ma. -/
def przyjęta (r : WynikReferendum) : Prop := 2 * r.za > r.za + r.przeciw

inductive Etap where
  /-- Art. 235 ust. 3. -/
  | przedCzytaniem
  /-- Art. 235 ust. 4–5. -/
  | poCzytaniu
  /-- Art. 235 ust. 2 i 4. -/
  | senat
  /-- Art. 235 ust. 6 zd. 1: 45 dni na żądanie referendum. -/
  | oczekiwanie
  /-- Art. 235 ust. 6 zd. 2. -/
  | referendum
  /-- Art. 125 ust. 4. -/
  | ważność
  /-- Art. 235 ust. 7 zd. 1. -/
  | marszałek
  /-- Art. 235 ust. 7 zd. 2. -/
  | prezydent
  /-- Założenie V8. -/
  | trybunał
  | podpisPoTrybunale
  | podpisana
  | upadła
  deriving DecidableEq, Repr

def Etap.końcowy : Etap → Bool
  | .podpisana | .upadła => true
  | _ => false

/-- Definicja pomocnicza: maksymalna liczba pozostałych kroków. -/
def Etap.ranga : Etap → Nat
  | .marszałek => 4
  | .ważność => 5
  | .referendum => 6
  | .oczekiwanie => 7
  | .senat => 8
  | .poCzytaniu => 9
  | .przedCzytaniem => 10
  | .prezydent => 3
  | .trybunał => 2
  | .podpisPoTrybunale => 1
  | .podpisana | .upadła => 0

structure Założenia where
  /-- Czy ustawa dotyczy rozdziałów I, II lub XII. -/
  chroniona : Bool
  wnioskodawca : Wnioskodawca
  wnioskodawcaUprawniony : wnioskodawca.uprawniony
  /-- Założenie G2. -/
  mianownik : Mianownik
  /-- Sejm wraz z Marszałkiem. -/
  sejmDziała : Bool
  prezydentDziała : Bool
  sądDziała : Bool
  trybunałOrzeka : Bool
  /-- Założenie V8. -/
  trybunałPrzedPodpisem : Bool
  /-- Art. 228 ust. 6. -/
  stanNadzwyczajny : Nat → Bool
  /-- Art. 228 ust. 7: stan nadzwyczajny i 90 dni po nim. -/
  okresOchronny : Nat → Bool
  stanWOkresie : ∀ t, stanNadzwyczajny t = true → okresOchronny t = true
  /-- Założenie V5. -/
  zakazDotyczyReferendum : Bool
  /-- Założenie V9. -/
  limit : Option Nat

structure Stan where
  etap : Etap
  dzień : Nat
  /-- Dni pozostałe na podpis. -/
  pozostało : Nat
  /-- Czy zażądano referendum. -/
  referendum : Bool

variable (Z : Założenia)

/-- Czynność bez terminu w tekście. -/
def wLimicie (t t' : Nat) : Prop := wLimicieCzasu Z.limit t t'

/-- Co najmniej `n` dni od `t`, a limit liczy się od pierwszego dozwolonego dnia (V9). -/
def wOknie (t n t' : Nat) : Prop := wLimicieCzasu Z.limit (t + n) t'

/-- Art. 235 ust. 5. -/
def odstępSejmu : Nat := if Z.chroniona then 60 else 0

/-- Art. 228 ust. 7 przy wybranym wariancie V5. -/
def referendumDozwolone (t : Nat) : Prop :=
  Z.okresOchronny t = false ∨ Z.zakazDotyczyReferendum = false

inductive Krok : Stan → Stan → Prop where
  /-- Art. 235 ust. 3. -/
  | pierwszeCzytanie {t t' r x} : Z.sejmDziała = true → wOknie Z t 30 t' →
      Krok ⟨.przedCzytaniem, t, r, x⟩ ⟨.poCzytaniu, t', r, x⟩
  /-- Art. 235 ust. 4–5. -/
  | uchwalenieSejmu {t t' r x} (g) : Z.sejmDziała = true →
      zmianaKonstytucjiSejm Z.mianownik g → wOknie Z t (odstępSejmu Z) t' →
      Krok ⟨.poCzytaniu, t, r, x⟩ ⟨.senat, t', r, x⟩
  /-- Art. 235 ust. 4. -/
  | nieuchwalenieSejmu {t t' r x} (g) : Z.sejmDziała = true →
      ¬ zmianaKonstytucjiSejm Z.mianownik g → wLimicie Z t t' →
      Krok ⟨.poCzytaniu, t, r, x⟩ ⟨.upadła, t', r, x⟩
  /-- Art. 235 ust. 2 i 4, ust. 7. -/
  | senatUchwala {t t' r x} (g) : zmianaKonstytucjiSenat Z.mianownik g → wCiągu t 60 t' →
      Z.chroniona = false → Krok ⟨.senat, t, r, x⟩ ⟨.marszałek, t', r, x⟩
  /-- Art. 235 ust. 2 i 4, ust. 6. -/
  | senatUchwalaChronioną {t t' r x} (g) : zmianaKonstytucjiSenat Z.mianownik g →
      wCiągu t 60 t' → Z.chroniona = true →
      Krok ⟨.senat, t, r, x⟩ ⟨.oczekiwanie, t', r, x⟩
  /-- Art. 235 ust. 4. -/
  | senatOdrzuca {t t' r x} (g) : ¬ zmianaKonstytucjiSenat Z.mianownik g → wCiągu t 60 t' →
      Krok ⟨.senat, t, r, x⟩ ⟨.upadła, t', r, x⟩
  /-- Art. 235 ust. 2: milczenie Senatu to brak zmiany, inaczej niż w art. 121 ust. 2. -/
  | senatMilczy {t r x} : Krok ⟨.senat, t, r, x⟩ ⟨.upadła, t + 60, r, x⟩
  /-- Art. 235 ust. 6 zd. 1–2. -/
  | żądanie {t t' r x} (u : Wnioskodawca) : u.uprawniony → wCiągu t 45 t' →
      Krok ⟨.oczekiwanie, t, r, x⟩ ⟨.referendum, t', r, true⟩
  /-- Założenie V3. -/
  | brakŻądania {t r x} : Krok ⟨.oczekiwanie, t, r, x⟩ ⟨.marszałek, t + 45, r, x⟩
  /-- Art. 235 ust. 6 zd. 2–3, art. 228 ust. 7. -/
  | referendumPrzyjęte {t t' r x} (w) : Z.sejmDziała = true → przyjęta w → wCiągu t 60 t' →
      referendumDozwolone Z t' → Krok ⟨.referendum, t, r, x⟩ ⟨.ważność, t', r, x⟩
  /-- Art. 235 ust. 6 zd. 3, art. 228 ust. 7. -/
  | referendumOdrzucone {t t' r x} (w) : Z.sejmDziała = true → ¬ przyjęta w →
      wCiągu t 60 t' → referendumDozwolone Z t' →
      Krok ⟨.referendum, t, r, x⟩ ⟨.upadła, t', r, x⟩
  /-- Art. 125 ust. 4. -/
  | ważnośćStwierdzona {t t' r x} : Z.sądDziała = true → wLimicie Z t t' →
      Krok ⟨.ważność, t, r, x⟩ ⟨.marszałek, t', r, x⟩
  /-- Art. 125 ust. 4, założenie V7. -/
  | nieważność {t t' r x} : Z.sądDziała = true → wLimicie Z t t' →
      Krok ⟨.ważność, t, r, x⟩ ⟨.upadła, t', r, x⟩
  /-- Art. 235 ust. 7 zd. 1–2. -/
  | przedstawienie {t t' r x} : Z.sejmDziała = true → wLimicie Z t t' →
      Krok ⟨.marszałek, t, r, x⟩ ⟨.prezydent, t', 21, x⟩
  /-- Art. 235 ust. 7 zd. 2, art. 228 ust. 6 (V4). -/
  | podpis {t d r x} : Z.prezydentDziała = true → d ≤ r →
      Z.stanNadzwyczajny (t + d) = false →
      Krok ⟨.prezydent, t, r, x⟩ ⟨.podpisana, t + d, r - d, x⟩
  /-- Założenie V8. -/
  | wniosekDoTrybunału {t d r x} : Z.prezydentDziała = true → d ≤ r →
      Z.trybunałPrzedPodpisem = true →
      Krok ⟨.prezydent, t, r, x⟩ ⟨.trybunał, t + d, r - d, x⟩
  /-- Założenie V8. -/
  | orzeczenieZgodna {t t' r x} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.trybunał, t, r, x⟩ ⟨.podpisPoTrybunale, t', r, x⟩
  /-- Założenie V8. -/
  | orzeczenieNiezgodna {t t' r x} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.trybunał, t, r, x⟩ ⟨.upadła, t', r, x⟩
  /-- Założenia V4 i V8. -/
  | podpisPoZgodności {t d r x} : Z.prezydentDziała = true → d ≤ r →
      Z.stanNadzwyczajny (t + d) = false →
      Krok ⟨.podpisPoTrybunale, t, r, x⟩ ⟨.podpisana, t + d, r - d, x⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.przedCzytaniem, 0, 0, false⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

end Konstytucja.ZmianaKonstytucji
