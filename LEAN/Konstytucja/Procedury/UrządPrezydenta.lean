import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat
import Konstytucja.Twierdzenia.Progi
import Konstytucja.Procedury.WybórPrezydenta

/-! # Art. 131 i art. 145: ciągłość urzędu Prezydenta jako automat

Założenia W5 i W7–W9 opisuje `Konstytucja/Założenia.lean`. `PełnyKrok` składa ten automat
z automatem wyboru.
-/

namespace Konstytucja.UrządPrezydenta

/-- Kto wykonuje obowiązki Prezydenta. -/
inductive Osoba where
  | prezydent
  | marszałekSejmu
  | marszałekSenatu
  deriving DecidableEq, Repr

/-- Art. 131 ust. 2. Pkt 3 opisuje przejście z automatu wyboru. -/
inductive Powód where
  | śmierć
  | zrzeczenie
  | trwałaNiezdolność
  | złożenieZUrzędu
  deriving DecidableEq, Repr

inductive Etap where
  | sprawuje
  /-- Art. 131 ust. 1 zd. 2: wniosek Marszałka Sejmu do Trybunału. -/
  | wniosekDoTrybunału
  /-- Art. 131 ust. 1. -/
  | przejściowaNiemożność
  /-- Art. 145 ust. 3. -/
  | zawieszony
  /-- Art. 131 ust. 2. -/
  | opróżniony (p : Powód)
  deriving DecidableEq, Repr

structure Założenia where
  /-- Art. 131 ust. 3, założenie W9. -/
  marszałekSejmuMoże : Bool
  trybunałOrzeka : Bool
  trybunałStanuOrzeka : Bool
  limit : Option Nat

structure Stan where
  etap : Etap
  dzień : Nat
  wykonujący : Osoba

variable (Z : Założenia)

def wLimicie (t t' : Nat) : Prop := wLimicieCzasu Z.limit t t'

/-- Art. 131 ust. 1–3. -/
def zastępca : Osoba := if Z.marszałekSejmuMoże then .marszałekSejmu else .marszałekSenatu

/-- Art. 145 ust. 2. -/
def stanOskarżenia (wnioskodawcy : Nat) (g : Głosowanie .zgromadzenieNarodowe) : Prop :=
  wnioskodawcy ≥ 140 ∧ uchwałaZgromadzeniaArt145 g

inductive Krok : Stan → Stan → Prop where
  /-- Art. 131 ust. 1 zd. 1. -/
  | zawiadomienie {t} : Krok ⟨.sprawuje, t, .prezydent⟩ ⟨.przejściowaNiemożność, t, zastępca Z⟩
  /-- Art. 131 ust. 1 zd. 2. -/
  | wniosekMarszałka {t} :
      Krok ⟨.sprawuje, t, .prezydent⟩ ⟨.wniosekDoTrybunału, t, .prezydent⟩
  /-- Art. 131 ust. 1 zd. 3. -/
  | trybunałUznaje {t t'} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.wniosekDoTrybunału, t, .prezydent⟩ ⟨.przejściowaNiemożność, t', zastępca Z⟩
  /-- Art. 131 ust. 1 zd. 2. -/
  | trybunałNieUznaje {t t'} : Z.trybunałOrzeka = true → wLimicie Z t t' →
      Krok ⟨.wniosekDoTrybunału, t, .prezydent⟩ ⟨.sprawuje, t', .prezydent⟩
  /-- Założenie W7. -/
  | powrót {t t' o} : wLimicie Z t t' →
      Krok ⟨.przejściowaNiemożność, t, o⟩ ⟨.sprawuje, t', .prezydent⟩
  /-- Art. 145 ust. 2–3, założenie W8. -/
  | zawieszenie {t} (n : Nat) (g) : stanOskarżenia n g →
      Krok ⟨.sprawuje, t, .prezydent⟩ ⟨.zawieszony, t, zastępca Z⟩
  /-- Art. 131 ust. 2 pkt 5. -/
  | złożenie {t t' o} : Z.trybunałStanuOrzeka = true → wLimicie Z t t' →
      Krok ⟨.zawieszony, t, o⟩ ⟨.opróżniony .złożenieZUrzędu, t', zastępca Z⟩
  /-- Art. 145: orzeczenie bez złożenia z urzędu. -/
  | uniewinnienie {t t' o} : Z.trybunałStanuOrzeka = true → wLimicie Z t t' →
      Krok ⟨.zawieszony, t, o⟩ ⟨.sprawuje, t', .prezydent⟩
  /-- Art. 131 ust. 2 pkt 1. -/
  | śmierć {t} : Krok ⟨.sprawuje, t, .prezydent⟩ ⟨.opróżniony .śmierć, t, zastępca Z⟩
  /-- Art. 131 ust. 2 pkt 2. -/
  | zrzeczenie {t} : Krok ⟨.sprawuje, t, .prezydent⟩ ⟨.opróżniony .zrzeczenie, t, zastępca Z⟩
  /-- Art. 131 ust. 2 pkt 4. -/
  | niezdolność {t} (g) : uchwałaZgromadzeniaArt145 g →
      Krok ⟨.przejściowaNiemożność, t, zastępca Z⟩ ⟨.opróżniony .trwałaNiezdolność, t, zastępca Z⟩

inductive Osiągalny : Stan → Prop where
  | start : Osiągalny ⟨.sprawuje, 0, .prezydent⟩
  | krok {s s'} : Osiągalny s → Krok Z s s' → Osiągalny s'

/-- Złożenie z automatem wyboru: urząd i procedura wyborcza. -/
abbrev PełnyStan := Stan ⊕ WybórPrezydenta.Stan

variable (W : WybórPrezydenta.Założenia)

inductive PełnyKrok : PełnyStan → PełnyStan → Prop where
  | urząd {a b} : Krok Z a b → PełnyKrok (.inl a) (.inl b)
  | wybór {a b} : WybórPrezydenta.Krok W a b → PełnyKrok (.inr a) (.inr b)
  /-- Art. 128 ust. 2. -/
  | opróżnienie {t o p} :
      PełnyKrok (.inl ⟨.opróżniony p, t, o⟩) (.inr ⟨.przedZarządzeniem .opróżnienie, t, W.zapas⟩)
  /-- Art. 129 ust. 3, założenie W5. -/
  | ponowneWybory {t p} :
      PełnyKrok (.inr ⟨.wybórNieważny, t, p⟩) (.inr ⟨.przedZarządzeniem .opróżnienie, t, W.zapas⟩)
  /-- Art. 130. -/
  | objęcie {t w p} :
      PełnyKrok (.inr ⟨.prezydentWybrany w, t, p⟩) (.inl ⟨.sprawuje, t, .prezydent⟩)

end Konstytucja.UrządPrezydenta
