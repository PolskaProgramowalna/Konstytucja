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

/-- Rodzaj orzeczenia. Tylko niezgodność prowadzi do utraty mocy aktu. -/
inductive Wynik where
  | niezgodność
  | zgodność
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
  /-- Art. 190 ust. 3 zd. 1: orzeczenie weszło w życie. `none` oznacza brak utraty mocy. -/
  | wŻyciu (utrataMocyAktu : Option Nat)

structure Stan where
  etap : Etap
  dzień : Nat
  akt : RodzajAktu
  wynik : Wynik

variable (Z : Założenia)

inductive Krok : Stan → Stan → Prop where
  /-- Art. 190 ust. 2–3: bez odroczenia akt traci moc z dniem ogłoszenia. -/
  | ogłoszenie {t t' a} : Z.ogłaszającyDziała = true → t ≤ t' → t' ≤ t + Z.niezwłocznie →
      Krok ⟨.wydane, t, a, .niezgodność⟩ ⟨.wŻyciu (some t'), t', a, .niezgodność⟩
  /-- Art. 190 ust. 3 zd. 2: odroczenie utraty mocy. -/
  | ogłoszenieZOdroczeniem {t t' k a} : Z.ogłaszającyDziała = true → t ≤ t' →
      t' ≤ t + Z.niezwłocznie → t' ≤ k →
      k ≤ Z.kalendarz.poMiesiącach t' (miesiąceOdroczenia a) →
      Krok ⟨.wydane, t, a, .niezgodność⟩ ⟨.wŻyciu (some k), t', a, .niezgodność⟩
  /-- Orzeczenie o zgodności nie pozbawia aktu mocy. -/
  | ogłoszenieZgodności {t t' a} : Z.ogłaszającyDziała = true → t ≤ t' →
      t' ≤ t + Z.niezwłocznie → Krok ⟨.wydane, t, a, .zgodność⟩ ⟨.wŻyciu none, t', a, .zgodność⟩

inductive Osiągalny (a : RodzajAktu) (w : Wynik) : Stan → Prop where
  | start : Osiągalny a w ⟨.wydane, 0, a, w⟩
  | krok {s s'} : Osiągalny a w s → Krok Z s s' → Osiągalny a w s'

end Konstytucja.OgłoszenieOrzeczenia
