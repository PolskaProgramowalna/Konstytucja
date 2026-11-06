import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat
import Konstytucja.Twierdzenia.Progi
import Konstytucja.Procedury.TworzenieRządu

/-! # Art. 158–162: odpowiedzialność rządu i dymisja jako automat

Stan `urzęduje` nie jest końcowy ani nie jest błędem: rząd może trwać bez końca.
Założenia R1–R7 opisuje `Konstytucja/Założenia.lean`. `PełnyKrok` składa ten automat
z automatem art. 154–155.
-/

namespace Konstytucja.OdpowiedzialnośćRządu

/-- Art. 162 ust. 1–2. -/
inductive PowódDymisji where
  | nowySejm
  | brakWotumZaufania
  | rezygnacja
  deriving DecidableEq, Repr

inductive Etap where
  | urzęduje
  /-- Art. 158 ust. 1–2. `kandydat` to wskazany imiennie Prezes Rady Ministrów. -/
  | wniosekNieufności (kandydat : Nat)
  /-- Art. 158 ust. 1 zd. 2. -/
  | powołanieWybranego (kandydat : Nat)
  /-- Art. 159 ust. 1. -/
  | wniosekMinistra
  /-- Art. 159 ust. 2. -/
  | odwołanieMinistra
  /-- Art. 160. -/
  | wniosekZaufania
  /-- Art. 162 ust. 1–2. -/
  | dymisjaZłożona (powód : PowódDymisji)
  /-- Art. 162 ust. 3: rząd pełni obowiązki, a dalej działa art. 154. -/
  | dymisjaPrzyjęta
  /-- Art. 158 ust. 1 zd. 2. -/
  | nowyRząd (prezes : Nat)
  deriving DecidableEq, Repr

def Etap.końcowy : Etap → Bool
  | .dymisjaPrzyjęta | .nowyRząd _ => true
  | _ => false

/-- Etap, w którym nic nie czeka na rozstrzygnięcie. -/
def Etap.ustalony : Etap → Bool
  | .urzęduje | .dymisjaPrzyjęta | .nowyRząd _ => true
  | _ => false

/-- Definicja pomocnicza do miary rozstrzygania. -/
def Etap.ranga : Etap → Nat
  | .urzęduje | .dymisjaPrzyjęta | .nowyRząd _ => 0
  | .powołanieWybranego _ | .odwołanieMinistra | .dymisjaZłożona _ => 1
  | .wniosekNieufności _ | .wniosekMinistra | .wniosekZaufania => 2

structure Założenia where
  kalendarz : Kalendarz
  /-- Założenie G2. -/
  mianownik : Mianownik
  sejmDziała : Bool
  prezydentDziała : Bool
  /-- Założenie R1. -/
  limit : Option Nat
  /-- Założenie R2. -/
  prógPowtórnyMinistra : Nat

structure Stan where
  etap : Etap
  dzień : Nat
  /-- Dzień ostatniego wniosku przeciw rządowi. -/
  ostatniRząd : Option Nat
  /-- Dzień ostatniego wniosku przeciw ministrowi (R3). -/
  ostatniMinister : Option Nat
  /-- Liczba wniosków, które nie uzyskały większości. -/
  odrzucone : Nat

variable (Z : Założenia)

/-- Czynność bez terminu w tekście. -/
def wLimicie (t t' : Nat) : Prop := wLimicieCzasu Z.limit t t'

/-- Art. 158 ust. 2 zd. 1: co najmniej 7 dni od zgłoszenia. -/
def wOknieGłosowania (t t' : Nat) : Prop := wLimicieCzasu Z.limit (t + 7) t'

/-- Art. 158 ust. 2 zd. 2–3. -/
def powtórnyDopuszczalny (ostatni : Option Nat) (próg n t : Nat) : Prop :=
  n ≥ próg ∨ match ostatni with
    | none => True
    | some z => Z.kalendarz.poMiesiącach z 3 ≤ t

/-- Art. 160: wotum zaufania na wniosek Prezesa Rady Ministrów (założenie G5). -/
def wotumZaufaniaArt160 (g : Głosowanie .sejm) : Prop := kworum g ∧ większośćZwykła g

/-- Art. 159 ust. 2. -/
def wotumNieufnościMinistra (g : Głosowanie .sejm) : Prop := większośćUstawowa g

inductive Krok : Stan → Stan → Prop where
  /-- Art. 158 ust. 1–2. -/
  | zgłoszenieNieufności {t a b o} (n k : Nat) : n ≥ 46 →
      powtórnyDopuszczalny Z a 115 n t →
      Krok ⟨.urzęduje, t, a, b, o⟩ ⟨.wniosekNieufności k, t, some t, b, o⟩
  /-- Art. 158 ust. 1 i ust. 2 zd. 1. -/
  | wotumUchwalone {t t' a b o k} (g) : Z.sejmDziała = true → wotumNieufności g →
      wOknieGłosowania Z t t' →
      Krok ⟨.wniosekNieufności k, t, a, b, o⟩ ⟨.powołanieWybranego k, t', a, b, o⟩
  /-- Art. 158 ust. 2 zd. 1. -/
  | wotumNieuchwalone {t t' a b o k} (g) : Z.sejmDziała = true → ¬ wotumNieufności g →
      wOknieGłosowania Z t t' →
      Krok ⟨.wniosekNieufności k, t, a, b, o⟩ ⟨.urzęduje, t', a, b, o + 1⟩
  /-- Art. 158 ust. 1 zd. 2, założenie R4. Tekst nie podaje terminu. -/
  | powołanieWybranego {t t' a b o k} : Z.prezydentDziała = true → wLimicie Z t t' →
      Krok ⟨.powołanieWybranego k, t, a, b, o⟩ ⟨.nowyRząd k, t', a, b, o⟩
  /-- Art. 159 ust. 1. -/
  | zgłoszenieMinistra {t a b o} (n : Nat) : n ≥ 69 →
      powtórnyDopuszczalny Z b Z.prógPowtórnyMinistra n t →
      Krok ⟨.urzęduje, t, a, b, o⟩ ⟨.wniosekMinistra, t, a, some t, o⟩
  /-- Art. 159 ust. 1–2. -/
  | ministerObalony {t t' a b o} (g) : Z.sejmDziała = true → wotumNieufnościMinistra g →
      wOknieGłosowania Z t t' →
      Krok ⟨.wniosekMinistra, t, a, b, o⟩ ⟨.odwołanieMinistra, t', a, b, o⟩
  /-- Art. 159 ust. 1. -/
  | ministerUtrzymany {t t' a b o} (g) : Z.sejmDziała = true →
      ¬ wotumNieufnościMinistra g → wOknieGłosowania Z t t' →
      Krok ⟨.wniosekMinistra, t, a, b, o⟩ ⟨.urzęduje, t', a, b, o + 1⟩
  /-- Art. 159 ust. 2. Tekst nie podaje terminu. -/
  | odwołanie {t t' a b o} : Z.prezydentDziała = true → wLimicie Z t t' →
      Krok ⟨.odwołanieMinistra, t, a, b, o⟩ ⟨.urzęduje, t', a, b, o⟩
  /-- Art. 160 zd. 1. -/
  | wniosekZaufania {t a b o} : Krok ⟨.urzęduje, t, a, b, o⟩ ⟨.wniosekZaufania, t, a, b, o⟩
  /-- Art. 160 zd. 2. -/
  | zaufanieUdzielone {t t' a b o} (g) : Z.sejmDziała = true → wotumZaufaniaArt160 g →
      wLimicie Z t t' → Krok ⟨.wniosekZaufania, t, a, b, o⟩ ⟨.urzęduje, t', a, b, o⟩
  /-- Art. 162 ust. 2 pkt 1. -/
  | zaufanieNieudzielone {t t' a b o} (g) : Z.sejmDziała = true → ¬ wotumZaufaniaArt160 g →
      wLimicie Z t t' →
      Krok ⟨.wniosekZaufania, t, a, b, o⟩ ⟨.dymisjaZłożona .brakWotumZaufania, t', a, b, o⟩
  /-- Art. 162 ust. 1. -/
  | pierwszePosiedzenie {t a b o} :
      Krok ⟨.urzęduje, t, a, b, o⟩ ⟨.dymisjaZłożona .nowySejm, t, a, b, o⟩
  /-- Art. 162 ust. 2 pkt 3. -/
  | rezygnacja {t a b o} :
      Krok ⟨.urzęduje, t, a, b, o⟩ ⟨.dymisjaZłożona .rezygnacja, t, a, b, o⟩
  /-- Art. 162 ust. 3. Tekst nie podaje terminu. -/
  | przyjęcieDymisji {t t' a b o p} : Z.prezydentDziała = true → wLimicie Z t t' →
      Krok ⟨.dymisjaZłożona p, t, a, b, o⟩ ⟨.dymisjaPrzyjęta, t', a, b, o⟩
  /-- Art. 162 ust. 4: tylko przy rezygnacji. -/
  | odmowaPrzyjęcia {t t' a b o} : Z.prezydentDziała = true → wLimicie Z t t' →
      Krok ⟨.dymisjaZłożona .rezygnacja, t, a, b, o⟩ ⟨.urzęduje, t', a, b, o⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.urzęduje, 0, none, none, 0⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

/-- Złożenie z automatem art. 154–155. -/
abbrev PełnyStan := Stan ⊕ TworzenieRządu.Stan

variable (R : TworzenieRządu.Założenia)

inductive PełnyKrok : PełnyStan → PełnyStan → Prop where
  | odpowiedzialność {a b} : Krok Z a b → PełnyKrok (.inl a) (.inl b)
  | tworzenie {a b} : TworzenieRządu.Krok R a b → PełnyKrok (.inr a) (.inr b)
  /-- Art. 154 ust. 1, założenie R6. -/
  | poDymisji {t a b o} :
      PełnyKrok (.inl ⟨.dymisjaPrzyjęta, t, a, b, o⟩) (.inr ⟨.powołanie154, t⟩)
  /-- Założenie R5. -/
  | objęcieUrzędu {t} :
      PełnyKrok (.inr ⟨.rząd, t⟩) (.inl ⟨.urzęduje, t, none, none, 0⟩)

end Konstytucja.OdpowiedzialnośćRządu
