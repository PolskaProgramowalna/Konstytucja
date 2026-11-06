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
* C1. Chwile mierzymy w pełnych godzinach, a doba kalendarzowa to 24 kolejne godziny.
* C2. Termin „w ciągu n dni od dnia d”: dzień d nie wlicza się do n, czynność można
  wykonać już w dniu d, a ostatnim dniem jest d + n. Terminy w godzinach biegną
  od chwili zdarzenia.
* C3. Pojęcie „niezwłocznie” nie ma wartości liczbowej i jest parametrem interpretacji.
* C4. Miesiące i lata zależą od kalendarza, który jest parametrem (`Kalendarz`).
* C5. Terminu nie przesuwamy, gdy kończy się w dniu wolnym od pracy.
* P1. Art. 154 ust. 2 wyznacza termin Prezesowi Rady Ministrów, a nie Sejmowi.
  Przyjmujemy, że głosowanie nad wotum także mieści się w tych 14 dniach.
* P2. Brak uchwały w terminie traktujemy jak nieudzielenie wotum lub niewybranie rządu.
  Art. 154 ust. 3 liczy kolejny termin od upływu poprzedniego, nie od głosowania.
* P3. Art. 155 ust. 1 nie wskazuje początku terminu. Liczymy go od upływu 14 dni
  z art. 154 ust. 3.
* P4. Art. 154 ust. 3 zd. 2 i art. 155 ust. 2 nie podają terminu działania Prezydenta.
  Pole `limit` to dodatkowe założenie, a `none` odpowiada tekstowi.
* P5. Wariant rozstrzygnięcia kolizji art. 155 ust. 2 i art. 228 ust. 7 jest parametrem.
* U1. Art. 122 ust. 6 mówi tylko o wstrzymaniu biegu terminu. Przyjmujemy, że po orzeczeniu
  Trybunału bieg trwa dalej z dniami, które zostały.
* U2. Czytania z art. 119 ust. 1 nie są modelowane: etap Sejmu to jedno przejście.
* U3. Zwrot z art. 122 ust. 4 uruchamia nowe przedstawienie ustawy Prezydentowi, który
  może znów wystąpić do Trybunału, bo tekst tego nie zakazuje.
* U4. Tekst nie mówi, czy po usunięciu niezgodności ustawa wraca do Senatu. To parametr
  `powrótPrzezSenat`.
* U5. Wystąpienie do Trybunału trwale wyklucza drogę z art. 122 ust. 5 w tej ustawie.
* U6. Terminy bez wartości liczbowej (Sejm, Marszałek, Trybunał) ujmuje wspólny parametr
  `limit`, a `none` odpowiada tekstowi.
* U7. `maksPowrotów` to założenie spoza tekstu, ograniczające liczbę zwrotów,
  a `none` odpowiada tekstowi.
* U8. Ustawa z art. 224 ma inny tryb. Ten automat jej nie obejmuje.
* V1. Art. 235 ust. 2 nie wskazuje początku 60 dni dla Senatu. Liczymy je od uchwalenia
  ustawy przez Sejm.
* V2. „W jednakowym brzmieniu”: Senat nie wnosi poprawek. Tekst odmienny od sejmowego
  to brak uchwalenia, a model nie przewiduje drogi powrotnej do Sejmu.
* V3. Dla ustaw z rozdziałów I, II lub XII przedstawienie Prezydentowi następuje po
  upływie 45 dni albo po referendum (art. 235 ust. 7 w związku z ust. 6).
* V4. Art. 228 ust. 6 zakazuje zmiany Konstytucji w czasie stanu nadzwyczajnego.
  Za chwilę zmiany przyjmujemy podpisanie ustawy.
* V5. Czy zakaz referendum z art. 228 ust. 7 obejmuje referendum z art. 235 ust. 6,
  jest parametrem `zakazDotyczyReferendum`, bo art. 125 ust. 4 wymienia je obok
  referendum ogólnokrajowego.
* V6. „Większość głosujących” liczymy od ważnych głosów „za” i „przeciw”.
* V7. Nieważność referendum (art. 125 ust. 4) kończy procedurę niepowodzeniem.
  Tekst nie opisuje skutku nieważności.
* V8. Art. 235 ust. 7 nie wspomina o wecie ani o Trybunale. Weta nie modelujemy,
  a wniosek do Trybunału jest parametrem `trybunałPrzedPodpisem`.
* V9. Terminy bez wartości liczbowej ujmuje parametr `limit`. Dla czynności z minimalnym
  odstępem liczy się on od pierwszego dozwolonego dnia.
* R1. Art. 158 ust. 2 podaje 7 dni od zgłoszenia, ale nie termin końcowy. Górną granicę
  głosowań ujmuje parametr `limit`, liczony od pierwszego dozwolonego dnia.
* R2. Art. 159 ust. 1 stosuje art. 158 ust. 2 „odpowiednio”. Tekst nie mówi, czy próg
  powtórnego wniosku dla ministra to 115 posłów, więc jest to parametr
  `prógPowtórnyMinistra`.
* R3. Model śledzi jednego ministra. Ograniczenie powtórnego wniosku dotyczy tego ministra.
* R4. Przy wotum nieufności z art. 158 ust. 1 dymisję i powołanie ujmuje jedno przejście.
  Art. 162 ust. 2 pkt 2 nie jest osobnym etapem.
* R5. Nowy rząd zaczyna bez historii wniosków z art. 158 ust. 2. Tekst tego nie rozstrzyga.
* R6. Dzień dymisji przyjętej jest dniem początkowym z art. 154 ust. 1.
* R7. Art. 161 (zmiany w składzie) nie jest modelowany, a art. 157 jest tylko podstawą
  odpowiedzialności, którą realizują procedury z art. 158–159.
* Q1. Art. 125 nie mówi, jaka większość rozstrzyga. Przyjmujemy więcej głosów „za” niż
  „przeciw” wśród ważnych, a remis nie rozstrzyga.
* Q2. Udział w głosowaniu to liczba biorących udział, także z głosem nieważnym.
* Q3. „Sprawa o szczególnym znaczeniu dla państwa” jest pojęciem ocennym i parametrem.
* Q4. Tekst nie podaje terminów ani skutku nieważności, a wynik niewiążący nie ma
  opisanych skutków. Terminy ujmuje parametr `limit`.
* Q5. Zakaz z art. 228 ust. 7 dotyczy przeprowadzenia, a nie zarządzenia referendum.
* Q6. Model obejmuje jedno referendum. Art. 90 ust. 3 i referendum lokalne (art. 170)
  są poza zakresem.
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
