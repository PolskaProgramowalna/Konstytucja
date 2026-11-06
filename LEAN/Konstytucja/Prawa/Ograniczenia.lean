import Konstytucja.Prawa.Pojęcia
import Konstytucja.Procedury.StanyNadzwyczajne

/-! # Art. 31 ust. 3 i klauzule szczególne

Założenia E1–E5 opisuje `Konstytucja/Założenia.lean`. Frazy klauzul sprawdza
`dane/klauzule.csv`.
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

/-- Sposób ograniczania przepisu. -/
inductive Klauzula where
  /-- Tylko art. 31 ust. 3. -/
  | ogólna
  /-- Zakaz bez wyjątku, założenie E2. -/
  | zakaz
  /-- Przepis odsyła do ustawy (np. art. 49, art. 57). -/
  | ustawowa
  /-- Zamknięty katalog celów (art. 45 ust. 2, art. 61 ust. 3). -/
  | cele (l : List Cel)
  /-- Katalog celów i konieczność (art. 53 ust. 5). -/
  | celeIKonieczność (l : List Cel)
  /-- Własna przesłanka ocenna (art. 22, art. 59 ust. 3–4). -/
  | przesłanka (c : Pojęcie)
  /-- Tylko istota prawa (art. 64 ust. 3). -/
  | istotaPrawa
  deriving DecidableEq, Repr

/-- Klauzula właściwa dla przepisu, założenie E5. -/
def klauzula : Przepis → Klauzula
  | ⟨30, _, _⟩ | ⟨39, _, _⟩ | ⟨40, _, _⟩ | ⟨34, 2, _⟩ | ⟨52, 4, _⟩ | ⟨53, 6, _⟩ | ⟨53, 7, _⟩
  | ⟨54, 2, _⟩ => .zakaz
  | ⟨41, 1, _⟩ | ⟨46, _, _⟩ | ⟨48, 2, _⟩ | ⟨49, _, _⟩ | ⟨50, _, _⟩ | ⟨51, 3, _⟩
  | ⟨52, 1, _⟩ | ⟨52, 2, _⟩ | ⟨57, _, _⟩ | ⟨65, 1, _⟩ | ⟨78, _, _⟩ => .ustawowa
  | ⟨45, 1, _⟩ => .cele [moralność, bezpieczeństwoPaństwa, porządekPubliczny, interesPrywatny]
  | ⟨53, 2, _⟩ =>
    .celeIKonieczność [bezpieczeństwoPaństwa, porządekPubliczny, zdrowie, moralność, wolnościInnych]
  | ⟨61, 1, _⟩ | ⟨61, 2, _⟩ =>
    .cele [wolnościInnych, porządekPubliczny, bezpieczeństwoPaństwa, interesGospodarczyPaństwa]
  | ⟨22, _, _⟩ => .przesłanka .ważnyInteresPubliczny
  | ⟨59, 3, _⟩ => .przesłanka .dobroPubliczne
  | ⟨59, 1, _⟩ => .przesłanka .dopuszczalnePrzezUmowy
  | ⟨64, _, _⟩ => .istotaPrawa
  | _ => .ogólna

/-- Warunek samej klauzuli, założenie E4. -/
def warunekKlauzuli (I : Interpretacja) (o : Ograniczenie) : Klauzula → Bool
  | .ogólna => true
  | .zakaz => false
  | .ustawowa => o.wUstawie
  | .cele l => o.wUstawie && l.contains o.cel
  | .celeIKonieczność l => o.wUstawie && l.contains o.cel && I .konieczne o
  | .przesłanka c => o.wUstawie && I c o
  | .istotaPrawa => o.wUstawie && !I .istota o

/-- Założenie E1. -/
inductive Tryb where
  /-- Klauzula i art. 31 ust. 3 razem. -/
  | łącznie
  /-- Klauzula szczególna zastępuje art. 31 ust. 3. -/
  | klauzulaZamiast
  deriving DecidableEq, Repr

/-- Czy ograniczenie jest dopuszczalne poza stanem nadzwyczajnym. -/
def dopuszczalne (t : Tryb) (I : Interpretacja) (o : Ograniczenie) : Bool :=
  match klauzula o.prawo, t with
  | .zakaz, _ => false
  | .ogólna, _ => warunekOgólny I o
  | .ustawowa, _ => warunekOgólny I o
  | k, .łącznie => warunekKlauzuli I o k && warunekOgólny I o
  | k, .klauzulaZamiast => warunekKlauzuli I o k

/-- Podział z planu: czy przepis w ogóle podlega ograniczeniom. -/
def podlegaOgraniczeniom (p : Przepis) : Bool := klauzula p != .zakaz

/-- Art. 81: prawa, których można dochodzić w granicach ustawy. -/
def wGranicachUstawy (p : Przepis) : Bool :=
  (p.art == 65 && [4, 5].contains p.ust) ||
    [66, 69, 71, 74, 75, 76].contains p.art

open StanyNadzwyczajne in
/-- Art. 228 ust. 3 i 5 oraz art. 233. `art31` to wariant E3. -/
def dopuszczalneWStanie (art31 : Bool) (r : Rodzaj) (m : Motyw) (t : Tryb)
    (I : Interpretacja) (o : Ograniczenie) : Bool :=
  o.wUstawie && ograniczenieDopuszczalne r o.prawo m && I .odpowiedniośćDoZagrożenia o &&
    (!art31 || dopuszczalne t I o)

end Konstytucja
