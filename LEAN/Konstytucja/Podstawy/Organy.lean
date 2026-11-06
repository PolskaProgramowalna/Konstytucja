/-! # Organy i ich składy -/

namespace Konstytucja

/-- Ciała głosujące, dla których Konstytucja określa ustawową liczbę członków. -/
inductive Izba where
  | sejm
  | senat
  /-- Art. 114 ust. 1: Sejm i Senat obradujące wspólnie. -/
  | zgromadzenieNarodowe
  deriving DecidableEq, Repr

/-- Art. 96 ust. 1, art. 97 ust. 1, art. 114 ust. 1. -/
def Izba.ustawowaLiczba : Izba → Nat
  | .sejm => 460
  | .senat => 100
  | .zgromadzenieNarodowe => 460 + 100

theorem zgromadzenie_to_sejm_i_senat :
    Izba.zgromadzenieNarodowe.ustawowaLiczba =
      Izba.sejm.ustawowaLiczba + Izba.senat.ustawowaLiczba := rfl

/-- Art. 194 ust. 1. -/
def składTrybunałuKonstytucyjnego : Nat := 15

/-- Art. 199 ust. 1: przewodniczący, 2 zastępców i 16 członków. -/
def składTrybunałuStanu : Nat := 1 + 2 + 16

/-- Art. 187 ust. 1 pkt 1–3. -/
def składKrajowejRadySądownictwa : Nat := 4 + 15 + 4 + 2

theorem skład_trybunału_stanu : składTrybunałuStanu = 19 := rfl
theorem skład_krs : składKrajowejRadySądownictwa = 25 := rfl

end Konstytucja
