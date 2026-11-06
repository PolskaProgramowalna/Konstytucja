import Konstytucja.Prawa.Pojęcia
import Konstytucja.Procedury.StanyNadzwyczajne

/-! # Art. 31 ust. 3 i klauzule szczególne

Do przepisu i czynności należy lista warunków, a nie jedna klauzula: art. 59 ust. 3 ma
warunek z ust. 3 i warunek z ust. 4. Założenia E1–E8 opisuje `Konstytucja/Założenia.lean`.
Frazy klauzul sprawdza `dane/klauzule.csv`.
-/

namespace Konstytucja

open Cel

/-- Art. 31 ust. 3: cele dopuszczone ogólnie. -/
def celOgólny : Cel → Bool
  | bezpieczeństwoPaństwa | porządekPubliczny | ochronaŚrodowiska | zdrowie | moralność
  | wolnościInnych => true
  | _ => false

/-- Art. 31 ust. 3. -/
def warunekOgólny (I : Interpretacja) (o : Ograniczenie) : Bool :=
  o.wUstawie && celOgólny o.cel && I .konieczne o && !I .istota o

/-- Warunek właściwy dla normy, poza art. 31 ust. 3. -/
inductive Klauzula where
  /-- Zakaz bez wyjątku, założenie E2. -/
  | zakaz
  /-- Przepis odsyła do ustawy (np. art. 49, art. 57). -/
  | ustawowa
  /-- Zamknięty katalog celów (art. 45 ust. 2, art. 61 ust. 3). -/
  | cele (l : List Cel)
  /-- Katalog celów i konieczność (art. 53 ust. 5). -/
  | celeIKonieczność (l : List Cel)
  /-- Własna przesłanka (art. 22, art. 59 ust. 3–4). -/
  | przesłanka (c : Pojęcie)
  /-- Tylko istota prawa (art. 64 ust. 3). -/
  | istotaPrawa
  deriving DecidableEq, Repr

/-- Warunki właściwe dla przepisu i czynności, założenia E5 i E8. Pusta lista oznacza tryb
ogólny z art. 31 ust. 3. -/
def klauzule : Przepis → Czynność → List Klauzula
  | ⟨54, 2, _⟩, .koncesjaRadiowoTelewizyjna => [.ustawowa]
  | ⟨30, _, _⟩, _ | ⟨39, _, _⟩, _ | ⟨40, _, _⟩, _ | ⟨34, 2, _⟩, _ | ⟨52, 4, _⟩, _
  | ⟨53, 6, _⟩, _ | ⟨53, 7, _⟩, _ | ⟨54, 2, _⟩, _ => [.zakaz]
  | ⟨41, 1, _⟩, _ | ⟨46, _, _⟩, _ | ⟨48, 2, _⟩, _ | ⟨49, _, _⟩, _ | ⟨50, _, _⟩, _
  | ⟨51, 3, _⟩, _ | ⟨52, 1, _⟩, _ | ⟨52, 2, _⟩, _ | ⟨57, _, _⟩, _ | ⟨65, 1, _⟩, _
  | ⟨78, _, _⟩, _ => [.ustawowa]
  | ⟨45, 1, _⟩, .jawnośćRozprawy =>
    [.cele [moralność, bezpieczeństwoPaństwa, porządekPubliczny, interesPrywatny]]
  | ⟨53, 2, _⟩, .uzewnętrznianieReligii =>
    [.celeIKonieczność [bezpieczeństwoPaństwa, porządekPubliczny, zdrowie, moralność, wolnościInnych]]
  | ⟨61, 1, _⟩, _ | ⟨61, 2, _⟩, _ =>
    [.cele [wolnościInnych, porządekPubliczny, bezpieczeństwoPaństwa, interesGospodarczyPaństwa]]
  | ⟨22, _, _⟩, _ => [.przesłanka .ważnyInteresPubliczny]
  | ⟨59, 3, _⟩, _ => [.przesłanka .dobroPubliczne, .przesłanka .dopuszczalnePrzezUmowy]
  | ⟨59, 1, _⟩, _ | ⟨59, 2, _⟩, _ => [.przesłanka .dopuszczalnePrzezUmowy]
  | ⟨64, _, _⟩, .własność => [.istotaPrawa]
  | _, _ => []

/-- Warunek jednej klauzuli, założenie E4. -/
def warunekKlauzuli (I : Interpretacja) (o : Ograniczenie) : Klauzula → Bool
  | .zakaz => false
  | .ustawowa => o.wUstawie
  | .cele l => o.wUstawie && l.contains o.cel
  | .celeIKonieczność l => o.wUstawie && l.contains o.cel && I .konieczne o
  | .przesłanka c => o.wUstawie && I c o
  | .istotaPrawa => o.wUstawie && !I .istota o

/-- Wszystkie warunki właściwe dla ograniczenia. -/
def spełniaKlauzule (I : Interpretacja) (o : Ograniczenie) : Bool :=
  (klauzule o.prawo o.czynność).all (warunekKlauzuli I o)

/-- Klauzula własnym katalogiem może zastąpić art. 31 ust. 3 (założenie E1). -/
def zastępujeOgólny : Klauzula → Bool
  | .zakaz | .ustawowa => false
  | _ => true

/-- Założenie E1. -/
inductive Tryb where
  /-- Klauzule i art. 31 ust. 3 razem. -/
  | łącznie
  /-- Klauzula szczególna zastępuje art. 31 ust. 3. -/
  | klauzulaZamiast
  deriving DecidableEq, Repr

/-- Czy ograniczenie jest dopuszczalne poza stanem nadzwyczajnym. -/
def dopuszczalne (t : Tryb) (I : Interpretacja) (o : Ograniczenie) : Bool :=
  spełniaKlauzule I o &&
    match t with
    | .łącznie => warunekOgólny I o
    | .klauzulaZamiast =>
      (klauzule o.prawo o.czynność).any zastępujeOgólny || warunekOgólny I o

/-- Podział z planu: czy dana czynność w ogóle podlega ograniczeniom. -/
def podlegaOgraniczeniom (p : Przepis) (c : Czynność) : Bool := !(klauzule p c).contains .zakaz

/-- Art. 81: prawa, których można dochodzić w granicach ustawy. -/
def wGranicachUstawy (p : Przepis) : Bool :=
  (p.art == 65 && [4, 5].contains p.ust) ||
    [66, 69, 71, 74, 75, 76].contains p.art

/-- Warianty E3 i E7 dla stanu nadzwyczajnego. -/
structure RegułyStanu where
  /-- E3: czy obowiązuje art. 31 ust. 3. -/
  art31 : Bool
  /-- E7: czy obowiązują zakazy i klauzule spoza art. 233 ust. 1. -/
  klauzule : Bool
  deriving DecidableEq, Repr

open StanyNadzwyczajne in
/-- Art. 228 ust. 3 i 5 oraz art. 233. Warianty E3 i E7 są od siebie niezależne. -/
def dopuszczalneWStanie (R : RegułyStanu) (r : Rodzaj) (m : Motyw) (I : Interpretacja)
    (o : Ograniczenie) : Bool :=
  o.wUstawie && ograniczenieDopuszczalne r o.prawo m && I .odpowiedniośćDoZagrożenia o &&
    (!R.klauzule || spełniaKlauzule I o) && (!R.art31 || warunekOgólny I o)

end Konstytucja
