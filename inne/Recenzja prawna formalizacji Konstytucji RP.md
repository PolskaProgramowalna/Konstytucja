# Recenzja prawna formalizacji Konstytucji RP

Nov 6, 2026 · @Pawel

Prosimy o ocenę 89 założeń interpretacyjnych i 74 luk wykrytych przy zapisie procedur, kompetencji i ograniczeń praw z Konstytucji RP w języku Lean 4. Najpilniejsze jest siedem pytań z części „Pytania priorytetowe”, bo od nich zależą najmocniejsze wnioski modelu.

## O co prosimy

Potrzebujemy oceny prawnika konstytucjonalisty, zanim model obejmie kolejne przepisy. Dla każdego założenia prosimy o jedną z trzech odpowiedzi:

- **przyjąć**, jeśli wykładnia jest prawidłowa albo dominująca,
- **zmienić**, wraz z proponowaną wykładnią,
- **sporne**, jeśli obie wykładnie są dopuszczalne i model ma zachować oba warianty.

Dla każdej luki prosimy ocenić, czy to rzeczywista luka, kwestia rozstrzygnięta w orzecznictwie lub ustawie, czy skutek uproszczenia modelu. Mile widziane są wskazania orzeczeń i piśmiennictwa, bo projekt ich nie analizował.

## Czym jest model

Model jest formalnym zapisem jednej roboczej interpretacji tekstu, a nie opinią prawną. Lean sprawdza, czy wniosek logicznie wynika z przyjętych definicji i założeń. Nie sprawdza, czy te założenia są prawidłowe ani jak rozstrzygnąłby Trybunał Konstytucyjny.

- **Tekst:** wzór to tekst ujednolicony Kancelarii Sejmu (Dz.U. 1997 nr 78 poz. 483 ze zm.). Równolegle porównano wydanie Senatu.
- **Zakres:** siedem procedur: tworzenie rządu, ustawodawstwo, zmiana Konstytucji, wotum i dymisja, referendum, wybór Prezydenta i ciągłość urzędu oraz stany nadzwyczajne. Do tego dochodzą kontrasygnata, właściwość Trybunału Konstytucyjnego i ograniczenia wolności i praw.
- **Pokrycie:** na 624 wiersze przepisów 2 są ujęte w pełni, 176 częściowo, a 446 nie jest rozpoczętych.
- **Poza modelem:** ustawy, regulaminy izb, orzecznictwo, doktryna, praktyka ustrojowa i pojęcie terytorium. Rozdziały I–II są ujęte tylko punktowo.

Słowo „blokada” oznacza, że w modelu nie ma dalszego przejścia, bo tekst Konstytucji nie opisuje skutku. Nie oznacza to, że w praktyce albo w innych aktach prawnych brak rozwiązania. Wszystkie warianty mają dziś status roboczy.

Analiza wybranych 10 norm pokazała pięć par nakazu i zakazu, których nie da się spełnić w tej samej chwili: art. 155 ust. 2 z art. 228 ust. 7 i art. 131 ust. 4, art. 128 ust. 2 z art. 228 ust. 7, art. 235 ust. 6 z art. 228 ust. 7 (przy wariancie V5) oraz art. 235 ust. 7 z art. 228 ust. 6. Obowiązek z terminem koliduje z zakazem tylko wtedy, gdy zakaz obejmuje całe okno wykonania, np. 74 dni przy wyborach po opróżnieniu urzędu. Model nie ma reguły pierwszeństwa dla tych par, a obie reguły przyjęte dla próby usuwają wszystkie kolizje systemu. Wybór między nimi należy do wykładni.

## Pytania priorytetowe

Od tych siedmiu odpowiedzi zależą najmocniejsze wnioski modelu, więc prosimy zacząć od nich. W kolumnie po prawej można wpisywać stanowisko.

| Nr | Pytanie | Przepisy | Co pokazuje model | Stanowisko |
| --- | --- | --- | --- | --- |
| 1 | Czy po usunięciu niezgodności Prezydent może ponownie wystąpić do Trybunału? | art. 122 ust. 3–4 (U3, L13) | Jeśli tak, ta sama ustawa może wracać bez ograniczenia liczby razy. Tekst nie gwarantuje wtedy końca procedury. |  |
| 2 | Czy zakaz z art. 228 ust. 7 obejmuje referendum zatwierdzające? | art. 228 ust. 7, art. 125 ust. 4, art. 235 ust. 6 (V5, L18) | Jeśli tak, termin 60 dni koliduje z zakazem, gdy ochrona obejmuje całe okno. Jeśli nie, referendum może się odbyć w okresie ochronnym. |  |
| 3 | Od jakiej liczby głosów liczyć większość 2/3, 3/5 i bezwzględną? | art. 120–122, 154, 235 ust. 4 (G2, L1) | Bez wstrzymujących się większość bezwzględna staje się równa zwykłej, a minimum dla art. 235 ust. 4 spada ze 154 do 1 głosu. |  |
| 4 | Która norma ma pierwszeństwo przy skróceniu kadencji Sejmu? | art. 155 ust. 2, art. 228 ust. 7, art. 131 ust. 4 (P5, L2, L39) | Nakaz skrócenia koliduje z zakazem w okresie ochronnym i, jeśli przechodzi na zastępcę, z zakazem dla osoby wykonującej obowiązki. |  |
| 5 | Jak rozumieć odpowiednie stosowanie art. 158 ust. 2 do ministra? | art. 159 ust. 1 (R2, R3, L26) | Tekst nie ustala progu powtórnego wniosku ani tego, czy limit liczy się dla danego ministra. |  |
| 6 | Czy przy zmianie Konstytucji Prezydentowi przysługuje weto albo wniosek do Trybunału? | art. 235 ust. 7, art. 122, art. 228 ust. 6 (V4, V8, L20, L21) | Model nie ma weta, a wniosek do Trybunału jest wariantem. Zakaz zmiany Konstytucji wiąże z podpisem. |  |
| 7 | Czy klauzule szczególne działają obok art. 31 ust. 3, czy zamiast niego? Czy w stanach nadzwyczajnych obowiązują art. 31 ust. 3 oraz zakazy spoza art. 233 ust. 1? | art. 22, 31, 53, 54, 61, 64, 228, 233 (E1, E3, E7, L61–L63) | Odpowiedź zmienia wynik m.in. dla art. 22 i art. 61 ust. 3. O zakazie cenzury w stanie wojennym decyduje dalsze obowiązywanie zakazu (E7), a nie art. 31 ust. 3. |  |

## Założenia do oceny

Model przyjmuje 89 założeń spoza tekstu Konstytucji albo uproszczeń. Litera oznacza obszar: G głosowanie, C czas, A akty prawne, P tworzenie rządu, U ustawodawstwo, V zmiana Konstytucji, R odpowiedzialność rządu, Q referendum, W Prezydent, S stany nadzwyczajne, K kompetencje, E wolności i prawa, F analiza norm. Kolumna „Ocena” jest do wypełnienia: przyjąć, zmienić albo sporne.

| Id | Założenie | Ocena |
| --- | --- | --- |
| G1 | Obecność na posiedzeniu to udział w głosowaniu. |  |
| G2 | Mianownik „głosów” jest wariantem: wszyscy głosujący albo tylko „za” i „przeciw”. |  |
| G3 | Większość zwykła to więcej głosów „za” niż „przeciw”. |  |
| G4 | „Większością p/q” i „co najmniej p/q” znaczą to samo: udział „za” nie mniejszy niż p/q. |  |
| G5 | „Większością głosów” w art. 155 ust. 1 i art. 160 to większość zwykła. |  |
| G6 | Większość ustawowej liczby to ponad połowa tej liczby, niezależnie od frekwencji. |  |
| C1 | Chwile liczymy w pełnych godzinach, a dobę jako 24 godziny. |  |
| C2 | „W ciągu n dni od dnia d”: dzień d nie wlicza się do n, czynność można wykonać już tego dnia, a ostatni jest dzień d + n. |  |
| C3 | „Niezwłocznie” nie ma wartości liczbowej i jest parametrem. |  |
| C4 | Długość miesięcy i lat zależy od kalendarza, który jest parametrem. |  |
| C5 | Terminu nie przesuwamy, gdy kończy się w dniu wolnym od pracy. |  |
| A1 | Pierwszeństwo aktów opisuje tylko kolizję. Warunki z art. 91 ust. 2–3 nie są modelowane. |  |
| A2 | Art. 87 to zamknięty katalog źródeł powszechnie obowiązujących, poszerzony o art. 234 ust. 2. |  |
| P1 | Głosowanie nad wotum mieści się w 14 dniach z art. 154 ust. 2, choć przepis wyznacza termin Prezesowi Rady Ministrów. |  |
| P2 | Brak uchwały w terminie to nieudzielenie wotum lub niewybranie rządu. |  |
| P3 | 14 dni z art. 155 ust. 1 liczymy od upływu terminu z art. 154 ust. 3. |  |
| P4 | Art. 154 ust. 3 zd. 2 i art. 155 ust. 2 nie mają terminu. Dodatkowy limit jest wariantem. |  |
| P5 | Rozstrzygnięcie kolizji art. 155 ust. 2 i art. 228 ust. 7 jest wariantem. |  |
| U1 | Po orzeczeniu Trybunału termin podpisania biegnie dalej z pozostałymi dniami. |  |
| U2 | Trzy czytania z art. 119 ust. 1 są ujęte jako jeden etap. |  |
| U3 | Po usunięciu niezgodności ustawa wraca do Prezydenta, który może znowu wystąpić do Trybunału. |  |
| U4 | Powrót ustawy do Senatu po usunięciu niezgodności jest wariantem. |  |
| U5 | Wystąpienie do Trybunału trwale wyklucza drogę z art. 122 ust. 5 dla tej ustawy. |  |
| U6 | Terminy bez wartości liczbowej (Sejm, Marszałek, Trybunał) ujmuje wspólny parametr. |  |
| U7 | Limit liczby zwrotów to wariant spoza tekstu. |  |
| U8 | Ustawa budżetowa z art. 224 nie jest modelowana. |  |
| U9 | Bierność Sejmu wobec stanowiska Senatu jest osobnym parametrem. |  |
| V1 | 60 dni Senatu liczymy od uchwalenia ustawy przez Sejm. |  |
| V2 | Senat nie wnosi poprawek. Odmienny tekst to brak uchwalenia, bez drogi powrotnej. |  |
| V3 | Ustawa z rozdziałów I, II lub XII idzie do Prezydenta po 45 dniach albo po referendum. |  |
| V4 | Zakaz zmiany Konstytucji z art. 228 ust. 6 wiążemy z podpisaniem ustawy. |  |
| V5 | Objęcie referendum z art. 235 ust. 6 zakazem z art. 228 ust. 7 jest wariantem. |  |
| V6 | „Większość głosujących” liczymy od ważnych głosów „za” i „przeciw”. |  |
| V7 | Nieważność referendum kończy procedurę niepowodzeniem. |  |
| V8 | Weta nie ma, a wniosek do Trybunału przed podpisem jest wariantem. |  |
| V9 | Dodatkowy limit czasu liczymy od pierwszego dozwolonego dnia. |  |
| R1 | Górna granica głosowania nad wnioskiem to parametr liczony od 7. dnia. |  |
| R2 | Próg powtórnego wniosku przeciw ministrowi jest parametrem. |  |
| R3 | Model śledzi jednego ministra, a limit powtórnego wniosku dotyczy tego ministra. |  |
| R4 | Po wotum nieufności dymisja i powołanie to jedno przejście. |  |
| R5 | Nowy rząd zaczyna bez historii wniosków z art. 158 ust. 2. |  |
| R6 | Dzień przyjęcia dymisji jest dniem początkowym z art. 154 ust. 1. |  |
| R7 | Art. 161 nie jest modelowany, a art. 157 jest tylko podstawą odpowiedzialności. |  |
| Q1 | W referendum rozstrzyga więcej głosów „za” niż „przeciw”, a remis nie rozstrzyga. |  |
| Q2 | Udział obejmuje także oddających głos nieważny. |  |
| Q3 | „Sprawa o szczególnym znaczeniu dla państwa” jest parametrem. |  |
| Q4 | Wynik niewiążący i nieważność kończą procedurę, a terminy są parametrem. |  |
| Q5 | Zakaz z art. 228 ust. 7 dotyczy przeprowadzenia, a nie zarządzenia referendum. |  |
| Q6 | Model obejmuje jedno referendum, bez art. 90 ust. 3 i art. 170. |  |
| W1 | 60 dni i dzień wolny z art. 128 ust. 2 dotyczą obu trybów wyborów. |  |
| W2 | „Ponownie wybrany tylko raz” liczymy łącznie, nie tylko dla kadencji po sobie. |  |
| W3 | Wyniki tur wyborów są parametrem scenariusza. |  |
| W4 | Model nie sprawdza kolejności zapasowych kandydatów, a liczbę zastąpień ogranicza parametr. |  |
| W5 | Po nieważności wyboru obowiązuje tryb opróżnienia urzędu, także gdy pierwsze wybory były zwykłe. |  |
| W6 | Art. 228 ust. 7 zakazuje głosowania, ale model nie wyznacza nowej daty. |  |
| W7 | Prezydent może wrócić po przejściowej niemożności. |  |
| W8 | Zawieszony Prezydent ma zastępcę, bo art. 145 ust. 3 stosuje art. 131 odpowiednio. |  |
| W9 | Model zna tylko dwóch Marszałków i nie opisuje dalszego zastępstwa. |  |
| S1 | Automat liczy godziny, a inne procedury czytają historię stanów w dniach. |  |
| S2 | Przesłanki stanów są ocenne i są parametrami. |  |
| S3 | Prezydent może nie uwzględnić wniosku Rady Ministrów. |  |
| S4 | Zgoda Sejmu na przedłużenie to zwykła większość z art. 120. |  |
| S5 | Stan może skończyć się przed terminem, a stan wojenny decyzją Prezydenta. |  |
| S6 | Okres ochronny obejmuje dzień zakończenia i 90 kolejnych dni. |  |
| S7 | Kadencja trwa do pierwszego dnia poza okresem ochronnym, a odległe stany nie mają wpływu. |  |
| S8 | Art. 233 ust. 2 modeluje tylko motyw ograniczenia, bez oceny z art. 228 ust. 5. |  |
| S9 | Stan wygasa z planowanym końcem, także przed decyzją Sejmu. |  |
| S10 | Rozporządzenia z art. 234 zatwierdza Sejm, gdy może obradować, także po stanie wojennym. |  |
| K1 | Objęcie wniosku o ponowne rozpatrzenie punktem 6 art. 144 ust. 3 jest wariantem. |  |
| K2 | Katalog z art. 144 ust. 3 jest zamknięty. Model nie rozstrzyga pojęcia aktu urzędowego. |  |
| K3 | Automaty procedur nie sprawdzają kontrasygnaty i zakładają akt, który spełnia ten warunek. |  |
| K4 | Skargę z art. 188 pkt 5 wnosi tylko podmiot z art. 79. |  |
| K5 | Rozporządzenie z mocą ustawy z art. 234 badamy tylko względem Konstytucji. |  |
| K6 | Podmioty z art. 191 ust. 1 pkt 3–5 składają wniosek tylko w sprawach aktów normatywnych. |  |
| K7 | Art. 186 ust. 2 obejmuje każdą kontrolę aktu normatywnego względem Konstytucji, ale nie względem umów ani ustaw. |  |
| K8 | Skarga i pytanie prawne obejmują każdy rodzaj aktu poza Konstytucją. Model nie bada, czy konkretny akt jest normatywny. |  |
| E1 | Klauzule szczególne działają obok art. 31 ust. 3 albo zamiast niego: to wariant. |  |
| E2 | Przepisy sformułowane jako zakaz bez wyjątku nie podlegają ograniczeniom. |  |
| E3 | Obowiązywanie art. 31 ust. 3 obok art. 228 i art. 233 jest wariantem. |  |
| E4 | Każda klauzula wymaga formy ustawy, także art. 45 ust. 2. |  |
| E5 | Przypisanie klauzul obejmuje wybrane przepisy. Pozostałe prawa rozdziału II mają tryb ogólny. |  |
| E6 | Lista 16 pojęć ocennych nie jest wyczerpująca, a pojęcia są parametrami bez definicji. |  |
| E7 | Obowiązywanie zakazów i klauzul spoza art. 233 ust. 1 w stanie nadzwyczajnym jest wariantem, niezależnym od E3. |  |
| E8 | Jeden ustęp może zawierać kilka norm. Art. 59 ust. 4 obejmuje też rokowania i strajk jako inne wolności związkowe. |  |
| F1 | Analiza norm obejmuje wybrany system 10 norm, a nie wszystkie obowiązki. |  |
| F2 | Wykonalność statyczna to istnienie wyboru czynności spełniającego działające nakazy i zakazy. Dozwolenie sprzeczne z zakazem nie jest niewykonalne. |  |
| F3 | „Niezwłocznie” z art. 190 ust. 2 i organ ogłaszający są parametrami. |  |
| F4 | Wykonalność terminowa to dzień w oknie obowiązku bez zakazu: 74 dni dla art. 128 ust. 2, 60 dla art. 235 ust. 6 i 21 dla art. 235 ust. 7. |  |
| S11 | „Niezwłocznie” z art. 231 zd. 2 liczymy od otrzymania rozporządzenia przez Sejm. |  |

## Luki i spory

Wykaz obejmuje 74 miejsca, w których tekst milczy, normy kolidują albo model musiał przyjąć wykładnię. Kolumna „Ocena” jest do wypełnienia: luka, rozstrzygnięte gdzie indziej albo uproszczenie modelu.

| Id | Przepisy | Problem | Co robi model | Ocena |
| --- | --- | --- | --- | --- |
| L1 | art. 120–122, 154, 235 | Liczenie wstrzymujących się w mianowniku. | Dwa warianty, minima 138 i 154 głosy albo 1 głos. |  |
| L2 | art. 155 ust. 2, art. 228 ust. 7 | Nakaz skrócenia kadencji a zakaz w okresie ochronnym. | Dowodzi kolizji i niesprzeczności obu rozstrzygnięć. |  |
| L3 | art. 91 ust. 2 | Stosunek umowy bez zgody do ustawy. | Nie porządkuje tych aktów. |  |
| L4 | art. 8 ust. 1, art. 91 ust. 3 | Prawo organizacji międzynarodowej a Konstytucja. | Stawia Konstytucję wyżej, bez orzecznictwa. |  |
| L5 | art. 120, art. 155 ust. 1 | Bardzo niski próg zwykłej większości. | Jeden głos „za” przy kworum, wynik teoretyczny. |  |
| L6 | art. 230, art. 232 | Brak górnej granicy stanu klęski. | Rozwinięte w L46. |  |
| L7 | art. 154 ust. 3 zd. 2 | Brak terminu powołania rządu wybranego przez Sejm. | Rząd może powstać dowolnie późno. |  |
| L8 | art. 154 ust. 3, art. 155 ust. 1 | Brak skutku bezczynności Prezydenta. | Procedura staje. |  |
| L9 | art. 155 ust. 1–2 | Brak terminu skrócenia i początku 14 dni. | Liczy od upływu terminu z art. 154 ust. 3. |  |
| L10 | art. 228 ust. 7, art. 229 | Trwały stan wojenny a skrócenie kadencji. | Przy pierwszeństwie art. 228 skrócenia nie ma. |  |
| L11 | art. 154 ust. 2 | Termin 14 dni nie dotyczy głosowania w Sejmie. | Przyjmuje P1. |  |
| L12 | art. 122 ust. 6, art. 224 ust. 2 | Brak terminu Trybunału przy zwykłej ustawie. | Podpis dowolnie późno, brak orzeczenia blokuje. |  |
| L13 | art. 122 ust. 4 | Brak limitu zwrotów ustawy. | Ustawa może wracać bez ograniczenia przy U3. |  |
| L14 | art. 122 ust. 6 | Wznowienie biegu terminu podpisania. | Zachowuje pozostałe dni (U1). |  |
| L15 | art. 122 ust. 4 | Droga ustawy po usunięciu niezgodności. | Senat jako wariant, brak przejścia bez usunięcia. |  |
| L16 | art. 122 ust. 2 | Brak sankcji za niepodpisanie. | Procedura staje. |  |
| L17 | art. 119, 121, 122 | Brak terminów Sejmu i Marszałka. | Wspólny parametr U6. |  |
| L18 | art. 125 ust. 4, art. 228 ust. 7, art. 235 ust. 6 | Czy zakaz obejmuje referendum zatwierdzające. | Dwa warianty, przy zakazie procedura staje, gdy ochrona obejmuje całe okno 60 dni. |  |
| L19 | art. 125 ust. 3, art. 235 ust. 6 | Brak progu frekwencji przy zatwierdzeniu. | Wystarcza jeden ważny głos „za”. |  |
| L20 | art. 122, art. 235 ust. 7 | Weto i wniosek do Trybunału. | Bez weta, Trybunał jako wariant. |  |
| L21 | art. 228 ust. 6 | Którego etapu dotyczy zakaz zmiany Konstytucji. | Wiąże zakaz z podpisem (V4). |  |
| L22 | art. 235 ust. 2 | Brak uzgadniania przy odmiennym tekście Senatu. | Traktuje to jako brak uchwalenia. |  |
| L23 | art. 125 ust. 4 | Skutek nieważności referendum zatwierdzającego. | Kończy procedurę (V7). |  |
| L24 | art. 235 ust. 3 i 5 | Brak najpóźniejszych terminów w Sejmie. | Procedura może trwać dowolnie długo. |  |
| L25 | art. 158 ust. 1, 159 ust. 2, 162 ust. 3 | Brak terminu i skutku bezczynności Prezydenta. | Procedura staje. |  |
| L26 | art. 159 ust. 1 | Odpowiednie stosowanie art. 158 ust. 2. | Parametry R2 i R3. |  |
| L27 | art. 158 ust. 2 | Brak najpóźniejszego dnia głosowania. | Wniosek może czekać dowolnie długo. |  |
| L28 | art. 158 ust. 2 | Czy limit 3 miesięcy przechodzi na nowy rząd. | Zeruje historię (R5). |  |
| L29 | art. 158 ust. 2 | Niepoddanie wniosku pod głosowanie. | Wniosek czeka. |  |
| L30 | art. 125 ust. 3 | Rozstrzygająca większość i remis. | Przyjmuje Q1. |  |
| L31 | art. 125 ust. 3–4 | Skutek wyniku niewiążącego i nieważnego. | Kończy procedurę. |  |
| L32 | art. 125 ust. 3, art. 235 ust. 6 | Różne warunki referendum. | Ten sam wynik zatwierdza zmianę, choć nie wiązałby przy art. 125. |  |
| L33 | art. 125, art. 228 ust. 7 | Zarządzone referendum w stanie nadzwyczajnym. | Procedura staje, bez odwołania i przesunięcia. |  |
| L34 | art. 125 ust. 5 | Brak terminów w tekście Konstytucji. | Parametr Q4, bez ustawy. |  |
| L35 | art. 127 ust. 6 | Remis w drugiej turze. | Bez zapasu procedura staje. |  |
| L36 | art. 127 ust. 4–5 | Jedyny kandydat bez większości. | Procedura staje. |  |
| L37 | art. 127 ust. 5 | Wycofanie bez kolejnego kandydata. | Brak przejścia po wyczerpaniu zapasu. |  |
| L38 | art. 128 ust. 2, art. 228 ust. 7 | Wybory po opróżnieniu urzędu w okresie ochronnym. | Kolizja tylko przy ochronie na całe okno 74 dni. |  |
| L39 | art. 131 ust. 4, art. 155 ust. 2 | Obowiązek skrócenia kadencji w czasie zastępstwa. | Kolizja, jeśli nakaz przechodzi na zastępcę. |  |
| L40 | art. 131 ust. 3 | Obaj Marszałkowie nie mogą działać. | Brak dalszego zastępstwa (W9). |  |
| L41 | art. 145 ust. 3 | Zawieszenie bez terminu. | Może trwać bez końca. |  |
| L42 | art. 131 ust. 1 | Powrót po przejściowej niemożności. | Przyjmuje W7. |  |
| L43 | art. 128 ust. 2 | Zakres końcówki przepisu. | Przyjmuje W1. |  |
| L44 | art. 231 | Skutek przekroczenia 48 godzin. | Po terminie nie ma przedstawienia, a stan wojenny bez terminu nie wychodzi z tego etapu. |  |
| L45 | art. 229 | Brak limitu i trybu zakończenia stanu wojennego. | Przyjmuje S5. |  |
| L46 | art. 230 ust. 2, art. 232 | Przedłużanie stanu klęski bez limitu. | Stan może obowiązywać dowolnie długo. |  |
| L47 | art. 231, art. 232 | Stan klęski bez przedstawienia i uchylenia przez Sejm. | Kontrola tylko przy przedłużeniu. |  |
| L48 | art. 228 ust. 6–7 | Okres 90 dni po stanie. | Zmianę można podpisać, ale referendum i wyborów nie można przeprowadzić. |  |
| L49 | art. 228 ust. 7 | Znaczenie odpowiedniego przedłużenia kadencji. | Pierwszy dzień poza okresem (S7), bez czasu na wybory. |  |
| L50 | art. 228 ust. 7 zd. 2 | Lokalny zasięg stanu. | Model nie ma terytorium. |  |
| L51 | art. 234 ust. 1 | Skutek niezatwierdzenia rozporządzenia. | Tylko przejście zatwierdzające (S10). |  |
| L52 | art. 230, art. 231 | Upływ terminu stanu przed decyzją Sejmu. | Stan wygasa (S9). |  |
| L53 | art. 122 ust. 5, art. 144 ust. 3 pkt 6 | Czy weto mieści się w odmowie podpisania. | Dwa warianty (K1). |  |
| L54 | art. 144 ust. 1 i 3 | Pojęcie aktu urzędowego. | Nie rozstrzyga, przyjmuje zamknięty katalog (K2). |  |
| L55 | art. 144 ust. 2, art. 229, art. 230 | Skutek odmowy kontrasygnaty. | Automaty jej nie sprawdzają (K3). |  |
| L56 | art. 79, art. 188 pkt 5, art. 191 ust. 1 pkt 1 | Czy podmioty z pkt 1 wnoszą skargę. | Skarga tylko z art. 79 (K4). |  |
| L57 | art. 188, art. 234 | Kontrola rozporządzeń z mocą ustawy. | Tylko względem Konstytucji (K5). |  |
| L58 | art. 79, art. 188 pkt 1–3, art. 193 | Akt miejscowy i prawo organizacji poza pkt 1–3. Akt miejscowy może jednak podlegać skardze lub pytaniu. Recenzent techniczny wskazał omówienie SK 42/02, niezweryfikowane w projekcie. | Rozdziela tryby (K8), nie bada charakteru normatywnego. |  |
| L59 | art. 131, art. 144 ust. 3 | Czy zastępca ma pozostałe prerogatywy. | Jeszcze nie opisuje. |  |
| L60 | art. 31 ust. 3, 39, 40, 52 ust. 4, 53 ust. 6–7, 54 ust. 2 | Zakazy bez wyjątku a ogólna klauzula ograniczeń. | Przyjmuje zakaz (E2). |  |
| L61 | art. 22, 45, 53, 59, 61, 64 | Stosunek klauzul szczególnych do art. 31 ust. 3. | Dwa warianty, różne wyniki (E1). |  |
| L62 | art. 52 ust. 4, art. 54 ust. 2, art. 233 ust. 1 | Zakazy niewymienione w art. 233 ust. 1. | Wynik zależy od dalszego obowiązywania zakazów (E7), a nie od art. 31 ust. 3. |  |
| L63 | art. 31 ust. 3, art. 228 ust. 3, art. 233 | Art. 31 ust. 3 w stanach nadzwyczajnych. | Wariant E3. |  |
| L64 | art. 79, art. 81 | Art. 81 a skarga konstytucyjna. | Nie łączy tych przepisów. |  |
| L65 | art. 45 ust. 2 | Przepis nie wspomina o ustawie. | Wymaga ustawy (E4). |  |
| L66 | m.in. art. 1, 2, 82 | Niepełna lista pojęć ocennych. | 16 parametrów, część bez wpływu na wyniki (E6). |  |
| L67 | art. 37 ust. 2 | Wyjątki dla cudzoziemców. | Nie rozróżnia podmiotów praw. |  |
| L68 | art. 59 ust. 1–4 | Zakres warunku umów, także dla rokowań, strajku i rolników. | Stosuje go do ust. 1–3 (E8). |  |
| L69 | art. 45 ust. 1, art. 53 ust. 1–2, art. 54 ust. 2, art. 64 | Kilka norm w jednym ustępie. | Rozróżnia wybrane czynności, inne ustępy mogą tego wymagać. |  |
| L70 | art. 190 ust. 2–3 | Brak skutku nieogłoszenia orzeczenia. | Procedura staje, orzeczenie nie wchodzi w życie. |  |
| L71 | art. 225, art. 228 ust. 7 | Kolizja dozwolenia z zakazem. | Obu przepisów można przestrzegać, nie skracając kadencji. |  |
| L72 | cała Konstytucja | Ograniczony zakres analizy wykonalności. | Wynik dotyczy 10 norm (F1). |  |
| L73 | art. 128, 131 ust. 4, 155 ust. 2, 235 ust. 6–7 | Sprzeczność chwilowa a możliwość wykonania obowiązku później. | Bada okna terminowe, art. 155 ust. 2 przy skończonej historii da się wykonać później, art. 131 ust. 4 nie jest liczony w czasie. |  |
| L74 | art. 231 zd. 2 | Przekroczenie terminu „niezwłocznie” przez Sejm. | Brak decyzji po terminie, stan z terminem wygasa sam (S11). |  |

## Warianty do decyzji

Model utrzymuje 51 wariantów o statusie roboczym, ale decyzji prawnika wymaga osiemnaście poniższych wyborów. Pozostałe to dodatkowe limity czasu i parametry scenariuszy, które nie rozstrzygają wykładni.

| Założenie | Wybór | Skutek dla modelu | Decyzja |
| --- | --- | --- | --- |
| G2 | Mianownik: wszyscy głosujący albo tylko „za” i „przeciw” | Zmienia minima przy większości bezwzględnej, 2/3 i 3/5. |  |
| P5 | Pierwszeństwo art. 228 ust. 7 albo art. 155 ust. 2 | Decyduje, czy kadencję można skrócić w okresie ochronnym. |  |
| U4 | Powrót do Senatu po usunięciu niezgodności: tak albo nie | Zmienia przebieg każdego zwrotu ustawy. |  |
| V5 | Zakaz obejmuje referendum z art. 235 ust. 6 albo nie | Decyduje, czy procedura zmiany może stanąć w okresie ochronnym. |  |
| V8 | Wniosek do Trybunału przed podpisem: tak albo nie | Decyduje, czy zmiana Konstytucji może czekać na orzeczenie. |  |
| R2 | Próg powtórnego wniosku przeciw ministrowi: 115 posłów albo inny | Zmienia warunek powtórzenia wniosku w ciągu 3 miesięcy. |  |
| W1 | Końcówka art. 128 ust. 2 dotyczy obu trybów albo tylko opróżnienia urzędu | Zmienia terminy wyborów zwykłych. |  |
| W2 | Dwie kadencje łącznie albo tylko następujące po sobie | Zmienia krąg dopuszczalnych kandydatów. |  |
| S9 | Stan wygasa przed decyzją Sejmu albo inny skutek | Zmienia przebieg krótkich stanów nadzwyczajnych. |  |
| K1 | Weto bez kontrasygnaty albo z kontrasygnatą | Decyduje, czy wniosek z art. 122 ust. 5 wymaga podpisu Prezesa Rady Ministrów. |  |
| K4 | Skarga tylko z art. 79 albo szerszy krąg z art. 191 | Zmienia krąg wnoszących skargę. |  |
| K7 | Zakres art. 186 ust. 2: pkt 1 i pkt 3 względem Konstytucji albo węższy | Zmienia uprawnienie Krajowej Rady Sądownictwa. |  |
| K8 | Przedmiot skargi i pytania: każdy akt normatywny albo węższy krąg | Zmienia kontrolę aktów miejscowych. |  |
| E1 | Klauzula i art. 31 ust. 3 łącznie albo klauzula zamiast | Zmienia wyniki dla art. 22, 61 i 64. |  |
| E2 | Zakazy bez wyjątku: tak albo pełne stosowanie art. 31 ust. 3 | Zmienia podział na prawa ograniczalne i nieograniczalne. |  |
| E3 | Art. 31 ust. 3 w stanach nadzwyczajnych: tak albo nie | Zmienia wynik przy celu spoza art. 31 ust. 3. |  |
| E7 | Zakazy spoza art. 233 ust. 1 w stanie nadzwyczajnym: obowiązują albo nie | Decyduje m.in. o art. 52 ust. 4 i art. 54 ust. 2 w tych stanach. |  |
| F2 | Reguła dla siedmiu par kolizji: pierwszeństwo zakazów, nakazów albo osobna dla każdej pary | Decyduje o tym, która norma ustępuje w każdej z par. |  |

## Jak odpowiedzieć

Najlepiej wpisywać oceny bezpośrednio w tabelach, a uzasadnienia i podstawy prawne dodawać jako komentarze. Po recenzji każdy wariant dostanie status przyjęty albo zweryfikowany, a model zostanie poprawiony przed kolejnymi przepisami.
