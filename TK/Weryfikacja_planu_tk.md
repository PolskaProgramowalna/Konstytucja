# Weryfikacja planu testu ciągłości TK

Stan weryfikacji: 16 listopada 2026 r. Przedmiot: [plan_tk.txt](../plan_tk.txt), porównany z [plan.txt](../plan.txt) i tekstem Konstytucji. Sekcje 1–9 dotyczą wersji 1 planu, sekcja 10 opisuje wprowadzenie wersji 2, a sekcja 11 zawiera jej ponowną weryfikację. Sekcja 12 opisuje wprowadzenie wersji 3, a sekcja 13 zawiera jej ponowną weryfikację. Sekcja 14 opisuje wprowadzenie wersji 4, a sekcja 15 zawiera jej ponowną weryfikację. Sekcja 16 opisuje poprawkę 4.1, a sekcja 17 zawiera weryfikację pierwszej implementacji. Numery wierszy w sekcjach 1–9 odnoszą się do wersji 1; w sekcji 11 — do wersji 2; w sekcji 13 — do wersji 3; w sekcji 15 — do wersji 4; w sekcji 17 — do wskazanego tam commita implementacji.

**Ocena wersji 1: plan wymaga poprawek przed przeprowadzeniem testu.** Może służyć do badania konsekwencji jawnych założeń, ale jego pierwotna procedura nie uzasadnia zapowiedzianego wniosku o utracie tożsamości organu ani niezależności wyniku od interpretacji. Jest to ocena projektu badania, bez rozstrzygnięcia o statusie TK, jego sędziów lub orzeczeń.

## 1. Co można zachować

- Rozdzielenie faktów, wzorców konstytucyjnych i założeń interpretacyjnych; brak mocy prawnej wyniku.
- Osobne badanie obsady, kierownictwa, składów orzekających i publikacji. Sam brak publikacji nie dowodzi wadliwości obsady.
- Traktowanie stanowisk Sejmu, treści orzeczeń i opinii jako materiału do analizy, bez przyjmowania ich ocen za wynik testu.
- Rejestr źródeł, analizę wrażliwości i późniejsze sprawdzenie dowodów w Lean. Oznaczenie H1–H9 jako hipotez jest właściwe.

Założenia te są zgodne z kierunkiem `plan.txt`. Szczególnie przydatne są jego zasady Z1–Z5: konstrukcje pomocnicze i odesłania do ustaw trzeba oznaczać, a brak sankcji zachować w wyniku analizy.

## 2. Problemy blokujące wnioskowanie

### B1. Kryterium utraty tożsamości jest dodatkowym założeniem

**Miejsca:** pkt 3.7, Z5, krok 10; wiersze 109–114, 141–144, 216–218.

Konstytucja określa skład i sposób powoływania TK. Plan dodaje trzy różne progi utraty ciągłości: udział pierwszej osoby bez prawidłowego umocowania, udział takich osób wynoszący co najmniej jedną trzecią oraz mniej niż ośmiu prawidłowo umocowanych sędziów. Następnie wprowadza regułę `C1 albo (C2 i C3)` jako kryterium utraty tożsamości całego organu. Żaden z tych progów ani ta alternatywa nie są zapisane w przywołanych przepisach.

Można badać je jako **pomocnicze kryteria klasyfikacji**, ale trzeba oddzielić trzy wnioski: naruszenie określonego wymogu, konsekwencje dla konkretnej czynności oraz konsekwencje dla całego organu. Przejście między nimi wymaga osobnego, jawnego założenia o skutkach naruszenia. Sama wada powołania prezesa również nie rozstrzyga jeszcze o skutkach wszystkich wyznaczonych przez niego składów.

**Poprawka:** wynikiem podstawowym powinny być stwierdzone naruszenia konkretnych wymogów. Ewentualną klasyfikację „utrata tożsamości według kryterium K” podawać osobno, z identyfikatorem założenia K i bez przypisywania tej definicji samej Konstytucji.

### B2. Reguła wolnego miejsca nie rozstrzyga problemu z października 2015 r.

**Miejsca:** pkt 3.2, krok 1, H1; wiersze 76–84, 175–178, 238–240.

Warunek wolnego miejsca w dniu **objęcia urzędu** może być spełniony przez wszystkich pięcioro wybranych 8 października, jeżeli objęcie następuje po zakończeniu odpowiednich kadencji. Wymóg wolnego miejsca już w dniu **wyboru** eliminowałby natomiast wszystkie pięć wyborów, skoro poprzednicy jeszcze urzędowali. Sam ten podział nie wyjaśnia rozróżnienia trzech i dwóch miejsc, które plan chce zbadać.

Potrzebny jest osobny wariant dotyczący wyboru na przyszły wakat i właściwości danej kadencji Sejmu: jaka relacja dat wyboru, zwolnienia miejsca i końca kadencji Sejmu dopuszcza taki wybór? Art. 194 ust. 1 nie podaje tej reguły wprost. Jeśli model wykorzystuje kadencję Sejmu, musi uwzględnić również art. 98. To nadal jest konstytucyjny wzorzec, bez nadawania orzeczeniom roli normy.

Ponadto przypisywanie wyboru do miejsca, którego kadencja wygasa „najbliżej”, jest heurystyką, która może z góry przesądzić wynik. Nie rozwiązuje remisów przy jednoczesnych wakatach ani konkurujących wyborów. Numerowane miejsca są konstrukcją pomocniczą: z liczby 15 nie wynika konstytucyjna numeracja ani jednoznaczna genealogia każdego miejsca.

**Poprawka:** dokumentować zamierzony wakat lub poprzednika każdego wyboru; przy braku rozstrzygających danych zachować alternatywne przyporządkowania. Dodać jawny parametr wyboru wyprzedzającego wakat. Nie rozstrzygać sporu algorytmem „najbliższej daty”.

### B3. Definicja ważnego wyboru koliduje z konwalidacją

**Miejsca:** pkt 3.2–3.3, Z4, kroki 2–3.

Pkt 3.2 uzależnia ważność od braku wcześniejszego ważnego wyboru na to samo miejsce. Z4b dopuszcza późniejszą skuteczność wyboru dokonanego na miejsce zajęte, ale nie opisuje zmiany jego statusu. Predykat `w(p,m,t)` miesza datę czynności z jej skutecznością w późniejszym czasie. Występuje też zależność między ważnością wyboru, datą objęcia urzędu i początkiem kadencji.

**Poprawka:** odróżnić fakt wyboru, dopuszczalność wyboru w chwili czynności, ewentualne oczekiwanie na wakat, skuteczność od określonej daty i wykonywanie funkcji. Określić kolejność zdarzeń oraz skutki konkurujących wyborów. Z4b powinno być regułą przejścia między stanami, a nie wyjątkiem dopisanym poza definicją. Osobno zbadać dopuszczalność każdej kombinacji Z1, Z2 i Z4.

### B4. Dwa warianty nie dowodzą niezależności od interpretacji

**Miejsce:** krok 11; wiersze 219–222.

Nie wykazano, że wskazane warianty są kresami jednego porządku ani że wynik jest monotoniczny względem wszystkich parametrów. Z1b może blokować prawidłowo wybranych sędziów, więc określenie go jako wariantu najbardziej przychylnego zależy od daty i osób. Przesunięcie początku kadencji może zmienić wynik w przeciwnych kierunkach w różnych okresach.

Prosty kontrprzykład logiczny: funkcja `f(a,b) = (a ≠ b)` daje ten sam wynik `false` dla `(0,0)` i `(1,1)`, ale wynik `true` dla dwóch pozostałych kombinacji. Zgodność umownie skrajnych przypadków nie wystarcza.

**Poprawka:** wykonać pełne porównanie wszystkich dopuszczalnych kombinacji albo najpierw udowodnić porządek i monotoniczność. Wymienione warianty dają nominalnie `3 × 2 × 2 × 2 × 3 × 2 = 144` kombinacje, jeszcze przed dodaniem terminów, brakujących parametrów i alternatywnych danych. Jednolity wynik oznaczałby odporność **w obrębie zbadanego zbioru modeli**, a nie niezależność od każdej możliwej interpretacji Konstytucji.

### B5. Milczenie Konstytucji nie usuwa jej odesłań do ustaw

**Miejsca:** zasada w pkt 1, W7–W9, Z1; wiersze 12–18, 45–50, 122–129.

Brak ślubowania sędziego TK w tekście Konstytucji nie dowodzi sam przez się ani jego zakazu, ani braku dopuszczalnych skutków proceduralnych. Art. 197 odsyła organizację i tryb do ustawy, a art. 126 ust. 3 także wskazuje ustawowe zasady wykonywania zadań Prezydenta. Konstytucyjna ocena takiego odesłania nie wymaga uznania ustawy za nadrzędny wzorzec, ale wymaga jawnego przedstawienia, co model przyjmuje w zakresie pozostawionym ustawodawcy.

W szczególności zakaz odmowy przyjęcia ślubowania, nawet jeśli przyjęty w danym wariancie, nie implikuje fikcji jego przyjęcia po 30 dniach. Taka fikcja jest dodatkową regułą modelu, niewyprowadzoną w planie z art. 7 i 126 ust. 3.

**Poprawka:** zachować Konstytucję jako jedyny wzorzec, a szczegóły odesłań modelować jako jawne parametry, zgodnie z Z4 w `plan.txt`. Oddzielić obowiązek działania od skutków bezczynności. Jeśli skutków nie da się ustalić na podstawie dopuszczonych przesłanek, wynik powinien wskazywać nierozstrzygnięcie.

### B6. Binarne werdykty nie obsługują brakujących danych

**Miejsca:** D1–D8, krok 10, format wyników.

Brak odnalezionego ślubowania, protokołu ZO lub składu orzekającego nie jest dowodem, że czynność nie nastąpiła albo że jej warunki były spełnione. Chronologia 42 zdarzeń nie stanowi jeszcze pełnego rejestru wszystkich wyborów, zmian statusu i orzeczeń potrzebnych do takiego testu.

**Poprawka:** co najmniej trzy wyniki dla badanego warunku: spełniony przy wskazanych przesłankach, naruszony, nieustalony. Zapis „nie znaleziono dowodu naruszenia” oddzielić od wyniku pozytywnego. Dla niepewnych faktów obliczać alternatywy lub granice wyniku. Każda ocena powinna wskazywać wzorce W, założenia Z oraz konkretne dane źródłowe, nie sam numer W.

## 3. Korekty tekstu Konstytucji i listy wzorców

| Miejsce planu | Ustalenie i konieczna korekta |
| --- | --- |
| W10 i pkt 3.7 | Zdanie „Konstytucja nie została zmieniona” jest nieprawdziwe: zmieniono art. 55 w 2006 r. i art. 99 w 2009 r. Zamiast tego wskazać, że nie zniesiono konstytucyjnej podstawy TK. Art. 235 reguluje tryb zmiany Konstytucji; sam nie dowodzi faktycznej ciągłości obsady lub zdolności działania. Słowo „przekształcenie” jest zbyt szerokie, bo art. 197 dopuszcza ustawowe regulowanie organizacji i trybu. |
| L3 i W6 | Nie ma pełnego milczenia o większości przy orzekaniu: art. 190 ust. 5 wymaga większości głosów. Rozdzielić tę regułę od nieokreślonego wprost kworum i liczebności składów oraz od reguł ZO. |
| L1 | Art. 130 określa objęcie urzędu po przysiędze, ale nie zawiera wyraźnej sankcji odmowy analogicznej do art. 104 ust. 3. Ogólny przypadek nieobjęcia urzędu po wyborze obejmuje art. 131 ust. 2 pkt 3. Porównanie wymaga tego rozróżnienia. |
| W3 | Art. 195 ust. 3 obejmuje również zakaz przynależności do związku zawodowego. Uzupełnić streszczenie. |
| Pkt 3.2 lit. a | „Indywidualnie” nie daje bez dodatkowego uzasadnienia równoważności „jedna uchwała = jedna osoba”. Trzeba badać możliwość odrębnego wyboru każdego kandydata, a formę dokumentu traktować osobno. |
| Zamknięta lista i wybory | Przy badaniu trybu uchwał uwzględnić art. 120, który określa zasadę większości i kworum oraz dopuszcza inne reguły ustawowe lub uchwałowe. Sam art. 194 nie określa większości wyborczej. Art. 112 jest istotny dla konstytucyjnego odesłania do regulaminu Sejmu. |
| W5 | Jeśli test obejmuje pełny zakres funkcji TK, uwzględnić także art. 191–192 oraz szczególne zadanie z art. 131 ust. 1. Jeśli dotyczy tylko wybranego zakresu, zapisać to wprost. |
| Łańcuchy od 1997 r. | Art. 238 ust. 1 zachowuje kadencje rozpoczęte przed wejściem Konstytucji na dotychczasowych zasadach. Nie można wszystkim takim kadencjom automatycznie przypisać dziewięciu lat. Art. 239 ma znaczenie dla historycznego badania ostateczności orzeczeń w okresie przejściowym; nie należy przenosić jego wyjątku na orzeczenia z lat 2015–2026. |

Podstawa porównania: [rozdział VIII Konstytucji](https://www.prezydent.pl/prawo/konstytucja-rp/viii-sady-i-trybunaly), [rozdział IV](https://www.prezydent.pl/prawo/konstytucja-rp/iv-sejm-i-senat), [rozdział V](https://www.prezydent.pl/prawo/konstytucja-rp/v-prezydent-rp) i [przepisy przejściowe](https://www.prezydent.pl/prawo/konstytucja-rp/xiii-przepisy-przejsciowe-i-koncowe). Zmiany tekstu: [Dz.U. 2006 poz. 1471](https://eli.gov.pl/eli/DU/2006/1471/ogl), [Dz.U. 2009 poz. 946](https://eli.gov.pl/eli/DU/2009/946/ogl). Ustawy zmieniające służą tu ustaleniu wersji tekstu Konstytucji.

## 4. Parametry nie pokrywają jeszcze zadeklarowanych luk

Z3 ma etykietę „L3, L4”, ale reguluje wyłącznie podejmowanie uchwał ZO. Nie zawiera wariantu długości ani końca kadencji prezesa. Nie określa też kworum składów orzekających. L5 pozostaje ograniczeniem kompetencji modelu, a nie rzeczywiście sparametryzowaną kwestią.

Należy ponadto określić: dopuszczalność wyboru na przyszły wakat, skutki udziału osoby wadliwie umocowanej w ZO, skutki wadliwego wyznaczenia składu, skutek naruszenia wymogu orzekania oraz zasady zastępstwa prezesa. Wymóg przedstawienia kandydatów przez ZO i skutek każdej nieprawidłowości w tym postępowaniu to różne zagadnienia.

Terminy T w Z1c i 14 dni w kroku 8 również są parametrami, mimo że nie znajdują się w nominalnej tabeli Z1–Z6. Każdy powinien otrzymać identyfikator, zakres, uzasadnienie i status. Z6 nie zwalnia z art. 195: wyłączenie odpowiedniego stosowania art. 45 nie usuwa wymogów właściwych dla sędziów TK.

## 5. Dane, czas i liczniki

- **Punkt początkowy:** albo pełna rekonstrukcja z uwzględnieniem art. 238, albo udokumentowany stan na 1 października 2015 r. i wcześniejsze dane potrzebne do kontroli ponownego wyboru. Samo uzupełnienie lat 2006–2014 nie gwarantuje kompletności łańcuchów od 1997 r.
- **Czas:** ustalić granicę badania na 16 listopada 2026 r. i konwencję początku/końca kadencji, np. przedziały półotwarte. Dziewięć lat kalendarzowych nie oznacza stałej liczby dni. Dla zdarzeń tego samego dnia zapisać kolejność lub warianty, jeżeli wpływa to na wynik.
- **Status osoby:** rozdzielić wybór, tytuł do urzędu w danym modelu, dopuszczenie do wykonywania funkcji i rzeczywiste uczestnictwo w konkretnym orzeczeniu. Wariant ślubowania nie powinien ukrywać różnicy między spornym tytułem a faktycznym dopuszczeniem do orzekania.
- **N(t):** składy poszczególnych orzeczeń nie wyznaczają automatycznie codziennego zbioru osób faktycznie sprawujących funkcję. Inaczej dzień bez rozpraw może pozornie „przywracać ciągłość”. Osobno utrzymywać rejestr osób dopuszczonych do funkcji i skład każdego orzeczenia.
- **V(t):** rozdzielić wakaty i miejsca z wybranym, ale niedopuszczonym kandydatem. P, N i V nie są z definicji rozłącznym podziałem liczby 15, zwłaszcza przy konkurujących roszczeniach do jednego miejsca.
- **Orzeczenia:** metryka sprawy nie zastępuje danych każdego rozstrzygnięcia, zwłaszcza po zmianie składu. Określić zbiór wyroków i postanowień, deduplikację, kompletność i mianownik rocznych odsetków. Sam fakt wykrycia wady składu oddzielić od założenia o skutku tej wady.
- **Przerwy:** raportować wszystkie przedziały spełnienia i niespełnienia kryterium, nie wyłącznie pierwszą utratę i pierwsze przywrócenie. Brak późniejszych danych nie jest przywróceniem.

## 6. Publikacja i sprawy dotyczące TK

W6 wymaga rozdzielenia ostateczności i mocy powszechnie obowiązującej, obowiązku publikacji, wejścia w życie orzeczenia oraz ewentualnego odroczenia utraty mocy przepisu. Art. 190 ust. 2 wskazuje orzeczenia w sprawach z art. 188; nie należy utożsamiać wszystkich dokumentów w bazie IPO z tym zbiorem. Termin 14 dni może być wskaźnikiem przyjętym do analizy, ale sam nie staje się konstytucyjną definicją „niezwłocznie”.

**H7 wymaga korekty:** 4 marca 2024 r. jest datą ostatniej ustalonej publikacji, a nie automatycznie pierwszym dniem naruszenia obowiązku publikacji. Początek takiego naruszenia trzeba ustalić wobec konkretnego późniejszego orzeczenia i przyjętych przesłanek. Brak publikacji w ELI nie wystarcza też do przypisania przyczyny określonemu organowi; potrzebne są m.in. dane o przekazaniu orzeczenia do ogłoszenia.

Krok 9 powinien rozdzielać osobisty interes członka składu od kontroli przepisów organizujących TK jako instytucję. Sama tematyka ustawy o TK nie dowodzi braku bezstronności wszystkich sędziów. Art. 195 ust. 1 mówi o niezawisłości i podleganiu Konstytucji; bezstronność została wyraźnie wymieniona w art. 45 ust. 1, którego zastosowanie plan uzależnia od Z6. Trzeba uzasadnić regułę konfliktu interesów, zamiast uznawać każdy taki przypadek za automatyczną wadę.

## 7. Kontrola hipotez H1–H9

Hipotezy mogą pozostać kolejką przypadków do zbadania. Nie powinny jednak sterować przyporządkowaniem miejsc ani uzupełniać brakujących reguł.

- H1 wymaga dodatkowego parametru opisanego w B2.
- H2 i H4 należy czytać warunkowo: wcześniejsza ważność wyboru i jego skutek dla następstwa są właśnie przedmiotem badania.
- H5 wymaga określenia pierwszego dnia i konwencji końca kadencji. Data ostatniego dnia urzędowania i pierwszy dzień wakatu nie są tym samym.
- H6 nie jest samoistnym kandydatem na przywrócenie dla całego Z4b: późniejsze uaktywnienie wyboru w połączeniu z początkiem nowej dziewięcioletniej kadencji może zmienić także status następnych wyborów. Potrzebna jest rekonstrukcja wszystkich zależności.
- H7 wymaga korekty z pkt 6. H3, H8 i H9 wymagają danych o konkretnych czynnościach oraz uzupełnienia reguł kierownictwa i ślubowania.

## 8. Co powinna sprawdzać formalizacja

Lean może potwierdzić konsekwencje definicji i danych. Nie potwierdzi automatycznie, że definicja „utraty tożsamości” wiernie odtwarza Konstytucję.

Przed twierdzeniami o datach potrzebne są kontrole:

1. Dopuszczalność i osiągalność każdej analizowanej kombinacji założeń; wykluczenie dowodów opartych na niespełnialnych przesłankach.
2. Poprawność rejestru: jednoznaczne identyfikatory osób i zdarzeń, brak podwójnego zaliczenia tej samej osoby, kontrola konkurujących tytułów i jawne dane nieustalone.
3. Zgodność algorytmu liczącego z predykatami modelu oraz sprawdzone granice czasu.
4. Pierwszeństwo daty wyłącznie w zadeklarowanym oknie: `tStart ≤ t ∧ t < t1`, a nie dla wszystkich wcześniejszych dat, których dane nie obejmują.
5. Wszystkie okresy naruszeń i przywróceń oraz zakres odporności wyniku na parametry i niepewność danych.
6. Wymagana w `plan.txt` kontrola braku `sorryAx` i niedozwolonych globalnych aksjomatów, wraz z identyfikacją wersji danych i modelu.

## 9. Warunki rozpoczęcia testu

Plan można uznać za gotowy po: rozdzieleniu naruszeń od pomocniczej klasyfikacji tożsamości; poprawieniu reguł wyboru i przypisywania wakatów; uzupełnieniu wzorców oraz parametrów; zapewnieniu obsługi niepewnych danych; zdefiniowaniu czasu i liczników; zastąpieniu kroku 11 pełną analizą dopuszczalnych modeli albo udowodnioną metodą ograniczeń.

Weryfikacja obejmowała odczyt obu planów, porównanie z tekstem Konstytucji i jej zmianami oraz kontrolę logiczną definicji i procedury. Liczbę nominalnych kombinacji i kontrprzykład dla kroku 11 sprawdzono rachunkowo. Nie przeprowadzano historycznego testu statusu TK.

W chwili weryfikacji nie istniały: `TK/Wynik_testu_ciaglosci.md`, `LEAN/Konstytucja/TK/Ciaglosc.lean` ani `LEAN/dane/tk_rejestr.csv`. Niniejszy dokument jest recenzją planu; nie zastępuje żadnego z tych artefaktów.

## 10. Stan po poprawkach (16 listopada 2026 r.)

Plan zmieniono do wersji 2 ([plan_tk.txt](../plan_tk.txt), pkt 14 zawiera mapę zmian do punktów tej recenzji). Przepisy przywołane w pkt 3 recenzji sprawdzono w tekście Konstytucji (`Senat/konstytucja_rp_miniatura_w._polska.txt`): art. 98, 112, 120, 130, 131, 190 ust. 5, 195 ust. 3, 238 i 239 oraz zmiany art. 55 i 99. Wszystkie ustalenia recenzji co do brzmienia przepisów się potwierdziły.

| Problem | Rozwiązanie w wersji 2 |
| --- | --- |
| B1 | Wynikiem podstawowym są naruszenia wymogów (pkt 8 planu). „Ciągłość” jest tylko klasyfikacją według jawnych kryteriów K1–K4 (pkt 9), które nie są przypisywane Konstytucji. |
| B2 | Zamierzony wakat pochodzi z dokumentów, z alternatywami danych zamiast heurystyki „najbliższej daty”. Dodano parametr Z7 (wybór na przyszły wakat) i wzorzec W13 (art. 98). |
| B3 | Rozdzielono stany wyboru S1–S6. Z4 stało się regułą przejścia. Dodano zasady dla konkurujących tytułów. |
| B4 | Pełny przegląd dopuszczalnych kombinacji (nominalnie 9216 + 4608 dla wariantu z terminem T) albo dowód monotoniczności. Odporność dotyczy tylko zbadanego zbioru modeli. |
| B5 | Odesłania ustawowe są parametrami (zasada P2). Obowiązek przyjęcia ślubowania (Z1c) oddzielono od fikcji jego przyjęcia (Z1d), oznaczonej jako reguła modelu. |
| B6 | Wynik trójwartościowy SPEŁNIONY / NARUSZONY / NIEUSTALONY oraz pola nieustalone w danych. |

Otwarte pozostają: kompletność danych (D3 ślubowania, D5 protokoły ZO, D6 składy wszystkich orzeczeń, D1 wybory sprzed 2015 r.) oraz recenzja prawnika, która zatwierdzi parametry. Status wszystkich parametrów to „roboczy”. Testu nadal nie przeprowadzono.

## 11. Ponowna weryfikacja wersji 2

**Ocena:** główne kierunki korekt B1–B6 zostały uwzględnione. Oddzielenie kryteriów K od wymogów konstytucyjnych, analiza wszystkich wariantów, rozdzielenie obowiązku przyjęcia ślubowania od fikcji jego przyjęcia i wynik trójwartościowy usuwają zasadnicze problemy wersji 1. Mapa zmian nie oznacza jednak, że model jest już kompletnie określony. Pozostają poniższe korekty i doprecyzowania.

### 11.1. N1 nadal staje się wzorcem naruszenia w H7

W pkt 5 (wiersze 246–248) N1 jest poprawnie nazwany wskaźnikiem analitycznym. Jednak H7 (wiersze 414–417) określa początek **naruszenia W6b** przez nieogłoszenie orzeczenia w terminie N1. Te dwa zapisy są niespójne: wskaźnik ponownie zaczyna pełnić rolę definicji konstytucyjnej niezwłoczności.

Przykład logiczny: publikacja po 20 dniach przekracza N1 = 14, lecz nie przekracza N1 = 30. Bez dodatkowej przesłanki o wykładni „niezwłocznie” ustala to różnicę wskaźników, a nie dwa rozstrzygnięcia o naruszeniu Konstytucji.

**Korekta:** H7 i tabelę E opisać jako czas oczekiwania oraz przekroczenia wskaźników N1. Ocenę W6b uzasadniać odrębnie albo pozostawić nieustaloną. Podstawą jest [art. 190 ust. 2](https://www.prezydent.pl/prawo/konstytucja-rp/viii-sady-i-trybunaly), który nie podaje tych liczbowych terminów.

### 11.2. H1 myli ostatni dzień kadencji z pierwszym dniem wakatu

H1 (wiersz 398) wymienia wakaty powstające 6 listopada, 2 grudnia i 8 grudnia 2015 r. Są to daty podawane jako ostatnie dni kadencji poprzedników. Przy konwencji z pkt 4.5 pierwszymi dniami wakatów są odpowiednio **7 listopada, 3 grudnia i 9 grudnia**.

Odczytane lokalne PDF uchwał z 8 października 2015 r. wskazują w § 2 planowane początki nowych kadencji: [M.P. poz. 1038](https://eli.gov.pl/eli/MP/2015/1038/ogl) — 7 listopada, [poz. 1041](https://eli.gov.pl/eli/MP/2015/1041/ogl) — 3 grudnia, [poz. 1042](https://eli.gov.pl/eli/MP/2015/1042/ogl) — 9 grudnia. Kopie: `dokumenty/TK/ELI/MP/2015/{1038,1041,1042}.pdf`. Zapis uchwały jest tu danymi o zamierzonym terminie, bez przesądzania jej skuteczności. Rozróżnienie listopadowych dat potwierdza również [informacja RPO](https://bip.brpo.gov.pl/pl/content/rpo-krzysztof-slebzak-tk-pozew-przystapienie).

**Korekta:** w H1 rozdzielić ostatnie dni kadencji poprzedników, pierwsze dni wakatów i zamierzone daty początku nowych kadencji. Ta różnica wpływa na Z7a, a więc nie jest wyłącznie redakcyjna.

### 11.3. Z9 ma zbyt szeroki zakres w procedurze

Z9 dotyczy L10, czyli skutku wadliwego **wyznaczenia składu** (wiersze 238–240). Tymczasem krok 7 i tabela D uzależniają od Z9 skutek wszystkich czterech rodzajów wad: tytułu członka składu, wyznaczenia składu, większości oraz konfliktu interesów (wiersze 320–327, 358–359).

Z9b w obecnym brzmieniu może być odczytane tak, że orzeczenie jest wadliwe tylko przy udziale osoby bez tytułu. Wówczas stwierdzony brak wymaganej większości albo osobisty konflikt interesów zostaje pominięty w ocenie skutku, mimo że Z9 miał regulować inne zagadnienie.

**Korekta:** ograniczyć Z9 do skutków wadliwego wyznaczenia składu. Pozostałym naruszeniom przypisać własne jawne reguły skutku albo wynik „skutek nieustalony”. K4 musi wskazywać, jaki rodzaj wad i skutków obejmuje jego odsetek.

### 11.4. Część reguł pozostaje poza tabelą parametrów

- L3 deklaruje lukę dotyczącą kworum i liczebności składów, ale Z1–Z10 jej nie parametryzują, a krok 7 nie sprawdza tych warunków. Trzeba dodać regułę albo jawnie wyłączyć ten zakres z badania.
- P2 zapowiada parametry odesłań, lecz krok 5 nie ma jeszcze skonkretyzowanej reguły większości wyborczej i pozostałych sprawdzanych warunków procedury Sejmu. Sama obecność W12 nie zamyka modelu tej procedury.
- Z3a podaje próg większości, ale nie opisuje osobno kworum; L4 obejmuje też zwołanie ZO, którego Z3 nie reguluje. Z3b wymaga doprecyzowania, czy większość liczy się z obecnych, głosujących czy ważnie oddanych głosów i jak traktuje się osoby o nieustalonym tytule.
- Z4b i Z7 wymagają tabeli współdziałania: czy późniejsza skuteczność może naprawiać również wybór niedopuszczalny z powodu wyboru wyprzedzającego wakat poza kadencję Sejmu? Obecny tekst nie rozstrzyga wyraźnie zakresu tej konwalidacji. Może to być jawny wariant, ale nie powinno zależeć od kolejności instrukcji przyszłego programu.
- Automat powinien określać wygaśnięcie tytułu po E6 i upływie kadencji oraz stan osoby składającej ślubowanie dopiero po końcu kadencji liczonej według Z2a. Same nazwy S1–S6 nie zastępują tych przejść.

Są to wymagania doprecyzowania modelu, nie żądanie przyjęcia określonej wykładni. Jeśli dany warunek pozostaje poza testem, raport musi wskazywać brak jego pokrycia.

### 11.5. Wariant T1 nie jest jeszcze zgodny z regułami czasu

W14 oraz D1 poprawnie uwzględniają kadencje sprzed 17 października 1997 r., ale pkt 4.5 opisuje wszystkie kadencje jako dziewięcioletnie, bez wyjątku. Dla T1 trzeba stosować historyczną długość kadencji tam, gdzie wymaga tego art. 238.

W15 mówi, że wyjątek z art. 239 nie dotyczy okresu badania. Jest to prawidłowe dla T2 od 2015 r.; **T1 rozpoczyna jednak okres badania w 1997 r.** Należy więc albo ograniczyć historyczną rekonstrukcję do obsady i pozostawić ocenę orzeczeń od 2015 r., albo stosować art. 239 do odpowiednich dawnych orzeczeń. [Przepisy przejściowe Konstytucji](https://www.prezydent.pl/prawo/konstytucja-rp/xiii-przepisy-przejsciowe-i-koncowe).

Ponadto `[tStart, 2026-11-16)` kończy się na 15 listopada. Jeżeli dane mają obejmować cały 16 listopada, tEnd powinno wynosić 17 listopada; jeśli stan jest zamknięty na początek 16 listopada, wystarczy tak go nazwać. Jest to rozbieżność z opisem kolejności prac „do 16.11.2026”, nie zarzut wobec samych przedziałów półotwartych.

### 11.6. Rachunek wariantów jest poprawny, zakres wymaga opisania

Sprawdzono rachunkowo:

| Zakres nominalnego przeglądu | Liczba |
| --- | ---: |
| Z1–Z10, jedna wartość T dla Z1d, bez N1 | 9216 |
| Dwie dodatkowe wartości T wyłącznie dla Z1d | 4608 |
| Razem z trzema wartościami T | 13824 |
| Razem z T i trzema wskaźnikami N1 | 41472 |

Są to liczby dla obecnie wymienionych wymiarów, przed filtrowaniem dopuszczalności, alternatywami danych i kolejności zdarzeń. T1/T2 stanowią jeszcze osobne zakresy badania. Po uzupełnieniu reguł z pkt 11.4 iloczyn trzeba przeliczyć; nie należy nazywać 13824 kompletnym zbiorem wszystkich modeli dopuszczonych przez samą zasadę P2.

Dodatkowo K3 potrzebuje wyniku dla F(t) = 0, a K4 — zakresu X oraz sposobu liczenia lat z niepełnym zbiorem orzeczeń i roku 2026 uciętego datą końca badania. Roczny odsetek w K4 opisuje cały badany rok lub jego część, a nie sam stan w konkretnym dniu; trzeba jawnie określić tę zależność czasową.

### 11.7. Co faktycznie blokują brakujące dane i recenzja

Zgodnie z pkt 10 planu recenzja prawnika jest warunkiem przyjęcia parametrów przed właściwym obliczeniem. Ta kolejność pozostaje zachowana. Braki danych blokują pełny, rozstrzygający wynik dla dotkniętych nimi warunków, ale nie oznaczają, że żadnej części procedury nie da się przygotować lub sprawdzić.

Można przygotować format rejestru, kontrolę źródeł i kompletności, generator wariantów oraz model propagacji niepewności. Wyniki częściowe, jeśli zostaną później obliczone zgodnie z przyjętą kolejnością prac, powinny wskazywać dokładnie, które warunki są nieustalone. Nie trzeba wymagać kompletnego D6 do każdego ustalenia dotyczącego samego wyboru sędziego.

W tej ponownej weryfikacji sprawdzono tekst wersji 2, zakres parametrów, rachunek kombinacji, granicę półotwartego okna oraz trzy lokalne PDF uchwał. Nie przeprowadzono historycznego testu. Pliki wynikowe, moduły `Ciaglosc.lean`, `CiagloscDane.lean` i rejestr CSV nadal nie istnieją. Sam plan pozostawiono bez zmian.

## 12. Stan po poprawkach wersji 3 (16 listopada 2026 r.)

Plan zmieniono do wersji 3. Mapa zmian do pkt 11.1–11.7 znajduje się w pkt 15 planu. Najważniejsze rozstrzygnięcia:

- **11.1:** dodano zasadę P9 „wskaźnik ≠ wzorzec”. N1 opisuje tylko czas oczekiwania. Ocena W6b ma odrębną regułę: NARUSZONY przy udokumentowanej odmowie ogłoszenia lub ogłoszeniu ze zmienionym charakterem, a domyślnie NIEUSTALONY.
- **11.2:** H1 rozdziela ostatnie dni kadencji, pierwsze dni wakatów i zamierzone początki kadencji. Te ostatnie sprawdzono w § 2 uchwał M.P. 2015 poz. 1038–1042: 7.11 (poz. 1038–1040), 3.12 i 9.12.2015. Dodano koniec kadencji Sejmu VII (11.11.2015; pierwsze posiedzenie Sejmu VIII 12.11.2015, według API Sejmu).
- **11.3:** Z9 obejmuje wyłącznie wadliwe wyznaczenie składu. Dodano Z13, Z14 i L15 oraz tabelę „wada → skutek” w kroku 7.
- **11.4:** dodano Z11 (kworum i liczebność składów albo NIEPOKRYTY), Z12 (tryb wyboru przez Sejm), rozbicie Z3 na zwołanie, kworum i większość z obsługą tytułów nieustalonych, tabelę współdziałania Z4/Z7 (Z4.R), jawne przejścia T1–T9 ze stanami S7 i S8 oraz zasadę pokrycia P8 z tabelą G.
- **11.5:** wariant T1 obejmuje tylko rekonstrukcję obsady, a ocena orzeczeń biegnie zawsze od 2015-10-01. tEnd = 2026-11-17.
- **11.6:** liczby wariantów liczy skrypt dla każdego modułu z grafem zależności; dla modułu obsady 216, a po utożsamieniach 192. Uzupełniono K3 (F(t) = 0) i K4 (zakres X, granice, rok 2026 niepełny, miara roczna).
- **11.7:** kolejność prac oddziela przygotowanie rejestru, walidatora, generatora wariantów i propagacji niepewności od obliczeń wymagających zatwierdzenia parametrów.

Testu historycznego nadal nie przeprowadzono. Status parametrów: roboczy.

## 13. Ponowna weryfikacja wersji 3

Sprawdzono wersję 3 z bieżącego checkoutu, zapisaną w `HEAD` jako `b2e3928` („trzecia wersja planu tk po poprawkach”). W chwili tej kontroli `plan_tk.txt` nie miał niezapisanych w commicie zmian. Jest to stan repozytorium zastany podczas weryfikacji, niezależny od wcześniejszego opisu prac.

**Domknięte korekty:** H1 rozdziela trzy rodzaje dat, okno obejmuje cały 16 listopada, T1 służy rekonstrukcji obsady, a zakres Z9 został ograniczony. Dodano pokrycie, parametry procedur i rozdzielenie przygotowania narzędzi od właściwego obliczenia. N1 nie wyznacza już automatycznie daty naruszenia. Przedstawiony rachunek **216 → 192** dla M1 jest poprawny jako rachunek wariantów zapisanych w tabeli, z zadeklarowanym utożsamieniem Z4.R przy Z7c.

Pozostają cztery istotne kwestie poprawności przyszłych obliczeń.

### 13.1. Wygaśnięcie tytułu nie oznacza automatycznie zakończenia faktycznej funkcji

**Miejsce:** przejścia T7 i T9, wiersze 202–205.

T7 kończy tytuł wraz z kadencją. T9 następnie kończy S6/S6*/S6? przy samym S7. Jest to niezgodne z rozdzieleniem tytułu i faktycznego wykonywania funkcji: osoba może nadal faktycznie pełnić funkcję po wygaśnięciu tytułu, jeżeli jej dopuszczenie nie zostało cofnięte i istnieją dowody dalszej aktywności.

Przykład modelowy: jedna osoba ma tytuł i jest dopuszczona do funkcji. Kadencja upływa, ale osoba nadal orzeka. Przed upływem: `T=1, F=1, B=0`; po upływie przy dalszym pełnieniu: `T=0, F=1, B=1`. T9 zapisane jako automatyczne zakończenie funkcji może zamiast tego dać `F=0, B=0`, ukrywając właśnie takie naruszenie, które test ma wykrywać.

**Korekta:** przy utracie tytułu przeliczać stan wykonywania funkcji do S6* lub S6?, zamiast automatycznie kończyć faktyczne dopuszczenie. Oddzielić faktyczne zakończenie aktywności, cofnięcie dopuszczenia, śmierć i zdarzenie mające jedynie skutek dla tytułu. Gdy dalsza aktywność nie jest ustalona, zachować niepewność.

### 13.2. Dwa zbiorcze warianty nie wyznaczają granic kworum

**Miejsce:** Z3, wiersze 263–264.

Zdanie „liczymy dwa warianty (wliczone / niewliczone) i podajemy wynik dolny i górny” wymaga doprecyzowania. Jeśli oznacza jednoczesne włączenie albo wyłączenie wszystkich osób o nieustalonym tytule, metoda jest błędna dla Z3.Qb. Kworum zależy zarówno od tytułów osób obecnych, jak i nieobecnych.

Kontrprzykład: siedem osób ma ustalony tytuł, cztery z nich są obecne. Dwie dalsze osoby mają tytuł nieustalony; jedna jest obecna, druga nieobecna. Przy kworum „więcej niż połowa osób z tytułem”:

| Tytuł osoby niepewnej obecnej | Tytuł osoby niepewnej nieobecnej | Obecni z tytułem / wszyscy z tytułem | Kworum |
| --- | --- | --- | --- |
| Nie | Nie | 4/7 | Spełnione |
| Tak | Tak | 5/9 | Spełnione |
| Nie | Tak | 4/8 | Niespełnione |
| Tak | Nie | 5/8 | Spełnione |

Dwa zbiorcze przypadki dają zgodny wynik, ale pomijają wariant naruszenia. Jest to przykład logiczny, nie ustalenie dotyczące rzeczywistego ZO.

**Korekta:** niepewność rozstrzygać dla każdej osoby, badając wszystkie wspólnie dopuszczalne uzupełnienia danych albo stosując udowodnioną metodę wyznaczania granic. Uwzględnić korelacje, np. konkurujące tytuły do tego samego miejsca. Jeśli taki właśnie przegląd był zamierzony, trzeba zapisać to wprost zamiast mówić o dwóch wariantach globalnych.

### 13.3. M3 nie powinien mnożyć dwukrotnie wspólnych parametrów M1

**Miejsce:** graf zależności, wiersze 305–317, i F7.

M2 obejmuje już M1. Zapis `M3 = M1 × M2 × ...`, odczytany jako zapowiedziany iloczyn, dubluje parametry obsady i może łączyć sprzeczne ustawienia tej samej interpretacji. M3 powinien używać **sumy zbiorów identyfikatorów parametrów** zależności M1 i M2, z jedną wartością każdego wspólnego parametru.

Rachunek wyłącznie dla wymiarów wymienionych w tabeli, po wskazanym utożsamieniu M1, ale przed dalszymi filtrami:

- M1: 192;
- M2: `192 × 12 × 6 × 2 = 27648`;
- M3 ze wspólną obsadą: `27648 × 2^6 = 1769472`;
- dosłowne dodatkowe mnożenie przez M1: `192 × 1769472 = 339738624`.

Nie są to liczby końcowe po wszystkich kontrolach. Pokazują różnicę między wspólną interpretacją a niezależnym powieleniem jej pól. Generator musi wykonywać złączenie po wspólnych identyfikatorach, nie niezależne losowanie tych samych parametrów drugi raz.

F7 jest właściwą kontrolą, ale jej dowód powinien poprzedzać użycie ograniczonego przeglądu jako dowodu odporności. Obliczenia przygotowawcze można oznaczyć jako oczekujące na tę kontrolę. Należy też odróżniać logiczną spełnialność wariantu od występowania naruszeń w danym wariancie; samo wykrycie naruszenia nie może być powodem odrzucenia modelu przez F1.

### 13.4. Zdania odrębne nie są pełną tabelą głosowania

**Miejsce:** D6, wiersze 338–341; ocena W6d i wariant Z13b.

Założenie „większość z informacji o zdaniach odrębnych” jest zbyt mocne. Zdanie odrębne może dotyczyć uzasadnienia albo tylko części rozstrzygnięcia. Brak zdania odrębnego nie musi dokumentować indywidualnego głosu za każdą częścią sentencji.

Potwierdza to również treść dokumentu proceduralnego: art. 106 ust. 3 ustawy z 30 listopada 2016 r. mówi o możliwości zgłoszenia zdania odrębnego i obejmuje nim samo uzasadnienie; art. 108 ust. 1 pkt 7 odróżnia wynik głosowania od informacji o zgłoszeniu zdania odrębnego w pkt 9. Źródło: [Dz.U. 2016 poz. 2072](https://eli.gov.pl/api/acts/DU/2016/2072/text.html), odczytane także z lokalnego PDF. Jest to kontrola zawartości i znaczenia danych źródłowych, bez przyjmowania ustawy jako konstytucyjnego wzorca.

**Korekta:** zapisywać wynik głosowania nad odpowiednią częścią rozstrzygnięcia z dokumentu, a zakres zdań odrębnych jako osobne dane. Przy braku wyniku zachować nieustalenie. Z13b może wymagać znajomości indywidualnego głosu osoby bez tytułu; sama liczba zdań odrębnych jej nie zapewnia. Usunięcie kilku osób i ich głosów należy rozpatrywać łącznie, według jawnej reguły, zamiast wykonywać wyłącznie osobne testy każdej osoby.

### 13.5. Ocena publikacji pozostaje częściowo oceną ręczną

Krok 8(b) stosuje już odrębną regułę, ale „czas oczekiwania nie budzi wątpliwości” (wiersze 406–407) nie jest warunkiem obliczalnym na podstawie samych dat. Także określenie, czy adnotacja zmienia „charakter” orzeczenia, wymaga oceny treści. W rejestrze trzeba zatem przewidzieć jawną, uzasadnioną ocenę interpretacyjną z autorem i źródłem albo pozostawić wynik NIEUSTALONY. N1 nie może pośrednio zastąpić tej oceny.

Regułę z kroku 8(b) należy przedstawić prawnikowi jako regułę interpretacyjną do zatwierdzenia, a nie dosłowne brzmienie art. 190 ust. 2. Rozdzielić też zdarzenie odmowy od późniejszej publikacji i wyznaczania przedziału naruszenia. Zapowiedź działania i jego wykonanie są różnymi danymi.

**Zakres wykonanej kontroli:** odczytano plan i mapę zmian; rachunkowo sprawdzono 216 → 192, zależności M2/M3 oraz cztery przypadki kontrprzykładu kworum. Są to kontrole planu i przykłady modelowe. Nie przeprowadzono historycznego testu, nie zatwierdzono parametrów i nie zmieniono `plan_tk.txt`.

## 14. Stan po poprawkach wersji 4 (16 listopada 2026 r.)

Plan zmieniono do wersji 4. Mapa zmian do pkt 13.1–13.5 znajduje się w pkt 16 planu.

- **13.1:** tytuł i faktyczna funkcja są teraz osobnymi składowymi stanu. T7 kończy wyłącznie tytuł, a nowe T9 przenosi osobę do S6* (lub S6?) przy trwającym dopuszczeniu. Nowe T10 kończy funkcję tylko przy cofnięciu dopuszczenia, śmierci (E6a) albo udokumentowanym zaprzestaniu (E10). Kontrprzykład z pkt 13.1 daje teraz `T=0, F=1, B=1`. Dodano kontrolę F9.
- **13.2:** zasada P10 wymaga rozstrzygania niepewności osobno dla każdego elementu, po wszystkich wspólnie dopuszczalnych uzupełnieniach i z uwzględnieniem korelacji. Zbiorcze warianty są dozwolone tylko przy dowodzie monotoniczności (F8). Z3.Qb uwzględnia osoby nieobecne. W kontrprzykładzie z pkt 13.2 wariant 4/8 prowadzi więc do wyniku NIEUSTALONY z listą uzupełnień dających naruszenie.
- **13.3:** graf zależności zapisano jako sumę zbiorów `dep(M)`, z jedną wartością wspólnego parametru. Przyjęto liczby z recenzji: 192, 27 648 i 1 769 472. F7 poprzedza użycie przeglądu modułowego jako dowodu odporności. F1 nie odrzuca wariantów z powodu wykrytych naruszeń.
- **13.4:** D6 rozdziela wynik głosowania (dla każdej części sentencji) od zdań odrębnych (autor, zakres). Krok 7 (c) i Z13b korzystają z wyniku głosowania, a Z13b usuwa wszystkie osoby bez tytułu łącznie. Brzmienie art. 106 ust. 3 i art. 108 ust. 1 pkt 7 i 9 ustawy z 30.11.2016 sprawdzono w tekście z API Sejmu.
- **13.5:** zasada P11 wprowadza ocenę interpretacyjną (autor, uzasadnienie, źródło, status). Krok 8 (b) jest regułą R-PUB do zatwierdzenia przez prawnika. Wynik SPEŁNIONY wymaga zatwierdzonej oceny P11. D7 rozdziela zapowiedź odmowy, odmowę wykonaną, ogłoszenie i adnotację.

Testu historycznego nadal nie przeprowadzono. Status parametrów i reguły R-PUB: roboczy.

## 15. Ponowna weryfikacja wersji 4

Sprawdzono wersję 4 z bieżącego checkoutu: commit `27e3934` („czwarta wersja planu tk po poprawkach”). Na początku tej kontroli plan i recenzja nie miały zmian względem `HEAD`. Poniższa ocena dotyczy tego zastanego stanu repozytorium.

**Ocena:** wszystkie pięć uwag z sekcji 13 zostało uwzględnionych w konstrukcji planu. Można przygotowywać rejestr, walidator i generator wariantów zgodnie z pkt 10. Pozostaje jedno doprecyzowanie T10 przed implementacją granic aktywności; nie wymaga ono wyboru nowej wykładni prawnej.

| Uwaga | Stan w wersji 4 |
| --- | --- |
| 13.1 — tytuł i funkcja | Rozdzielono składowe stanu, skutki E6a/E6b oraz przejścia T7/T9/T10. Przykład z dalszym orzekaniem zachowuje F=1 i zmienia T=1 na T=0 oraz B=0 na B=1. Doprecyzowania wymaga końcówka przedziału niepewności opisana poniżej. |
| 13.2 — niepewność ZO | P10 i Z3 wymagają wszystkich wspólnie dopuszczalnych uzupełnień, osobnych statusów obecnych i nieobecnych oraz korelacji. Usunięto skrót do dwóch zbiorczych przypadków. F8 ma kontrolować poprawność granic. |
| 13.3 — zależności modułów | Użyto sumy zbiorów parametrów i jednej wartości każdego wspólnego pola. Rachunek 216 → 192 → 27 648 → 1 769 472 zgadza się z tabelą, przed dodatkowymi filtrami i alternatywami. F7 poprzedza wykorzystanie przeglądu jako dowodu odporności; F1 nie eliminuje scenariuszy za samo wystąpienie naruszeń. |
| 13.4 — dane o głosowaniu | D6 odróżnia wynik nad każdą częścią sentencji, indywidualne głosy i zakres zdań odrębnych. Z13b usuwa osoby bez tytułu łącznie i zachowuje nieustalenie przy niewystarczających danych. |
| 13.5 — publikacja | P11 przewiduje ocenę interpretacyjną z autorem i uzasadnieniem. R-PUB jest jawnie roboczą regułą do zatwierdzenia; rozdzielono zdarzenia O1–O4, a wskaźnik N1 nie zastępuje oceny. |

### Doprecyzowanie T10: ostatnia czynność nie zamyka niepewnej aktywności

Wiersze 238–241 opisują niepewną funkcję jako przedział „od końca tytułu do ostatniego E5”. Tymczasem E5 oznacza dowód aktywności, a nie jej zakończenia. Sam plan stwierdza to w definicji E10 (wiersze 190–192).

Przykład modelowy: tytuł kończy się w dniu 10, ostatnia udokumentowana czynność następuje w dniu 15, brak E4-, śmierci i E10, a tEnd wynosi 20. Dla dni 16–19 nadal trzeba dopuścić dalszą aktywność w granicy górnej. Ucięcie niepewności na ostatnim E5 usuwałoby te dni bez dowodu zakończenia funkcji. Analogicznie wcześniejsze E5 nie może powodować powstania przedziału z końcem sprzed utraty tytułu.

**Proponowane brzmienie końcówki T10:** „Jeżeli dalsza aktywność nie jest ustalona, niepewność utrzymujemy do udokumentowanego zakończenia funkcji albo tEnd. E5 potwierdza aktywność w zakresie wynikającym z dokumentu; ostatnie E5 nie zamyka niepewności dla późniejszych dni. Granice F(t) i B(t) wyznaczamy po wspólnie dopuszczalnych uzupełnieniach według P10”.

Przy implementacji F9 trzeba precyzyjnie wskazać, czy twierdzenie dotyczy każdej kompletnej historii, czy granic liczników. Wymóg ma zapobiegać usuwaniu faktycznej aktywności przez samo wygaśnięcie tytułu, bez utożsamiania nieustalonej aktywności z potwierdzoną.

**Zakres kontroli:** przeczytano wersję 4, mapę zmian i zapis recenzji. Ponownie sprawdzono rachunek wariantów; przeanalizowano rozdzielenie tytułu i funkcji, korelacje niepewności, dane o głosowaniu oraz status R-PUB. F1–F9 są wymaganiami dla przyszłej implementacji, a nie wykonanymi dowodami. Nie uruchomiono historycznego testu ani nie zatwierdzono parametrów. Plan pozostawiono bez zmian; uzupełniono wyłącznie tę recenzję.

## 16. Stan po poprawce wersji 4.1 (16 listopada 2026 r.)

Doprecyzowanie z sekcji 15 wprowadzono do planu (wersja 4.1, mapa zmian w pkt 17 planu):

- **T10:** przyjęto proponowane brzmienie. Ostatnie E5 nie zamyka niepewności. Aktywność nieustalona trwa do udokumentowanego zakończenia funkcji (E4-, E6a, E10) albo do tEnd. E5 potwierdza aktywność tylko w zakresie dokumentu, a E5 sprzed utraty tytułu nie wyznacza końca przedziału. Do planu dodano przykład kontrolny z tej recenzji (tytuł do dnia 10, ostatnie E5 w dniu 15, tEnd = 20): dni 10–14 i 16–19 mają aktywność nieustaloną, a dzień 15 potwierdzoną.
- **F9:** rozdzielono na F9a, dotyczące każdej kompletnej historii z ustaloną aktywnością, i F9b, dotyczące granic liczników (granica górna nie maleje przez samą utratę tytułu, a granica dolna obejmuje tylko aktywność potwierdzoną).

Pozostałe ustalenia sekcji 15 są aktualne. Można przygotowywać narzędzia (rejestr, walidator, generator wariantów). Obliczenia historyczne wymagają zatwierdzenia parametrów i reguły R-PUB, a F1–F9 to wymagania dla implementacji, a nie wykonane dowody.

## 17. Weryfikacja pierwszej implementacji

Sprawdzono kod i dane z zastanego commita `278d38e` („pierwwsza wersja planu tk”). **Kontrola projektu przechodzi, ale implementacja ma odtworzone błędy, które mogą zmieniać oceny i granice wyników.** Otwarte F3/F7/F8 trafnie sygnalizują brak części dowodów; nie zastępują jednak poprawek przypadków, w których obecny program zwraca już niewłaściwy wynik.

### 17.1. Wyniki wykonanych kontroli

- `./LEAN/sprawdź.sh`: powodzenie. Budowa 48 zadań; kontrola 46 modułów i 5216 deklaracji bez niedozwolonych aksjomatów; walidacja 136 wierszy bez błędów i ostrzeżeń; 25 testów Python zakończonych powodzeniem.
- `python3 -I LEAN/dane/tk_test.py oblicz --wyjście /tmp/tk-review-no-authorization.md`, **bez** `--roboczo`: kod wyjścia 2, brak pliku wynikowego. Potwierdzono również brak zmiany istniejącego wyniku w TK.
- Wykonano małe reprodukcje na danych syntetycznych, bez pełnego przeglądu historycznego. Sesyjny skrypt: `/tmp/tk_implementation_review.py`. Odtwarza osiem rozbieżności: siedem różnych usterek, w tym dwie reprodukcje tego samego błędu pamięci podręcznej ZO. Skrypt pokazuje wynik zaobserwowany i oczekiwany; nie jest częścią istniejących 25 testów.

### 17.2. Usterki wymagające poprawy

#### TKI-1 — P1: pamięć podręczna ZO pomija korelacje między tytułami

**Kod:** [oceny.py](../LEAN/dane/tk/oceny.py), wiersze 145–150; wspólna pamięć w [przebieg.py](../LEAN/dane/tk/przebieg.py), wiersze 122 i 145.

Klucz zawiera marginalne statusy tytułów, ale nie zawiera przyporządkowania osób do miejsc ani alternatywy danych. Dwa stany mogą mieć identyczną listę `TAK/NIEUSTALONY`, lecz inne wspólnie dopuszczalne uzupełnienia. Zwrócenie zapisanej wcześniej oceny pomija te różnice.

Reprodukcja: osiem osób ma pewny tytuł, pięć jest obecnych i popiera kandydata. Dwie dalsze, nieobecne osoby mają tytuł nieustalony. Gdy roszczą tytuł do tego samego miejsca, nie mogą być jednocześnie wliczone: przy Z3.Qb kworum jest spełnione dla wszystkich uzupełnień. Gdy chodzi o dwa różne miejsca, dopuszczalne jest wliczenie obu i uzyskanie 5/10, bez kworum.

Świeże oceny to odpowiednio `SPEŁNIONY` i `NIEUSTALONY`. Po użyciu wspólnej pamięci druga ocena staje się błędnie `SPEŁNIONY`. Odtworzono to także na dwóch stanach wygenerowanych przez `model.oblicz`, z niezmienionymi parametrami i różnymi przyporządkowaniami wakatów.

**Poprawka:** uwzględnić w kluczu pełną istotną korelację, w tym przyporządkowanie do miejsc, albo rozdzielić pamięć między stanami/alternatywami. Dodać porównanie oceny z pamięcią i bez niej dla tych danych.

#### TKI-2 — P1: brak danych o głosach ZO daje naruszenie

**Kod:** [oceny.py](../LEAN/dane/tk/oceny.py), wiersze 165–178 i 200–205.

Gdy lista obecnych i głosujących jest znana, ale brak `glosy`, `_przydziały` zwraca pusty przydział, a `ocena_zo` ustawia `ok = False`. Brak informacji zostaje potraktowany jako brak poparcia.

Reprodukcja: osiem osób z pewnym tytułem jest obecnych i głosuje; dane nie podają liczby głosów. Przy pominięciu wady zwołania i bez wad tytułu wynik to `NARUSZONY`, choć powinien być `NIEUSTALONY`.

**Poprawka:** odróżnić nieznany wynik od udokumentowanych zerowych głosów. Zastosować uzupełnienia zgodne z dostępnymi danymi albo zwrócić nieustalenie. Sprzeczne liczby głosów powinien wykrywać walidator; nie należy zamieniać ich w pusty przydział i ocenę negatywną.

#### TKI-3 — P1: test zajęcia miejsca nie zachowuje bezpiecznej granicy niepewności

**Kod:** [model.py](../LEAN/dane/tk/model.py), wiersze 263–274.

`_zajęty` sprawdza tylko końce niepewnej chwili. Oba mogą leżeć poza przedziałem zajęcia, mimo że jego wnętrze leży wewnątrz zakresu możliwych dat.

Reprodukcja: miejsce jest zajęte w `[2016-01-10, 2016-01-20)`, a badana chwila może przypadać między 1 a 31 stycznia. Program zwraca `NIE`; poprawny wynik to `NIEUSTALONY`, bo niektóre dopuszczalne daty należą do przedziału zajęcia.

**Poprawka:** badać przecięcie całych zakresów oraz warunki pewnego zawierania, z uwzględnieniem korelacji. Ten przypadek obala ogólną deklarację z docstringa, że metoda zawsze daje bezpieczny nadzbiór. Otwarte F8 nie oznacza wyłącznie braku dowodu ścisłości: najpierw trzeba usunąć to zaniżenie niepewności.

#### TKI-4 — P1: brak daty E4 usuwa możliwość późniejszej aktywności

**Kod:** [model.py](../LEAN/dane/tk/model.py), wiersze 464–467.

Gdy `dop is None`, funkcja dodaje wyłącznie potwierdzone dni E5 i kończy obliczenie. Po tych dniach `w_funkcji` zwraca `NIE`, choć brak E4 oznacza nieustaloną datę dopuszczenia, a nie dowód zakończenia funkcji.

Reprodukcja: znany wybór, brak E4 i ślubowania; wyłączone AD2/AD3/AD5; E5 potwierdza aktywność 15 stycznia 2019 r., po zakończeniu tytułu. Dla 16 stycznia program zwraca `NIE`, zamiast `NIEUSTALONY`. Zaniża to górne granice F i B oraz przeczy deklaracji, że wyłączenie założeń danych zachowuje brak wiedzy.

**Poprawka:** E5 musi ustanawiać dowód aktywności w swoim zakresie, a po nim zachować możliwą aktywność do potwierdzonego zakończenia lub końca danych także wtedy, gdy brakuje wcześniejszego E4.

#### TKI-5 — P2: model ignoruje ponowne dopuszczenie E4

**Kod:** [model.py](../LEAN/dane/tk/model.py), wiersze 445–449 i 455–474.

Program wybiera pierwsze E4 i najwcześniejsze zakończenie funkcji. Kolejne E4 nie otwiera nowego przedziału.

Reprodukcja: dopuszczenie 1 stycznia 2010 r., cofnięcie 1 stycznia 2011 r., ponowne udokumentowane dopuszczenie 1 stycznia 2012 r.; tytuł nadal trwa. Dla 2 stycznia 2012 r. otrzymujemy `NIE`, zamiast `TAK`.

**Poprawka:** przetwarzać sekwencję dopuszczeń i zakończeń chronologicznie, tworząc wiele przedziałów, zamiast jednego początku i pierwszego końca.

#### TKI-6 — P2: R-PUB zamienia każdą ocenę inną niż pozytywna w naruszenie

**Kod:** [oceny.py](../LEAN/dane/tk/oceny.py), wiersze 456–478; [rejestr.py](../LEAN/dane/tk/rejestr.py), wiersze 210–213.

Wyrażenie `SPEŁNIONY if ... == "spelniony" else NARUSZONY` nie obsługuje wyniku nieustalonego ani błędnej wartości. Walidator wymaga jedynie niepustego pola `wynik`.

Reprodukcja: zatwierdzona ocena z `wynik=nieustalony`, autorem i uzasadnieniem niewystarczających danych daje `NARUSZONY`.

**Poprawka:** zdefiniować dozwolone wartości i mapować je jawnie, z zachowaniem `NIEUSTALONY`. Nieznana wartość powinna być błędem walidacji, a nie dowodem naruszenia. Zatwierdzenie oceny przez recenzenta nie oznacza automatycznie rozstrzygającego wyniku tej oceny.

#### TKI-7 — P2: Z13b pomija kworum po usunięciu osób bez tytułu

**Kod:** [oceny.py](../LEAN/dane/tk/oceny.py), wiersze 428–440.

`_z13b_jednogłośnie` sprawdza wyłącznie `len(pozostali) >= 1`. Parametr `i` nie jest używany. Zachowanie większości przy jednomyślności nie dowodzi zachowania wymaganego kworum lub liczebności.

Reprodukcja: po usunięciu dwóch osób bez tytułu pozostaje jedna. Przy Z11a, którego reguła nie jest jeszcze wczytana, funkcja zwraca `BEZ WADY`, zamiast `NIEUSTALONY`. Osobna ocena 7(d) może obecnie utrzymać nieustalenie skutku łącznego, ale nie naprawia błędnego szczegółowego wyniku Z13b.

**Poprawka:** oceniać oba warunki Z13b; bez reguły kworum zachować nieustalenie albo wskazać brak pokrycia. Docelowo korzystać z reguły obowiązującej dla badanego rodzaju orzeczenia i daty.

### 17.3. Zakres implementacji i dowodów

- **K4 nie jest jeszcze obliczane:** `przebieg.k4` (wiersze 186–193) bezwarunkowo wpisuje nieustalenie dla każdego roku. To uzasadniony komunikat przy obecnym niekompletnym D6, ale nie implementacja kryterium, która zacznie działać po samym uzupełnieniu danych. Potrzebna jest obsługa kompletności, odsetków, progu X i powiązania z kierownictwem.
- **Lean sprawdza model pomocniczy:** F9a/F9b dotyczą funkcji `krok` w `Ciaglosc.lean`. Nie ma jeszcze dowodu, że Python realizuje tę funkcję; otwarte F3 jest tu zasadnicze. Błędy TKI-4/TKI-5 mogą istnieć mimo poprawnych dowodów pomocniczych w Lean.
- **F2 jest kontrolą ograniczonej reprezentacji:** generator przenosi do Lean numer porządkowy, typ, dzień i osobę. Źródła, niepewność, przyporządkowania wakatów i pozostałe atrybuty nie są częścią tej struktury. Unikalność numerów wierszy nie jest samodzielnym dowodem poprawności wszystkich identyfikatorów źródłowego CSV ani zgodności faktów z dokumentami. Python sprawdza szerszy zakres syntaktyczny, ale brak błędów walidatora nie potwierdza treści każdego źródła.
- **Raport agreguje i traci część śladu oceny:** `raport.wynik` podaje rozkłady wyników, lecz nie zachowuje dla każdej oceny pól W/Z/D, które posiada `Ocena`, ani pełnych przedziałów kierownictwa. Tabele C/D wymagają uzupełnienia przed traktowaniem ich jako docelowego raportu z pkt 8 planu.

### 17.4. Zastany stan plików i granice weryfikacji

W repozytorium był już nieśledzony `TK/Wynik_testu_ciaglosci.md`, oznaczony jako roboczy i opisujący M3 = 7 077 888, oraz `oblicz_tk.sh`. Nie utworzono ani nie nadpisano tych plików podczas recenzji. Ich obecność różni się od opisu, że wynik istnieje wyłącznie w scratchpadzie; nie rozstrzyga to, kiedy i przez kogo został skopiowany.

Nie wykonano pełnego przeglądu historycznego, nie zatwierdzono parametrów i nie wydano werdyktu o TK. Kontrola dotyczy implementacji, spójności modelu i działania testów; nie jest ponownym audytem treści wszystkich 136 rekordów w zewnętrznych dokumentach. Kod i dane pozostawiono bez zmian. Do poprawienia są najpierw odtworzone usterki, następnie ich testy regresyjne i zakres otwartych kontroli formalnych.

## 18. Stan po poprawkach implementacji (16 listopada 2026 r.)

Wszystkie usterki z sekcji 17 poprawiono. Do każdej dodano test regresyjny odtwarzający przypadek z recenzji (`LEAN/dane/tk/test_tk.py`, klasy `Regresja` i `K4`; łącznie 35 testów). Sprawdzono to, uruchamiając nowe testy na kodzie z commitu `278d38e`: wszystkie 10 nowych testów zawodzi (7 niepowodzeń i 3 błędy z powodu braku nowych funkcji), a 25 dotychczasowych przechodzi. Po poprawkach przechodzą wszystkie 35. `LEAN/sprawdź.sh` przechodzi.

| Usterka | Poprawka |
| --- | --- |
| TKI-1 | Klucz pamięci ZO obejmuje status tytułu **i miejsce pomocnicze** każdej osoby, która może mieć tytuł. Test porównuje ocenę świeżą z oceną przy wspólnej pamięci dla obu wariantów z recenzji (`SPEŁNIONY` / `NIEUSTALONY`). |
| TKI-2 | Brak `glosy` albo `glosujacy` daje wynik większości nieustalony, a nie negatywny. Walidator odrzuca więcej głosów niż głosujących i niepoprawne liczby; `_przydziały` zgłasza błąd zamiast pustego przydziału. |
| TKI-3 | Nowa metoda `Przedział.zawiera_chwilę` bada przecięcie całych zakresów oraz pewne zawieranie; `_zajęty` i `_koniec_zajęcia` z niej korzystają. Docstring modelu nie twierdzi już, że metoda daje zawsze bezpieczny nadzbiór (F8 otwarte). |
| TKI-4 | Bez daty E4 pierwsze E5 otwiera możliwą aktywność do udokumentowanego zakończenia albo tEnd. Przed pierwszym E5: nieustalona od dnia wyboru, a dla osób z E3 brak funkcji tylko przy nowym, jawnym i przełączalnym założeniu AD7. |
| TKI-5 | Dopuszczenia (E4) i zakończenia (E4-, E6a, E10) są przetwarzane chronologicznie, każde ponowne dopuszczenie otwiera nowy przedział. |
| TKI-6 | Jawne odwzorowanie `spelniony` / `naruszony` / `nieustalony`; walidator odrzuca inne wartości `wynik` i `status`. Zatwierdzona ocena „nieustalony” daje NIEUSTALONY. |
| TKI-7 | Z13b sprawdza większość i kworum. Bez reguły kworum: NIEUSTALONY (Z11a) albo NIEPOKRYTY (Z11b); utrata większości we wszystkich uzupełnieniach: WADLIWE. |
| K4 (17.3) | K4 jest obliczane jako koniunkcja „kierownictwo NARUSZONE w roku” i „udział WADLIWYCH ≥ X”. Granice udziału wynikają z nowego typu danych `D6_ROK` (liczba orzeczeń w roku); orzeczenia spoza rejestru traktowane są jak nieustalone. Przy obecnych danych (brak `D6_ROK`) wynik jest NIEUSTALONY, ale zmieni się po uzupełnieniu danych bez zmiany kodu. |
| Ślad (17.3) | Tabela C raportu podaje wzorce W, źródła D i wszystkie wyznaczone przedziały kierownictwa. |

Nadal otwarte, zgodnie z 17.3: F3 (dowód zgodności Pythona z funkcją `krok` w Lean), F7, F8 i ograniczony zakres F2 w Lean (numer, typ, dzień, osoba - bez źródeł i atrybutów).

Plik `TK/Wynik_testu_ciaglosci.md` powstał przy uruchomieniu `./oblicz_tk.sh` na prośbę użytkownika (wcześniejsze stwierdzenie, że wynik istnieje tylko w scratchpadzie, dotyczyło stanu sprzed napisania skryptu). Został odtworzony po poprawkach; nadal jest oznaczony jako roboczy i nie jest werdyktem.

## 19. Migracja testu TK z Pythona do Lean

Migrację oparto na aktualnej implementacji z `11ca2dd`, zawierającej poprawki TKI-1–TKI-7, AD7 i obliczanie K4. Silnik Python i `tk_test.py` zostały zastąpione przez czyste funkcje w `LEAN/Konstytucja/TK/Test/` oraz program `LEAN/Skrypty/TK.lean`. Polecenia uruchamia `./tk_test.sh`; `./oblicz_tk.sh` zachowuje dotychczasowe etapy. Python nie jest już zależnością testu TK. Pozostaje w niezależnym `generuj.py`, używanym przez pełną kontrolę danych tekstu Konstytucji.

Zachowano CSV, parametry, założenia danych i ograniczenia modelu. Zapis `CiagloscDane.lean` generuje program Lean; oprócz numerów wierszy sprawdza on oryginalne identyfikatory zdarzeń. Porównanie aktualności obejmuje cały wygenerowany tekst. Logika trójwartościowa używana przez silnik ma także dowody przemienności i podwójnej negacji, sprawdzane przez jądro Lean. Nie oznacza to zamknięcia wszystkich otwartych kontroli.

Kontrole migracji:

- Wzorzec pobrano z bieżącego Pythona przed jego usunięciem. Dla próby technicznej dwóch wariantów M1 × cztery alternatywy porównano 301 agregatów ocen, 47 punktów obwiedni, 36 rozkładów K4 oraz liczby M1=8, M2=1152, M3=73728. Wyniki są identyczne.
- Dla wszystkich 192 wariantów M1 × cztery alternatywy porównano 270 agregatów i 77 punktów obwiedni; wyniki również są identyczne.
- Przeniesiono dotychczasowe testy, w tym regresje TKI-1–TKI-7 i K4. Dodano testy CSV, kalendarza gregoriańskiego, brakujących i błędnych atrybutów oraz AD7. Są łącznie 46 kontroli, wliczając aktualność danych Lean.
- Program uruchomiono przy podmienionych poleceniach `python` i `python3`, które kończą się błędem 99. Walidacja, testy, raport przygotowawczy, generator danych Lean i cały skrypt obliczeń dla jawnej próby technicznej działają bez ich wywołania.
- Pełne złączenie 192 / 27648 / 1769472 wariantów sprawdzono na małym rejestrze syntetycznym, bez danych historycznych. Progi K4 są liczone arytmetyką całkowitą, bez zaokrągleń zmiennoprzecinkowych.

Próby techniczne przyjmują `--limit-m1 N` lub `--moduł M1|M2|M3` i mają w raporcie wyraźne oznaczenie **NIEPEŁNY PRZEGLĄD**. Polecenie `oblicz` nadal wymaga `--roboczo`. Parametry Z, AD i R-PUB pozostają robocze; F1 (osiągalność), F3 (zgodność algorytmu z modelem pomocniczym), F5, F7 i F8 pozostają otwarte. Zgodność wybranych wyników podczas migracji jest testem, a nie dowodem pełnej równoważności.

Nie zmieniono danych `tk_rejestr.csv` ani istniejącego `TK/Wynik_testu_ciaglosci.md`. Nowe raporty prób zapisano do `/tmp`; odświeżono wyłącznie raport przygotowawczy. Nie wydano nowego werdyktu o TK. Odwołania do plików Pythona w sekcjach 17–18 są historyczne; ich kod można odczytać np. przez `git show 11ca2dd:LEAN/dane/tk/oceny.py`.

## 20. Korekty po weryfikacji migracji (17 listopada 2026 r.)

Migracja znajduje się w commicie `00d9a19` („kod python zastąpiony lean 4”);
stan zastany przy tych poprawkach to `d21ed9d`. Stwierdzenie o niezmienionym
wyniku w sekcji 19 nie opisuje całego późniejszego stanu drzewa: już przed
rozpoczęciem tej rundy `TK/Wynik_testu_ciaglosci.md` różnił się od commitu.
Nie ustalono w tej rundzie autora ani czasu jego przeliczenia. Informacja
„nie commitowano” dotyczy czynności danej rundy, a nie braku commitu migracji.

Poprawki do uwag o implementacji:

- **Uwaga przy R-PUB:** przy nieustalonej odmowie O2 i braku zatwierdzonej
  oceny ponownie wypisywane jest „O2 o pewności nieustalonej - wymaga oceny
  P11”. Wynik pozostaje NIEUSTALONY. Testy obejmują wskazówkę dla K 34/15,
  jej zapis w tabeli E oraz odróżnienie od samej zapowiedzi O1 i pewnej O2.
- **Walidator:** testy porównują dokładny zestaw komunikatów, z zachowaniem
  ich krotności i bez zależności od kolejności. Obejmują też osobno błędny
  wakat i status oceny oraz poprawne dane, które nie powinny dawać błędów.
  Rekord z błędną pewnością nie zastępuje już testu odwołania do wakatu:
  parser odrzuca taki rekord przed właściwą walidacją.
- **Kontrola aksjomatów:** obok modułów biblioteki kontrola importuje
  skompilowany `Skrypty.TK`. Pozostałe skrypty nadal są poza jej zakresem.
  Nie oznacza to dowodu poprawności obsługi IO ani zamknięcia F3.
- **Wyjście skryptu:** `oblicz_tk.sh -o /tmp/wynik.md` zapisuje raport
  przygotowawczy do `/tmp/wynik.przygotowanie.md`. Bez `-o` zachowuje
  standardowe ścieżki. `--wyjście` działa tak samo; dla nazwy bez `.md`
  końcówka `.przygotowanie.md` jest dopisywana. Test integracyjny sprawdza
  oba przełączniki, ścieżkę względną, spacje, nowy podkatalog i brak zmian
  obu standardowych raportów. Wchodzi do `LEAN/sprawdź.sh`.

Pełne `LEAN/sprawdź.sh` przeszło: 53 moduły, 6018 deklaracji bez
niedozwolonych aksjomatów, 136 wierszy CSV bez błędów i ostrzeżeń,
52 kontrole Lean (wliczając aktualność wygenerowanych danych) oraz testy
integracyjne obu przełączników wyjścia. Wymagania F1, F3, F5, F7 i F8
oraz status parametrów i założeń pozostają otwarte. W tej rundzie
wykonano próby techniczne z `--limit-m1 1`, a nie ponowne pełne obliczenie
historyczne. Zastane pliki
wyniku, raportu przygotowawczego i CSV są chronione porównaniem SHA-256
przed i po sprawdzeniach; nie są odświeżane w ramach tych poprawek.

## 21. Recenzja planu Etapu I i stan po poprawkach (17 listopada 2026 r.)

Ocena użytkownika dotyczyła wersji 1 `plan_tk_etap_1.txt`, przed
implementacją `Etap1.lean`. Zachowane zalety: Konstytucja jako jedyny
wzorzec, oddzielenie faktów od norm, brak domyślnych AD1–AD7, rozdzielenie
tytułu i aktywności oraz wspólne uzupełnienia niepewności. Dwie zasadnicze
uwagi dotyczyły asymetrii wariantów i tabeli końców kadencji. Pozostałe:
kworum, zależności od osób poza pięcioma miejscami, brak liczności i mapy
zależności oraz przypisanie luk do źródeł.

### 21.1. Sprawdzenie przesłanek recenzji

- Wersja 1 rzeczywiście zawierała tylko brak skutku lub nieustalenie
  skutku uchwał z 25.11 oraz nie miała dodatniej hipotezy pierwszeństwa
  objęcia. Nie uzasadniało to deklaracji odporności poza takim katalogiem.
- [M.P. 2006 poz. 792, § 2](https://eli.gov.pl/api/acts/MP/2006/792/text.pdf)
  wskazuje początek trzech kadencji 6.11.2006, a
  [poz. 842, § 2](https://eli.gov.pl/api/acts/MP/2006/842/text.pdf) początek
  kadencji Cieślaka 2.12.2006. Rachunek `początek + 9 lat` jako wyłączny
  koniec daje wakaty odpowiednio 6.11 i 2.12.2015. Dzień później jest
  odrębnym założeniem, a nie samą zmianą zapisu przedziału.
- Odczytano też [poz. 918](https://eli.gov.pl/api/acts/MP/2006/918/text.pdf):
  uchwała wybiera Bagińską, bez wskazania początku kadencji. Tekstu poz.
  919 nie udało się ponownie pobrać; informacja o braku daty pochodzi
  tutaj z rejestru i recenzji. D2 pozostaje nieustalony, a jego niezależne
  źródła wymagają uzupełnienia. Daty z uchwał następców nie wystarczają.
- Art. 98, 120 i 194–195 porównano z tekstem w `Senat/`. Z art. 120
  wynika warunek obecności, a nie utożsamienie obecnych z głosującymi;
  jego zdanie drugie zachowuje klauzulę wyjątków. Wersja 1 nie opisywała
  dostatecznie sposobu oceny na podstawie niepełnych danych o obecności.
- Rachunek konfiguracji wersji 1 potwierdzono: 144 bez konwencji dat,
  288 przy dwóch konwencjach. Nowy katalog i jego liczność to zmiana
  specyfikacji, nie wynik historyczny ani zatwierdzenie wykładni.

### 21.2. Zmiany w wersji 2

| Uwaga | Zmiana |
| --- | --- |
| 1. Asymetria | Dodano I-UCHWALY-25XI=C (cofnięcie przed objęciem) oraz D (także po objęciu), I-TYTUL=C (udokumentowane przyjęcie wyboru) i I-PIERWSZENSTWO=C (pierwszeństwo objęcia). Każda hipoteza ma argument i kontrargument konstytucyjny. Skutek cofnięcia nie oznacza automatycznie jego zgodności z Konstytucją. Skutek wsteczny pozostaje jawnie poza katalogiem; odporność dotyczy wyłącznie zadeklarowanego zbioru. |
| 2. Daty | Tabela zawiera obie konwencje oraz nieustalenie D2. K8/K9 uwzględniają otwarcie D1 już 2.12 w wariancie A. K12 nie tworzy wakatu D2 z samej daty następcy. |
| 3. Kworum | Liczba głosujących jest dolną granicą obecności: co najmniej 230 dowodzi spełnienia ogólnego kworum; mniej daje nieustalenie bez dodatkowego źródła. Osobny dowód obecności pozwala ocenić warunek bez tego przybliżenia. Pełna ocena W3 pozostaje warunkowa wobec klauzuli wyjątków. |
| 4. Zakres i zależności | Ocena tytułów w składach jest częściowa; osoby spoza pięciu miejsc nie są domyślnie prawowite. J (objęcie) jest odrębne od ślubowania i aktywności. Z góry opisano niedookreślenie daty J dla I-TYTUL=B z I-KADENCJA=B oraz możliwą niepewność aktywności poprzedników do końca okna. |
| 5. Liczność i mapa | Pkt 6.1 podaje 1296 konfiguracji interpretacyjnych przed filtrami: `3*3*2*3*3*4*2`. Zawierają 216 konfiguracji z wymienioną zależnością B/B. Wyliczenie sprawdzono przez enumerację iloczynu. Przyporządkowania i uzupełnienia liczy się osobno; mapa podaje zastosowania w K0–K14 i wymóg zachowania zależności pośrednich. |
| 6. Doprecyzowania | Pkt 4 przypisuje brakujące dokumenty do źródeł. `--limit-m1` ogranicza liczbę wariantów, a nie okno czasowe. Zachowano ostrożność przy publikacji uchwał w K2. |

Przykład `3!*3!*2 = 72` przyporządkowań i `1296*72 = 93312` par jest
wyłącznie warunkowym rachunkiem przy określonych domenach przyporządkowań;
nie jest liczbą ustaloną dla obecnego rejestru. Zależność B/B nie powoduje
odrzucenia konfiguracji ani nie narzuca nieustalenia wszystkim jej ocenom.

Dodano wymagania testów T15–T20 i zmieniono T03, aby obejmowały nowe
hipotezy, obie konwencje dat, kworum, częściowe pokrycie składów oraz
liczność i znane niedookreślenia. K0–K14 są punktami kontrolnymi;
dodatkowe zdarzenia istotne dla objęcia trzeba wstawiać chronologicznie.
Na końcu planu jest mapa zmian do wszystkich sześciu uwag.

### 21.3. Granice tej aktualizacji

Nie zaimplementowano modułu Etapu I, nie uruchomiono jego testu
historycznego ani nie wydano werdyktu o TK. T01–T20 i F01–F12 są
wymaganiami, nie wykonanymi testami lub dowodami. Poszerzenie katalogu
nie dowodzi, że wszystkie warianty są dopuszczalne prawnie lub wyczerpują
wykładnie Konstytucji. W szczególności hipoteza odwołania po objęciu
wymaga oceny w świetle kadencyjności i niezależności; żadnej nie
zatwierdzono przez samo dopisanie do planu. Braki danych i recenzja
interpretacji pozostają do wykonania przed obliczeniem wyników.
