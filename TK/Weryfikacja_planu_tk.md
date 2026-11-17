# Weryfikacja planu testu ciągłości TK

Stan weryfikacji: 16 listopada 2026 r. Przedmiot: [plan_tk.txt](../plan_tk.txt), porównany z [plan.txt](../plan.txt) i tekstem Konstytucji. Sekcje 1–9 dotyczą wersji 1 planu, sekcja 10 opisuje wprowadzenie wersji 2, a sekcja 11 zawiera jej ponowną weryfikację. Numery wierszy w sekcjach 1–9 odnoszą się do wersji 1; w sekcji 11 — do wersji 2.

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
