import Konstytucja.Podstawy.Normy

/-! # Statyczna wykonalność i kolizje w wybranym systemie norm

Własności b i c z etapu 6, założenia F1 i F2. Sytuacja opisuje jeden moment: nie rozróżnia
wykonania teraz i później. Terminy bada `Twierdzenia/Terminowość.lean`. Kolizja nie zawsze
znaczy niewykonalność: zakaz i dozwolenie tego samego czynu można spełnić razem.
-/

namespace Konstytucja.SystemNorm

/-- Sytuacja ustrojowa. Pola są niezależne, a związek stanu z okresem ochronnym opisują
instancje. -/
structure Sytuacja where
  /-- Art. 155 ust. 2. -/
  brakWotum : Bool
  /-- Art. 228 ust. 7. -/
  okresOchronny : Bool
  /-- Art. 228 ust. 6. -/
  stanNadzwyczajny : Bool
  /-- Art. 131 ust. 4. -/
  zastępstwo : Bool
  /-- Art. 128 ust. 2. -/
  urządOpróżniony : Bool
  /-- Art. 235 ust. 6. -/
  żądanieReferendum : Bool
  /-- Wariant V5. -/
  zakazObejmujeReferendum : Bool
  /-- Art. 235 ust. 7. -/
  zmianaPrzedstawiona : Bool
  /-- Art. 225. -/
  budżetSpóźniony : Bool
  deriving DecidableEq, Repr

inductive Czyn where
  | skrócenieKadencji
  | wyboryPrezydenta
  | referendumZatwierdzające
  | podpisZmiany
  deriving DecidableEq, Repr

inductive Id where
  | nakaz155
  | zakaz228Kadencja
  | zakaz131
  | dozwolenie225
  | nakaz128
  | zakaz228Wybory
  | nakaz235Referendum
  | zakaz228Referendum
  | nakaz235Podpis
  | zakaz228Zmiana
  deriving DecidableEq, Repr

def wszystkie : List Id :=
  [.nakaz155, .zakaz228Kadencja, .zakaz131, .dozwolenie225, .nakaz128, .zakaz228Wybory,
   .nakaz235Referendum, .zakaz228Referendum, .nakaz235Podpis, .zakaz228Zmiana]

/-- Pomocniczy skrót dla norm bez wyjątku. -/
def normaProsta (art ust : Nat) (m : Modalność) (c : Czyn) (z : Sytuacja → Prop) :
    Norma Sytuacja Czyn :=
  ⟨{ art := art, ust := ust }, m, c, z, fun _ => False⟩

def norma : Id → Norma Sytuacja Czyn
  | .nakaz155 => normaProsta 155 2 .nakaz .skrócenieKadencji (·.brakWotum = true)
  | .zakaz228Kadencja => normaProsta 228 7 .zakaz .skrócenieKadencji (·.okresOchronny = true)
  | .zakaz131 => normaProsta 131 4 .zakaz .skrócenieKadencji (·.zastępstwo = true)
  | .dozwolenie225 => normaProsta 225 0 .dozwolenie .skrócenieKadencji (·.budżetSpóźniony = true)
  | .nakaz128 => normaProsta 128 2 .nakaz .wyboryPrezydenta (·.urządOpróżniony = true)
  | .zakaz228Wybory => normaProsta 228 7 .zakaz .wyboryPrezydenta (·.okresOchronny = true)
  | .nakaz235Referendum =>
    normaProsta 235 6 .nakaz .referendumZatwierdzające (·.żądanieReferendum = true)
  | .zakaz228Referendum =>
    normaProsta 228 7 .zakaz .referendumZatwierdzające
      (fun s => s.okresOchronny = true ∧ s.zakazObejmujeReferendum = true)
  | .nakaz235Podpis => normaProsta 235 7 .nakaz .podpisZmiany (·.zmianaPrzedstawiona = true)
  | .zakaz228Zmiana => normaProsta 228 6 .zakaz .podpisZmiany (·.stanNadzwyczajny = true)

/-- Cały system norm. -/
def system : List (Norma Sytuacja Czyn) := wszystkie.map norma

/-- Warunek niewykonalności: działa para nakaz i zakaz tego samego czynu. -/
def sprzeczna (s : Sytuacja) : Prop :=
  (s.brakWotum = true ∧ (s.okresOchronny = true ∨ s.zastępstwo = true)) ∨
    (s.urządOpróżniony = true ∧ s.okresOchronny = true) ∨
    (s.żądanieReferendum = true ∧ s.okresOchronny = true ∧ s.zakazObejmujeReferendum = true) ∨
    (s.zmianaPrzedstawiona = true ∧ s.stanNadzwyczajny = true)

/-- Pary nakaz i zakaz w systemie: jedyne kolizje dające statyczną niewykonalność. -/
def paryNiewykonalne : List (Id × Id) :=
  [(.nakaz155, .zakaz228Kadencja), (.nakaz155, .zakaz131), (.nakaz128, .zakaz228Wybory),
   (.nakaz235Referendum, .zakaz228Referendum), (.nakaz235Podpis, .zakaz228Zmiana)]

/-- Kolizje dozwolenia z zakazem. Nie dają niewykonalności, ale wymagają rozstrzygnięcia,
czy dozwolenie działa. -/
def paryDozwoleń : List (Id × Id) :=
  [(.dozwolenie225, .zakaz228Kadencja), (.dozwolenie225, .zakaz131)]

/-- Wszystkie pary kolizyjne systemu. -/
def paryKolizji : List (Id × Id) := paryNiewykonalne ++ paryDozwoleń

/-- Reguła pierwszeństwa: `R a b` oznacza, że `a` ustępuje `b`. -/
abbrev Reguły := Id → Id → Bool

/-- Każda kolizja systemu ma regułę w jedną albo drugą stronę. -/
def Rozstrzygnięty (R : Reguły) : Prop :=
  ∀ p ∈ paryKolizji, R p.1 p.2 = true ∨ R p.2 p.1 = true

/-- Tekst Konstytucji nie podaje reguły dla żadnej z tych par (założenie modelu). -/
def bezReguł : Reguły := fun _ _ => false

/-- Wariant: nakazy i dozwolenia ustępują zakazom. -/
def zakazyPierwsze : Reguły := fun a b => paryKolizji.contains (a, b)

/-- Wariant: zakazy ustępują nakazom, a dozwolenia nadal ustępują zakazom. -/
def nakazyPierwsze : Reguły := fun a b =>
  paryNiewykonalne.contains (b, a) || paryDozwoleń.contains (a, b)

/-- Norma po zastosowaniu reguł: wypada, gdy działa norma, której ma ustąpić. -/
def poRegułach (R : Reguły) (i : Id) : Norma Sytuacja Czyn :=
  { norma i with
    wyjątek := fun s => (norma i).wyjątek s ∨ ∃ j, R i j = true ∧ (norma j).działa s }

/-- System po zastosowaniu reguł. -/
def systemPo (R : Reguły) : List (Norma Sytuacja Czyn) := wszystkie.map (poRegułach R)

end Konstytucja.SystemNorm
