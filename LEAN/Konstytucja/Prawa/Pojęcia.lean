import Konstytucja.Podstawy.Normy

/-! # Pojęcia ocenne jako parametry (zasada Z3, założenie E6)

Pojęć nie definiujemy. `Interpretacja` przypisuje im wartość w konkretnej sprawie, a
twierdzenia wskazują, od których pojęć zależy wynik. Frazy z tekstu sprawdza
`dane/pojecia.csv`.
-/

namespace Konstytucja

/-- Cel ograniczenia wolności lub prawa. -/
inductive Cel where
  | bezpieczeństwoPaństwa
  | porządekPubliczny
  | ochronaŚrodowiska
  | zdrowie
  | moralność
  | wolnościInnych
  /-- Art. 45 ust. 2. -/
  | interesPrywatny
  /-- Art. 61 ust. 3. -/
  | interesGospodarczyPaństwa
  | inny
  deriving DecidableEq, Repr

/-- Czynność wewnątrz ustępu, gdy jeden ustęp zawiera kilka norm (założenie E8). -/
inductive Czynność where
  | ogólna
  /-- Art. 45 ust. 1–2. -/
  | jawnośćRozprawy
  /-- Art. 53 ust. 2 i 5. -/
  | uzewnętrznianieReligii
  /-- Art. 54 ust. 2 zd. 1. -/
  | cenzuraPrewencyjna
  /-- Art. 54 ust. 2 zd. 1. -/
  | koncesjonowaniePrasy
  /-- Art. 54 ust. 2 zd. 2. -/
  | koncesjaRadiowoTelewizyjna
  /-- Art. 64 ust. 3. -/
  | własność
  deriving DecidableEq, Repr

/-- Ograniczenie korzystania z wolności lub prawa. -/
structure Ograniczenie where
  /-- Przepis, którego dotyczy ograniczenie. -/
  prawo : Przepis
  /-- Czy ustanowiono je w ustawie. -/
  wUstawie : Bool
  cel : Cel
  czynność : Czynność
  deriving DecidableEq, Repr

inductive Pojęcie where
  /-- Art. 1, art. 82. -/
  | dobroWspólne
  /-- Art. 2. -/
  | demokratycznePaństwoPrawne
  /-- Art. 2. -/
  | sprawiedliwośćSpołeczna
  /-- Art. 5. -/
  | zrównoważonyRozwój
  /-- Art. 30. -/
  | godność
  /-- Art. 31 ust. 3, art. 53 ust. 5. -/
  | konieczne
  /-- Art. 31 ust. 3, art. 64 ust. 3. -/
  | istota
  /-- Art. 22. -/
  | ważnyInteresPubliczny
  /-- Art. 59 ust. 3. -/
  | dobroPubliczne
  /-- Art. 59 ust. 4: nie jest pojęciem ocennym, lecz zależy od umów spoza modelu. -/
  | dopuszczalnePrzezUmowy
  /-- Art. 21 ust. 2. -/
  | słuszneOdszkodowanie
  /-- Art. 45 ust. 1. -/
  | nieuzasadnionaZwłoka
  /-- Art. 51 ust. 2. -/
  | niezbędneWPaństwiePrawnym
  /-- Art. 125 ust. 1. -/
  | szczególneZnaczenie
  /-- Art. 228 ust. 1. -/
  | środkiNiewystarczające
  /-- Art. 228 ust. 5. -/
  | odpowiedniośćDoZagrożenia
  deriving DecidableEq, Repr

/-- Wartość pojęcia w sprawie ograniczenia. -/
abbrev Interpretacja := Pojęcie → Ograniczenie → Bool

/-- Interpretacja różniąca się od `I` tylko pojęciem `c`. -/
def zeZmianą (I : Interpretacja) (c : Pojęcie) (b : Bool) : Interpretacja :=
  fun d o => if d = c then b else I d o

/-- Wynik `f` zmienia się przy zmianie samego pojęcia `c`. -/
def ZależyOd (f : Interpretacja → Bool) (c : Pojęcie) : Prop :=
  ∃ I J : Interpretacja, (∀ d, d ≠ c → I d = J d) ∧ f I = true ∧ f J = false

/-- Zmiana samego pojęcia `c` nigdy nie zmienia wyniku `f`. -/
def NieZależyOd (f : Interpretacja → Bool) (c : Pojęcie) : Prop :=
  ∀ I J : Interpretacja, (∀ d, d ≠ c → I d = J d) → f I = f J

end Konstytucja
