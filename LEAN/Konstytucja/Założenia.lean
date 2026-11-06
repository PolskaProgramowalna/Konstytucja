/-!
# Założenia spoza tekstu Konstytucji

Wykaz wymagany przez zasadę Z2 z `plan.txt`. Konstytucja tych spraw nie rozstrzyga
wprost, więc każda decyzja jest wykładnią modelu, a nie treścią przepisu.

* G1. Obecność na posiedzeniu utożsamiamy z udziałem w głosowaniu.
* G2. Mianownik „głosów” jest parametrem `Mianownik`. Twierdzenia podają wynik
  dla każdego wariantu albo jawnie wskazują wariant.
* G3. Większość zwykła to więcej głosów „za” niż „przeciw”.
* G4. „Większością p/q głosów” i „większością co najmniej p/q głosów” znaczą to samo:
  udział głosów „za” nie mniejszy niż p/q, przy niepustym mianowniku.
* G5. „Większością głosów” bez przymiotnika (art. 155 ust. 1, art. 160)
  to większość zwykła.
* G6. Większość ustawowej liczby to więcej niż połowa tej liczby, niezależnie
  od frekwencji (art. 158 ust. 1, art. 159 ust. 2).
* C1. Czas mierzymy w dniach kalendarzowych numerowanych liczbami naturalnymi.
* C2. Termin „w ciągu n dni od dnia d” obejmuje dni od d do d + n włącznie.
* C3. Pojęcie „niezwłocznie” nie ma wartości liczbowej i jest parametrem interpretacji.
* C4. Miesiące i lata zależą od kalendarza, który jest parametrem (`Kalendarz`).
* A1. Pierwszeństwo aktów opisuje tylko sytuację kolizji. Warunki z art. 91 ust. 2–3
  nie są jeszcze modelowane.
* A2. Art. 87 traktujemy jako zamknięty katalog źródeł powszechnie obowiązujących,
  poszerzony o art. 234 ust. 2.
-/

namespace Konstytucja

/-- Założenie G2: od jakiej liczby głosów liczyć większość. -/
inductive Mianownik where
  /-- „za” + „przeciw” + wstrzymujący się. -/
  | wszyscyGłosujący
  /-- Tylko „za” + „przeciw”. -/
  | zaIPrzeciw
  deriving DecidableEq, Repr

end Konstytucja
