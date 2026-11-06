import Konstytucja.Podstawy.Czas
import Konstytucja.Podstawy.Automat

/-! # Art. 190: ogłoszenie orzeczenia Trybunału Konstytucyjnego

Założenie F3 opisuje `Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.OgłoszenieOrzeczenia

/-- Art. 190 ust. 3 zd. 2. -/
inductive RodzajAktu where
  | ustawa
  | innyAkt
  deriving DecidableEq, Repr

/-- Art. 190 ust. 3 zd. 2: najdłuższe odroczenie w miesiącach. -/
def miesiąceOdroczenia : RodzajAktu → Nat
  | .ustawa => 18
  | .innyAkt => 12

structure Założenia where
  /-- Organ właściwy do ogłoszenia działa. -/
  ogłaszającyDziała : Bool
  /-- Założenie F3. -/
  niezwłocznie : Nat
  kalendarz : Kalendarz

inductive Etap where
  /-- Art. 190 ust. 2. -/
  | wydane
  /-- Art. 190 ust. 3 zd. 1: orzeczenie weszło w życie. -/
  | wŻyciu (utrataMocyAktu : Nat)

structure Stan where
  etap : Etap
  dzień : Nat
  akt : RodzajAktu

variable (Z : Założenia)

inductive Krok : Stan → Stan → Prop where
  /-- Art. 190 ust. 2–3: bez odroczenia akt traci moc z dniem ogłoszenia. -/
  | ogłoszenie {t t' a} : Z.ogłaszającyDziała = true → t ≤ t' → t' ≤ t + Z.niezwłocznie →
      Krok ⟨.wydane, t, a⟩ ⟨.wŻyciu t', t', a⟩
  /-- Art. 190 ust. 3 zd. 2: odroczenie utraty mocy. -/
  | ogłoszenieZOdroczeniem {t t' k a} : Z.ogłaszającyDziała = true → t ≤ t' →
      t' ≤ t + Z.niezwłocznie → t' ≤ k →
      k ≤ Z.kalendarz.poMiesiącach t' (miesiąceOdroczenia a) →
      Krok ⟨.wydane, t, a⟩ ⟨.wŻyciu k, t', a⟩

inductive Osiągalny (a : RodzajAktu) : Stan → Prop where
  | start : Osiągalny a ⟨.wydane, 0, a⟩
  | krok {s s'} : Osiągalny a s → Krok Z s s' → Osiągalny a s'

end Konstytucja.OgłoszenieOrzeczenia
