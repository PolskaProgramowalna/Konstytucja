/-! # Test ciągłości Trybunału Konstytucyjnego: model stanów i kontrole (plan_tk.txt)

Moduł formalizuje konstrukcje planu testu, które da się sprawdzić niezależnie od danych:
- składowe stanu osoby: tytuł i faktyczna funkcja (pkt 4.3, przejścia T7, T9, T10),
- kontrole F9a i F9b (utrata tytułu nie usuwa funkcji),
- przykład kontrolny T10 z recenzji (dni 10/15/20),
- kontrprzykład kworum z recenzji (pkt 13.2) i kontrprzykład „wariantów skrajnych” (B4),
- liczbę wariantów modułu M1 po utożsamieniu 4.6 (pkt 5.1) i liczby M2, M3,
- okno pierwszeństwa dat (kontrola F4).

Konstrukcje są pomocnicze (zasada Z1 z plan.txt): nie mają odpowiednika w przepisie,
a wynik testu nie ma mocy prawnej (P6). Silnik obliczeniowy: `dane/tk/`.
-/

namespace Konstytucja.TK.Ciaglosc

/-- Wynik oceny (zasada P4). -/
inductive Wynik3 where
  | spełniony
  | naruszony
  | nieustalony
  deriving DecidableEq, Repr

/-- Składowa „tytuł” stanu osoby (S5 / S7 / tytuł nieustalony, pkt 4.3). -/
inductive Tytuł where
  | brak
  | jest
  | nieustalony
  deriving DecidableEq, Repr

/-- Składowa „funkcja”: S6/S6* (potwierdzona), S6? i „funkcja NIEUSTALONA” (T10). -/
inductive Funkcja where
  | brak
  | potwierdzona
  | nieustalona
  deriving DecidableEq, Repr

structure StanOsoby where
  tytuł : Tytuł
  funkcja : Funkcja
  deriving DecidableEq, Repr

/-- Zdarzenia zmieniające stan osoby (pkt 4.2). -/
inductive Zdarzenie where
  /-- T6: objęcie urzędu (S5). -/
  | objęcie
  /-- T7: E6b albo koniec kadencji; `pewny = false` - koniec tytułu nieustalony. -/
  | koniecTytułu (pewny : Bool)
  /-- E4. -/
  | dopuszczenie
  /-- E4-. -/
  | cofnięcie
  /-- E6a. -/
  | śmierć
  /-- E10: udokumentowane zaprzestanie funkcji. -/
  | zaprzestanie
  /-- Dzień po utracie tytułu z dowodem aktywności E5 (`true`) albo bez niego (`false`). -/
  | dzień (dowód : Bool)
  deriving DecidableEq, Repr

/-- Przejścia T6, T7, T9 i T10. Tytuł i funkcja są osobnymi składowymi stanu. -/
def krok (s : StanOsoby) : Zdarzenie → StanOsoby
  | .objęcie => { s with tytuł := .jest }
  | .koniecTytułu true => { s with tytuł := .brak }
  | .koniecTytułu false => { s with tytuł := .nieustalony }
  | .dopuszczenie => { s with funkcja := .potwierdzona }
  | .cofnięcie => { s with funkcja := .brak }
  | .śmierć => { tytuł := .brak, funkcja := .brak }
  | .zaprzestanie => { s with funkcja := .brak }
  | .dzień dowód =>
    match s.tytuł, s.funkcja with
    | .jest, f => { s with funkcja := f }
    | _, .brak => s
    | _, _ => { s with funkcja := if dowód then .potwierdzona else .nieustalona }

/-- Historia zdarzeń. -/
def przebieg (s : StanOsoby) (zs : List Zdarzenie) : StanOsoby := zs.foldl krok s

/-- F9a: utrata tytułu (bez E4-, E6a, E10) nie zmienia składowej funkcji. -/
theorem F9a (s : StanOsoby) (p : Bool) : (krok s (.koniecTytułu p)).funkcja = s.funkcja := by
  cases p <;> rfl

/-- T10: funkcja kończy się wyłącznie przy E4-, E6a albo E10. -/
theorem koniec_funkcji_tylko (s : StanOsoby) (e : Zdarzenie)
    (h : s.funkcja ≠ .brak) (h' : (krok s e).funkcja = .brak) :
    e = .cofnięcie ∨ e = .śmierć ∨ e = .zaprzestanie := by
  cases e with
  | objęcie => exact absurd h' h
  | koniecTytułu p => cases p <;> exact absurd h' h
  | dopuszczenie => cases h'
  | cofnięcie => exact Or.inl rfl
  | śmierć => exact Or.inr (Or.inl rfl)
  | zaprzestanie => exact Or.inr (Or.inr rfl)
  | dzień d =>
    rcases s with ⟨t, f⟩
    cases t <;> cases f <;> cases d <;> simp_all [krok]

/-- F9b (granica górna): dzień bez dowodu nie zeruje funkcji - osoba pozostaje
w granicy górnej licznika F(t), a przy braku tytułu także B(t). -/
theorem F9b (s : StanOsoby) (d : Bool) (h : s.funkcja ≠ .brak) :
    (krok s (.dzień d)).funkcja ≠ .brak := by
  rcases s with ⟨t, f⟩
  cases t <;> cases f <;> cases d <;> simp_all [krok]

/-- F9b (granica dolna): dzień bez dowodu nie daje aktywności potwierdzonej po utracie tytułu. -/
theorem F9b_dolna (s : StanOsoby) (h : s.tytuł ≠ .jest) (hf : s.funkcja ≠ .brak) :
    (krok s (.dzień false)).funkcja = .nieustalona := by
  rcases s with ⟨t, f⟩
  cases t <;> cases f <;> simp_all [krok]

/-- Przykład kontrolny T10 (recenzja, sekcja 15): tytuł kończy się w dniu 10, ostatnie E5
w dniu 15, brak E4-, E6a, E10; tEnd = 20. Dni liczone od dnia 10. -/
def historiaT10 (n : Nat) : List Zdarzenie :=
  .dopuszczenie :: .objęcie :: .koniecTytułu true ::
    (List.range n).map fun k => .dzień (k + 10 == 15)

def stanPoczątkowy : StanOsoby := { tytuł := .brak, funkcja := .brak }

/-- Dzień 15: aktywność potwierdzona (S6*). -/
example : (przebieg stanPoczątkowy (historiaT10 6)).funkcja = .potwierdzona := by decide
/-- Dzień 16 i każdy następny do tEnd: aktywność nieustalona - nic nie kończy się w dniu 15. -/
example : (przebieg stanPoczątkowy (historiaT10 7)).funkcja = .nieustalona := by decide
example : (przebieg stanPoczątkowy (historiaT10 10)).funkcja = .nieustalona := by decide
/-- Dni 10-14: nieustalona (granica górna). -/
example : (przebieg stanPoczątkowy (historiaT10 5)).funkcja = .nieustalona := by decide

/-! ## Kworum ZO wariantu Z3.Qb i kontrprzykład z recenzji (pkt 13.2) -/

/-- Z3.Qb: więcej niż połowa osób mających w danym dniu tytuł jest obecna. -/
def kworumQb (obecniZTytułem wszyscyZTytułem : Nat) : Bool := 2 * obecniZTytułem > wszyscyZTytułem

/-- 7 osób z tytułem ustalonym (4 obecne), 2 niepewne (1 obecna, 1 nieobecna). -/
def kworumPrzykład (obecnaMaTytuł nieobecnaMaTytuł : Bool) : Bool :=
  kworumQb (4 + if obecnaMaTytuł then 1 else 0)
    (7 + (if obecnaMaTytuł then 1 else 0) + (if nieobecnaMaTytuł then 1 else 0))

/-- Zbiorcze warianty „wszyscy niewliczeni / wszyscy wliczeni” dają kworum... -/
theorem zbiorcze_zgodne : kworumPrzykład false false = true ∧ kworumPrzykład true true = true := by
  decide

/-- ...ale wariant mieszany je narusza, więc skrót zbiorczy jest niedozwolony (P10). -/
theorem mieszany_narusza : kworumPrzykład false true = false := by decide

/-! ## Kontrprzykład „wariantów skrajnych” (recenzja, B4) -/

def fB4 (a b : Bool) : Bool := a != b

theorem skrajne_nie_wystarczą : fB4 false false = fB4 true true ∧ fB4 false true ≠ fB4 false false := by
  decide

/-! ## Liczba wariantów (pkt 5.1) -/

/-- Wartości parametrów modułu M1: Z1 (a, b, c, d14, d30, d90), Z2, Z4 (a, bR1, bR2),
Z7 (a, b, c), Z12. -/
def wariantyM1 : List (Fin 6 × Fin 2 × Fin 3 × Fin 3 × Fin 2) :=
  (List.finRange 6).flatMap fun z1 => (List.finRange 2).flatMap fun z2 =>
    (List.finRange 3).flatMap fun z4 => (List.finRange 3).flatMap fun z7 =>
      (List.finRange 2).map fun z12 => (z1, z2, z4, z7, z12)

/-- 4.6: przy Z7c (indeks 2) wariant Z4.bR2 (indeks 2) jest utożsamiony z Z4.bR1. -/
def utożsamiony (w : Fin 6 × Fin 2 × Fin 3 × Fin 3 × Fin 2) : Bool :=
  w.2.2.2.1 == 2 && w.2.2.1 == 2

set_option maxRecDepth 8000 in
theorem liczba_M1_nominalna : wariantyM1.length = 216 := by decide

set_option maxRecDepth 8000 in
theorem liczba_M1 : (wariantyM1.filter (fun w => !utożsamiony w)).length = 192 := by decide

/-- M2 = M1 × Z3(2·2·3) × Z5(2·3) × Z8(2); M3 = M2 × 2^6 (wspólne parametry raz). -/
theorem liczba_M2 : 192 * (2 * 2 * 3) * (2 * 3) * 2 = 27648 := by decide
theorem liczba_M3 : 27648 * 2 ^ 6 = 1769472 := by decide

/-! ## Okno pierwszeństwa dat (F4) -/

/-- Twierdzenia o pierwszej dacie dotyczą wyłącznie okna danych `[tStart, t1)`. -/
def wOknieDanych (tStart t t1 : Nat) : Prop := tStart ≤ t ∧ t < t1

theorem wOknieDanych_nie_przed_startem {tStart t t1 : Nat} (h : t < tStart) : ¬ wOknieDanych tStart t t1 := by
  intro ⟨h1, _⟩; omega

/-! ## Pomocnicze: rozstrzygalny test braku powtórzeń (kontrola F2 w danych) -/

/-- Brak powtórzeń jako funkcja logiczna, obliczalna przez `decide`. -/
def bezPowtórzeń : List Nat → Bool
  | [] => true
  | x :: xs => !xs.contains x && bezPowtórzeń xs

theorem nodup_z_bezPowtórzeń (l : List Nat) (h : bezPowtórzeń l = true) : l.Nodup := by
  induction l with
  | nil => exact List.nodup_nil
  | cons x xs ih =>
    simp only [bezPowtórzeń, Bool.and_eq_true, Bool.not_eq_true'] at h
    refine List.nodup_cons.mpr ⟨?_, ih h.2⟩
    intro hx
    have : xs.contains x = true := List.contains_iff_mem.mpr hx
    simp_all

end Konstytucja.TK.Ciaglosc
