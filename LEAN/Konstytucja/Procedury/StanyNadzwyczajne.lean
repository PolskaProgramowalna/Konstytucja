import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat
import Konstytucja.Podstawy.Normy
import Konstytucja.Podstawy.Głosowanie

/-! # Art. 228–234: stany nadzwyczajne jako automat

Automat liczy chwile w godzinach (S1). Stan w toku pamięta początek, planowany koniec
i liczbę przedłużeń. Założenia S1–S8 opisuje `Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.StanyNadzwyczajne

/-- Art. 228 ust. 1. -/
inductive Rodzaj where
  | wojenny
  | wyjątkowy
  | klęskaŻywiołowa
  deriving DecidableEq, Repr

/-- Liczba godzin w `d` dniach (S1). -/
def godziny (d : Nat) : Nat := 24 * d

inductive Etap where
  | normalny
  /-- Art. 229 i art. 230: wniosek Rady Ministrów czeka na decyzję Prezydenta. -/
  | decyzjaPrezydenta (r : Rodzaj)
  /-- Art. 231 zd. 1: 48 godzin od podpisania. -/
  | podpisane (r : Rodzaj) (początek : Nat) (koniec : Option Nat)
  /-- Art. 231 zd. 2–3. -/
  | uSejmu (r : Rodzaj) (początek : Nat) (koniec : Option Nat)
  /-- Stan trwa. `przedłużenia` liczy przedłużenia z art. 230 ust. 2 i art. 232. -/
  | trwa (r : Rodzaj) (początek : Nat) (koniec : Option Nat) (przedłużenia : Nat)
  /-- Art. 228 ust. 7: stan się zakończył, trwa 90 dni ochrony. -/
  | poStanie (r : Rodzaj) (początek koniec : Nat)
  deriving DecidableEq, Repr

/-- Etap, w którym nic nie czeka na rozstrzygnięcie. -/
def Etap.ustalony : Etap → Bool
  | .normalny | .poStanie _ _ _ => true
  | _ => false

/-- Definicja pomocnicza do miary zamykania stanu. -/
def Etap.ranga : Etap → Nat
  | .normalny | .poStanie _ _ _ => 0
  | .trwa _ _ _ _ => 1
  | .uSejmu _ _ _ => 2
  | .podpisane _ _ _ => 3
  | .decyzjaPrezydenta _ => 4

structure Założenia where
  /-- Art. 228 ust. 1, założenie S2. -/
  środkiNiewystarczające : Bool
  /-- Art. 229–230, 232, założenie S2. -/
  przesłanka : Rodzaj → Bool
  sejmDziała : Bool
  prezydentDziała : Bool
  /-- Art. 231 zd. 2: liczba godzin mieszcząca się w „niezwłocznie”. -/
  niezwłocznie : Nat
  /-- Art. 234 ust. 1: zmienia się w czasie. -/
  sejmMożeObradować : Nat → Bool
  /-- Założenie G2. -/
  mianownik : Mianownik
  kalendarz : Kalendarz

structure Stan where
  etap : Etap
  chwila : Nat
  /-- Rozporządzenia z art. 234 czekające na zatwierdzenie. -/
  doZatwierdzenia : Nat

variable (Z : Założenia)

/-- Art. 228 ust. 1. -/
def przesłankiSpełnione (r : Rodzaj) : Prop :=
  Z.środkiNiewystarczające = true ∧ Z.przesłanka r = true

/-- Art. 231 zd. 3. -/
def uchylenie (g : Głosowanie .sejm) : Prop := kworum g ∧ większośćBezwzględna Z.mianownik g

/-- Stan obowiązuje najdłużej do planowanego końca. -/
def doKońca (k : Option Nat) (t : Nat) : Prop :=
  match k with
  | none => True
  | some e => t ≤ e

/-- W etapach obowiązywania czas nie może minąć planowanego końca. -/
def możeCzekać (e : Etap) (t : Nat) : Prop :=
  match e with
  | .podpisane _ _ k | .uSejmu _ _ k | .trwa _ _ k _ => doKońca k t
  | _ => True

/-- Założenie S4. -/
def zgodaSejmu (g : Głosowanie .sejm) : Prop := kworum g ∧ większośćZwykła g

inductive Krok : Stan → Stan → Prop where
  /-- Art. 229 i art. 230 ust. 1: wniosek Rady Ministrów. -/
  | wniosek {t x} (r : Rodzaj) : r ≠ .klęskaŻywiołowa → przesłankiSpełnione Z r →
      Krok ⟨.normalny, t, x⟩ ⟨.decyzjaPrezydenta r, t, x⟩
  /-- Art. 229–230 „może”, założenie S3. -/
  | odmowa {t r x} : Z.prezydentDziała = true →
      Krok ⟨.decyzjaPrezydenta r, t, x⟩ ⟨.normalny, t, x⟩
  /-- Art. 229: tekst nie podaje czasu trwania stanu wojennego. -/
  | wprowadzenieWojennego {t x} : Z.prezydentDziała = true →
      Krok ⟨.decyzjaPrezydenta .wojenny, t, x⟩ ⟨.podpisane .wojenny t none, t, x⟩
  /-- Art. 230 ust. 1: do 90 dni. -/
  | wprowadzenieWyjątkowego {t d x} : Z.prezydentDziała = true → d ≤ 90 →
      Krok ⟨.decyzjaPrezydenta .wyjątkowy, t, x⟩
        ⟨.podpisane .wyjątkowy t (some (t + godziny d)), t, x⟩
  /-- Art. 231 zd. 1. -/
  | przedstawienie {r p k t t' x} : Z.prezydentDziała = true →
      wTerminie Z.kalendarz p (.godziny 48) t' → t ≤ t' → doKońca k t' →
      Krok ⟨.podpisane r p k, t, x⟩ ⟨.uSejmu r p k, t', x⟩
  /-- Art. 231 zd. 2: Sejm nie uchyla. -/
  | utrzymanie {r p k t t' x} : Z.sejmDziała = true → t ≤ t' → t' ≤ t + Z.niezwłocznie →
      doKońca k t' →
      Krok ⟨.uSejmu r p k, t, x⟩ ⟨.trwa r p k 0, t', x⟩
  /-- Art. 231 zd. 3. -/
  | uchylenie {r p k t t' x} (g) : Z.sejmDziała = true → uchylenie Z g → t ≤ t' →
      t' ≤ t + Z.niezwłocznie → doKońca k t' →
      Krok ⟨.uSejmu r p k, t, x⟩ ⟨.poStanie r p t', t', x⟩
  /-- Art. 230 ust. 1: stan wygasa z upływem czasu, także przed decyzją Sejmu. -/
  | wygaśnięciePodpisanego {r p k t x} : t ≤ k →
      Krok ⟨.podpisane r p (some k), t, x⟩ ⟨.poStanie r p k, k, x⟩
  /-- Art. 230 ust. 1: stan wygasa z upływem czasu, także przed decyzją Sejmu. -/
  | wygaśnięcieUSejmu {r p k t x} : t ≤ k →
      Krok ⟨.uSejmu r p (some k), t, x⟩ ⟨.poStanie r p k, k, x⟩
  /-- Art. 232: Rada Ministrów wprowadza stan klęski bez udziału Prezydenta i Sejmu. -/
  | wprowadzenieKlęski {t d x} : przesłankiSpełnione Z .klęskaŻywiołowa → d ≤ 30 →
      Krok ⟨.normalny, t, x⟩ ⟨.trwa .klęskaŻywiołowa t (some (t + godziny d)) 0, t, x⟩
  /-- Art. 230 ust. 2: tylko raz, do 60 dni, za zgodą Sejmu. -/
  | przedłużenieWyjątkowego {p k t d x} (g) : Z.sejmDziała = true → zgodaSejmu g → d ≤ 60 →
      Krok ⟨.trwa .wyjątkowy p (some k) 0, t, x⟩
        ⟨.trwa .wyjątkowy p (some (k + godziny d)) 1, t, x⟩
  /-- Art. 232 zd. 2: za zgodą Sejmu, bez limitu w tekście. -/
  | przedłużenieKlęski {p k t d e x} (g) : Z.sejmDziała = true → zgodaSejmu g →
      Krok ⟨.trwa .klęskaŻywiołowa p (some k) e, t, x⟩
        ⟨.trwa .klęskaŻywiołowa p (some (k + godziny d)) (e + 1), t, x⟩
  /-- Art. 234 ust. 1. -/
  | rozporządzenieZMocąUstawy {p k t e x} : Z.prezydentDziała = true →
      Z.sejmMożeObradować t = false →
      Krok ⟨.trwa .wojenny p k e, t, x⟩ ⟨.trwa .wojenny p k e, t, x + 1⟩
  /-- Art. 234 ust. 1 zd. 2: także po zakończeniu stanu wojennego. -/
  | zatwierdzenie {e t x} : Z.sejmDziała = true → Z.sejmMożeObradować t = true →
      Krok ⟨e, t, x + 1⟩ ⟨e, t, x⟩
  /-- Założenie S5: koniec nie później niż w planowanym dniu. -/
  | koniec {r p k e t t' x} : t ≤ t' → t' ≤ k →
      Krok ⟨.trwa r p (some k) e, t, x⟩ ⟨.poStanie r p t', t', x⟩
  /-- Założenie S5: stan wojenny nie ma terminu w tekście. -/
  | końcowaDecyzja {p e t t' x} : Z.prezydentDziała = true → t ≤ t' →
      Krok ⟨.trwa .wojenny p none e, t, x⟩ ⟨.poStanie .wojenny p t', t', x⟩
  /-- Art. 228 ust. 7: po 90 dniach od końca. -/
  | końcowyPowrót {r p k t x} : k + godziny 90 ≤ t →
      Krok ⟨.poStanie r p k, t, x⟩ ⟨.normalny, t, x⟩
  /-- Upływ czasu. W etapach obowiązywania tylko do planowanego końca. -/
  | czekanie {e t t' x} : t ≤ t' → możeCzekać e t' → Krok ⟨e, t, x⟩ ⟨e, t', x⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.normalny, 0, 0⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

/-! ## Art. 233: katalogi wolności i praw -/

/-- Art. 233 ust. 1: przepisy, których nie można ograniczyć w stanie wojennym i wyjątkowym.
Wartość `ust = 0` nie ma znaczenia dla artykułów chronionych w całości. -/
def nienaruszalne (p : Przepis) : Bool :=
  [30, 34, 36, 38, 39, 40, 42, 45, 47, 48, 53, 63, 72].contains p.art ||
    (p.art == 41 && p.ust == 4)

/-- Art. 233 ust. 3: przepisy, które wolno ograniczyć w stanie klęski żywiołowej. -/
def dozwoloneWKlęsce (p : Przepis) : Bool :=
  [22, 50, 64].contains p.art ||
    (p.art == 41 && [1, 3, 5].contains p.ust) ||
    (p.art == 52 && p.ust == 1) ||
    (p.art == 59 && p.ust == 3) ||
    (p.art == 65 && p.ust == 1) ||
    (p.art == 66 && [1, 2].contains p.ust)

/-- Art. 233 ust. 1 i 3. -/
def możnaOgraniczyć : Rodzaj → Przepis → Bool
  | .klęskaŻywiołowa, p => dozwoloneWKlęsce p
  | _, p => !nienaruszalne p

/-- Art. 233 ust. 2. -/
inductive Motyw where
  | rasa
  | płeć
  | język
  | wyznanie
  | pochodzenieSpołeczne
  | urodzenie
  | majątek
  /-- Każdy inny motyw, np. sam stopień zagrożenia. -/
  | inny
  deriving DecidableEq, Repr

/-- Art. 233 ust. 2: niedopuszczalne ograniczenie wyłącznie z tych powodów. -/
def motywZakazany : Motyw → Bool
  | .inny => false
  | _ => true

/-- Art. 233 ust. 1–3 razem, założenie S8. -/
def ograniczenieDopuszczalne (r : Rodzaj) (p : Przepis) (m : Motyw) : Bool :=
  możnaOgraniczyć r p && !motywZakazany m

/-- Art. 228 ust. 6. -/
inductive Akt where
  | konstytucja
  | ordynacjaWyborcza
  | ustawaOWyborzePrezydenta
  | ustawaOStanachNadzwyczajnych
  | innaUstawa
  deriving DecidableEq, Repr

def niezmiennyWStanie : Akt → Bool
  | .innaUstawa => false
  | _ => true

/-! ## Art. 228 ust. 7: okres ochronny dla innych procedur -/

/-- Zakończone stany jako pary dni: początek i koniec. -/
abbrev Historia := List (Nat × Nat)

/-- Art. 228 ust. 6: dzień, w którym trwa stan nadzwyczajny. -/
def wStanie (h : Historia) (t : Nat) : Bool :=
  h.any fun x => x.1 ≤ t && t ≤ x.2

/-- Art. 228 ust. 7, założenie S6. -/
def wOkresieOchronnym (h : Historia) (t : Nat) : Bool :=
  h.any fun x => x.1 ≤ t && t ≤ x.2 + 90

/-- Pierwszy dzień od `t` poza okresem ochronnym, przy `f` krokach zapasu. -/
def pierwszyWolny (h : Historia) : Nat → Nat → Nat
  | 0, t => t
  | f + 1, t => if wOkresieOchronnym h t then pierwszyWolny h f (t + 1) else t

/-- Pierwszy dzień, od którego historia nie chroni. -/
def koniecOchrony (h : Historia) : Nat := (h.map fun x => x.2 + 91).foldr max 0

/-- Założenie S7: pierwszy dzień poza okresem ochronnym obejmującym koniec kadencji.
Późniejsze, niezwiązane stany nie mają wpływu. -/
def przedłużonaKadencja (h : Historia) (koniec : Nat) : Nat :=
  pierwszyWolny h (koniecOchrony h - koniec) koniec

end Konstytucja.StanyNadzwyczajne
