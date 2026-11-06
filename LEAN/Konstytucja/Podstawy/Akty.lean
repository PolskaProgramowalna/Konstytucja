/-! # Akty prawne i ich hierarchia (założenia A1–A2) -/

namespace Konstytucja

inductive RodzajAktu where
  | konstytucja
  | ustawa
  /-- Art. 234: rozporządzenie z mocą ustawy w czasie stanu wojennego. -/
  | rozporządzenieZMocąUstawy
  /-- Art. 91 ust. 2. -/
  | umowaZaZgodą
  | umowaBezZgody
  /-- Art. 91 ust. 3. -/
  | prawoOrganizacjiMiędzynarodowej
  | rozporządzenie
  | aktPrawaMiejscowego
  | uchwałaRadyMinistrów
  | zarządzenie
  deriving DecidableEq, Repr

open RodzajAktu

/-- Art. 87 ust. 1–2 i art. 234 ust. 2 (założenie A2). -/
def RodzajAktu.źródłoPowszechne : RodzajAktu → Bool
  | konstytucja | ustawa | rozporządzenieZMocąUstawy | umowaZaZgodą | umowaBezZgody
  | rozporządzenie | aktPrawaMiejscowego => true
  | prawoOrganizacjiMiędzynarodowej | uchwałaRadyMinistrów | zarządzenie => false

/-- Bezpośrednie pierwszeństwo wynikające z tekstu (założenie A1). -/
inductive MaPierwszeństwo : RodzajAktu → RodzajAktu → Prop where
  /-- Art. 8 ust. 1. -/
  | konstytucjaNajwyższa (a) : a ≠ konstytucja → MaPierwszeństwo konstytucja a
  /-- Art. 91 ust. 2. -/
  | umowaPrzedUstawą : MaPierwszeństwo umowaZaZgodą ustawa
  /-- Art. 91 ust. 3. -/
  | prawoOrganizacjiPrzedUstawą : MaPierwszeństwo prawoOrganizacjiMiędzynarodowej ustawa
  /-- Art. 92 ust. 1. -/
  | ustawaPrzedRozporządzeniem : MaPierwszeństwo ustawa rozporządzenie
  /-- Art. 94. -/
  | ustawaPrzedAktemMiejscowym : MaPierwszeństwo ustawa aktPrawaMiejscowego
  /-- Art. 93 ust. 2. -/
  | ustawaPrzedZarządzeniem : MaPierwszeństwo ustawa zarządzenie
  /-- Art. 93 ust. 3. -/
  | ustawaPrzedUchwałą : MaPierwszeństwo ustawa uchwałaRadyMinistrów
  /-- Art. 188 pkt 3. -/
  | umowaPrzedRozporządzeniem : MaPierwszeństwo umowaBezZgody rozporządzenie

/-- Pierwszeństwo pośrednie: domknięcie przechodnie. -/
inductive Wyższy : RodzajAktu → RodzajAktu → Prop where
  | wprost {a b} : MaPierwszeństwo a b → Wyższy a b
  | przez {a b c} : Wyższy a b → Wyższy b c → Wyższy a c

/-- Ranga pomocnicza do dowodów. Nie jest pojęciem z Konstytucji. -/
def ranga : RodzajAktu → Nat
  | konstytucja => 3
  | umowaZaZgodą | prawoOrganizacjiMiędzynarodowej => 2
  | ustawa | rozporządzenieZMocąUstawy | umowaBezZgody => 1
  | rozporządzenie | aktPrawaMiejscowego | uchwałaRadyMinistrów | zarządzenie => 0

end Konstytucja
