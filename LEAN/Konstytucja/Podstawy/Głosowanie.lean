import Konstytucja.Założenia
import Konstytucja.Podstawy.Organy

/-! # Głosowanie: kworum i rodzaje większości (założenia G1–G6) -/

namespace Konstytucja

/-- Wynik głosowania. Liczba głosów nie przekracza ustawowej liczby członków. -/
structure Głosowanie (i : Izba) where
  za : Nat
  przeciw : Nat
  wstrzymani : Nat
  wLimicie : za + przeciw + wstrzymani ≤ i.ustawowaLiczba

variable {i : Izba}

/-- G1: obecni to głosujący. -/
def Głosowanie.głosujący (g : Głosowanie i) : Nat := g.za + g.przeciw + g.wstrzymani

/-- G2. -/
def Głosowanie.mianownik (m : Mianownik) (g : Głosowanie i) : Nat :=
  match m with
  | .wszyscyGłosujący => g.głosujący
  | .zaIPrzeciw => g.za + g.przeciw

/-- „W obecności co najmniej połowy ustawowej liczby” (np. art. 120). -/
def kworum (g : Głosowanie i) : Prop := 2 * g.głosujący ≥ i.ustawowaLiczba

/-- G3. -/
def większośćZwykła (g : Głosowanie i) : Prop := g.za > g.przeciw

/-- Większość bezwzględna: ponad połowa głosów według mianownika. -/
def większośćBezwzględna (m : Mianownik) (g : Głosowanie i) : Prop :=
  2 * g.za > g.mianownik m

/-- G4: większość p/q głosów. -/
def większośćUłamkowa (m : Mianownik) (p q : Nat) (g : Głosowanie i) : Prop :=
  0 < g.mianownik m ∧ p * g.mianownik m ≤ q * g.za

/-- G6: większość ustawowej liczby członków. -/
def większośćUstawowa (g : Głosowanie i) : Prop := 2 * g.za > i.ustawowaLiczba

/-- Co najmniej p/q ustawowej liczby członków (np. art. 98 ust. 3, art. 156 ust. 2). -/
def ułamekUstawowejLiczby (p q : Nat) (g : Głosowanie i) : Prop :=
  p * i.ustawowaLiczba ≤ q * g.za

/-- `n` jest najmniejszą liczbą głosów „za”, przy której spełniony jest warunek `P`. -/
def JestMinimum (P : Głosowanie i → Prop) (n : Nat) : Prop :=
  (∃ g, P g ∧ g.za = n) ∧ ∀ g, P g → n ≤ g.za

end Konstytucja
