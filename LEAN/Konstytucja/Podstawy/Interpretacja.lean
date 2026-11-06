/-! # Pojęcia ocenne jako parametry (zasada Z3) -/

namespace Konstytucja

/-- Ograniczenie korzystania z wolności lub praw (art. 31 ust. 3). -/
structure Ograniczenie where
  wUstawie : Bool

/-- Parametry, których nie definiujemy, bo ich treść ustala praktyka stosowania prawa. -/
structure Interpretacja where
  /-- Art. 31 ust. 3: „konieczne w demokratycznym państwie”. -/
  konieczne : Ograniczenie → Prop
  /-- Art. 31 ust. 3: „nie mogą naruszać istoty wolności i praw”. -/
  naruszaIstotę : Ograniczenie → Prop
  /-- Założenie C3: czy opóźnienie w dniach mieści się w „niezwłocznie”. -/
  niezwłocznie : Nat → Prop

/-- Art. 31 ust. 3. -/
def dopuszczalne (I : Interpretacja) (o : Ograniczenie) : Prop :=
  o.wUstawie = true ∧ I.konieczne o ∧ ¬ I.naruszaIstotę o

end Konstytucja
