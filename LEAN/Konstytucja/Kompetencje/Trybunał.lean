import Konstytucja.Podstawy.Akty

/-! # Art. 79, art. 186 i art. 188–193: właściwość Trybunału Konstytucyjnego

Założenia K4–K6 opisuje `Konstytucja/Założenia.lean`.
-/

namespace Konstytucja.Trybunał

/-- Art. 79, art. 188, art. 189, a także art. 122 ust. 3, art. 131 ust. 1 i art. 133 ust. 2. -/
inductive Sprawa where
  /-- Art. 188 pkt 1. -/
  | zgodnośćZKonstytucją
  /-- Art. 188 pkt 2. -/
  | zgodnośćZUmową
  /-- Art. 188 pkt 3: wzorcem jest Konstytucja. -/
  | przepisyCentralneZKonstytucją
  /-- Art. 188 pkt 3: wzorcem jest ratyfikowana umowa albo ustawa. -/
  | przepisyCentralneZUmowąLubUstawą
  /-- Art. 188 pkt 4. -/
  | partiaPolityczna
  /-- Art. 188 pkt 5. -/
  | skarga
  /-- Art. 189. -/
  | sporKompetencyjny
  /-- Art. 122 ust. 3. -/
  | ustawaPrzedPodpisaniem
  /-- Art. 133 ust. 2. -/
  | umowaPrzedRatyfikacją
  /-- Art. 131 ust. 1. -/
  | przeszkodaWSprawowaniuUrzędu
  deriving DecidableEq, Repr

/-- Art. 188 pkt 1–3. -/
def Sprawa.aktNormatywny : Sprawa → Bool
  | .zgodnośćZKonstytucją | .zgodnośćZUmową | .przepisyCentralneZKonstytucją
  | .przepisyCentralneZUmowąLubUstawą => true
  | _ => false

inductive Podmiot where
  | prezydent
  | marszałekSejmu
  | marszałekSenatu
  | prezesRadyMinistrów
  | posłowie (liczba : Nat)
  | senatorowie (liczba : Nat)
  | pierwszyPrezesSN
  | prezesNSA
  | prokuratorGeneralny
  | prezesNIK
  | rzecznikPrawObywatelskich
  /-- Art. 191 ust. 1 pkt 2. -/
  | krajowaRadaSądownictwa
  /-- Art. 191 ust. 1 pkt 3: uprawniony jest tylko organ stanowiący. -/
  | organSamorządu (stanowiący : Bool)
  /-- Art. 191 ust. 1 pkt 4: uprawniony jest tylko organ ogólnokrajowy. -/
  | związekZawodowy (ogólnokrajowy : Bool)
  /-- Art. 191 ust. 1 pkt 4: uprawnione są tylko władze ogólnokrajowe. -/
  | organizacjaPracodawców (ogólnokrajowa : Bool)
  /-- Art. 191 ust. 1 pkt 4: uprawnione są tylko władze ogólnokrajowe. -/
  | organizacjaZawodowa (ogólnokrajowa : Bool)
  /-- Art. 191 ust. 1 pkt 5. -/
  | kościół
  /-- Art. 191 ust. 1 pkt 5: inne związki wyznaniowe. -/
  | związekWyznaniowy
  /-- Art. 79 ust. 1: każdy. -/
  | osoba
  /-- Art. 193. -/
  | sąd
  | inny
  deriving DecidableEq, Repr

/-- Okoliczności wniosku potrzebne do oceny uprawnienia. -/
structure Okoliczności where
  /-- Art. 191 ust. 2. -/
  zakresDziałania : Bool
  /-- Art. 186 ust. 2: akt dotyczy niezależności sądów. -/
  niezależnośćSądów : Bool
  /-- Art. 186 ust. 2: akt dotyczy niezawisłości sędziów. -/
  niezawisłośćSędziów : Bool
  /-- Art. 79 ust. 1: naruszone wolności lub prawa. -/
  naruszenie : Bool
  /-- Art. 79 ust. 1: ostateczne orzeczenie. -/
  orzeczenieOstateczne : Bool
  /-- Art. 79 ust. 2. -/
  prawoZArt56 : Bool
  deriving DecidableEq, Repr

/-- Art. 191 ust. 1 pkt 1. -/
def Podmiot.ogólny : Podmiot → Bool
  | .prezydent | .marszałekSejmu | .marszałekSenatu | .prezesRadyMinistrów
  | .pierwszyPrezesSN | .prezesNSA | .prokuratorGeneralny | .prezesNIK
  | .rzecznikPrawObywatelskich => true
  | .posłowie n => decide (n ≥ 50)
  | .senatorowie n => decide (n ≥ 30)
  | _ => false

/-- Art. 191 ust. 1 pkt 3–5. -/
def Podmiot.szczególny : Podmiot → Bool
  | .organSamorządu k | .związekZawodowy k | .organizacjaPracodawców k
  | .organizacjaZawodowa k => k
  | .kościół | .związekWyznaniowy => true
  | _ => false

/-- Art. 192. -/
def Podmiot.wSporze : Podmiot → Bool
  | .prezydent | .marszałekSejmu | .marszałekSenatu | .prezesRadyMinistrów
  | .pierwszyPrezesSN | .prezesNSA | .prezesNIK => true
  | _ => false

/-- Czy podmiot może wystąpić do Trybunału w danej sprawie. -/
def możeWystąpić (p : Podmiot) (s : Sprawa) (o : Okoliczności) : Bool :=
  match s with
  | .sporKompetencyjny => p.wSporze
  | .ustawaPrzedPodpisaniem | .umowaPrzedRatyfikacją => p == .prezydent
  | .przeszkodaWSprawowaniuUrzędu => p == .marszałekSejmu
  | .skarga => p == .osoba && o.naruszenie && o.orzeczenieOstateczne && !o.prawoZArt56
  | .partiaPolityczna => p.ogólny
  | .zgodnośćZUmową | .przepisyCentralneZUmowąLubUstawą =>
    p.ogólny || (p.szczególny && o.zakresDziałania)
  | .zgodnośćZKonstytucją | .przepisyCentralneZKonstytucją =>
    p.ogólny || (p == .krajowaRadaSądownictwa && (o.niezależnośćSądów || o.niezawisłośćSędziów)) ||
      (p.szczególny && o.zakresDziałania)

/-- Art. 193: pytanie prawne. -/
def pytanieDopuszczalne (p : Podmiot) (odOdpowiedziZależy : Bool) : Bool :=
  p == .sąd && odOdpowiedziZależy

open RodzajAktu

/-- Czy akt `a` można badać względem wzorca w trybach art. 188 pkt 1–3 (założenie K5).
Funkcja nie obejmuje skargi z art. 79 ani pytania prawnego z art. 193. -/
def kontrolowalny : RodzajAktu → RodzajAktu → Bool
  | ustawa, konstytucja | umowaZaZgodą, konstytucja | umowaBezZgody, konstytucja => true
  | ustawa, umowaZaZgodą => true
  | rozporządzenieZMocąUstawy, konstytucja => true
  | rozporządzenie, konstytucja | rozporządzenie, ustawa
  | rozporządzenie, umowaZaZgodą | rozporządzenie, umowaBezZgody => true
  | zarządzenie, konstytucja | zarządzenie, ustawa
  | zarządzenie, umowaZaZgodą | zarządzenie, umowaBezZgody => true
  | uchwałaRadyMinistrów, konstytucja | uchwałaRadyMinistrów, ustawa
  | uchwałaRadyMinistrów, umowaZaZgodą | uchwałaRadyMinistrów, umowaBezZgody => true
  | _, _ => false

/-- Art. 79 ust. 1: akt może być przedmiotem skargi, jeśli jest ustawą lub innym aktem
normatywnym (założenie K8). Wzorcem jest Konstytucja. Funkcja zna tylko rodzaj aktu i nie
przesądza, czy dany akt ma charakter normatywny. -/
def przedmiotSkargi : RodzajAktu → Bool
  | konstytucja => false
  | _ => true

/-- Art. 193: wzorce pytania prawnego. -/
def wzorzecPytania : RodzajAktu → Bool
  | konstytucja | ustawa | umowaZaZgodą | umowaBezZgody => true
  | _ => false

end Konstytucja.Trybunał
