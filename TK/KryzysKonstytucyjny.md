# Kryzys konstytucyjny wokół Trybunału Konstytucyjnego — krok po kroku (2015–2026)

Stan na 16 listopada 2026.

## Zasady doboru źródeł

Opis opiera się **wyłącznie** na:

| Znacznik | Źródło | Co z niego wzięto |
|---|---|---|
| **[Sejm-ELI]** | Sejm RP — baza aktów prawnych (Dziennik Ustaw, Monitor Polski) przez API `api.sejm.gov.pl/eli` | daty uchwalenia i publikacji ustaw, wyroków TK i uchwał Sejmu, pełne teksty uchwał (PDF) |
| **[Sejm-PROC]** | Sejm RP — przebieg procesów legislacyjnych (`api.sejm.gov.pl/sejm/term{8,10}/processes`) | etapy prac nad ustawami, stanowiska Senatu, decyzje Prezydenta |
| **[Sejm-GŁ]** | Sejm RP — wyniki głosowań (`api.sejm.gov.pl/sejm/term{8,10}/votings`) | liczby głosów za, przeciw i wstrzymujących się |
| **[TK-IPO]** | Trybunał Konstytucyjny — Internetowy Portal Orzeczeń (`ipo.trybunal.gov.pl`) | metryki spraw, składy orzekające, sentencje wyroków |
| **[Senat]** | Senat RP — tekst Konstytucji w repozytorium (`Senat/konstytucja_rp_miniatura_w._polska.txt`). Stanowiska Senatu w sprawie ustaw podaję według [Sejm-PROC], bo serwis senat.gov.pl zablokował dostęp automatyczny (Cloudflare, kod 403) | brzmienie przepisów Konstytucji |
| **[D1]** | `TK/Chronologia_Kryzysu.md` (opracowanie artykułu polskiej Wikipedii, rew. 81177984) | fakty, których nie da się potwierdzić w dokumentach TK, Sejmu ani Senatu, np. zachowania polityków albo decyzje rządu |
| **[D2]** | `TK/Weryfikacja_Chronologii.md` (weryfikacja D1 w źródłach urzędowych i mediach) | ustalenia uzupełniające |

Strona `trybunal.gov.pl` odrzucała połączenia (ECONNREFUSED), dlatego materiały TK pobrałem z portalu orzeczeń `ipo.trybunal.gov.pl`. Nie korzystałem bezpośrednio z mediów zagranicznych ani z dokumentów instytucji międzynarodowych. Orzeczenia ETPCz i TSUE przywołuję tylko tak, jak opisują je uchwały Sejmu.

**Oznaczenie wiarygodności** przy każdym kroku: ⬛ dokument urzędowy (Sejm, TK, Senat); ◻️ tylko dokumenty z `./TK` (D1/D2).

---

## Punkt wyjścia: co mówi Konstytucja [Senat]

- **Art. 194 ust. 1:** „Trybunał Konstytucyjny składa się z 15 sędziów, wybieranych indywidualnie przez Sejm na 9 lat spośród osób wyróżniających się wiedzą prawniczą”.
- **Art. 194 ust. 2:** Prezesa i Wiceprezesa TK powołuje Prezydent „spośród kandydatów przedstawionych przez Zgromadzenie Ogólne Sędziów”.
- **Art. 190 ust. 1–2:** orzeczenia TK „mają moc powszechnie obowiązującą i są ostateczne” oraz „podlegają niezwłocznemu ogłoszeniu”.
- **Art. 122 ust. 3–4:** Prezydent może skierować ustawę do TK przed podpisaniem (kontrola prewencyjna). Jeżeli TK uzna ją za niezgodną z Konstytucją, Prezydent „odmawia podpisania ustawy”.
- **Art. 197:** organizację TK i tryb postępowania określa **ustawa**.
- Konstytucja **nie przewiduje ślubowania** sędziego TK. Obowiązek ten wynika z ustawy. Według art. 4 ust. 1 ustawy z 30.11.2016 o statusie sędziów TK „Osoba wybrana na stanowisko sędziego Trybunału składa wobec Prezydenta Rzeczypospolitej Polskiej ślubowanie”, a według art. 5 „stosunek służbowy sędziego Trybunału nawiązuje się po złożeniu ślubowania” [Sejm-ELI: DU/2016/2073].

Te luki, czyli ślubowanie uregulowane w ustawie, publikacja wyroków zależna od rządu, zwykła większość przy wyborze sędziów i ustrój TK określany ustawą zwykłą, wyznaczają przebieg całego kryzysu.

---

## Etap I. Podwójna obsada (październik–grudzień 2015)

**Krok 1 — 8.10.2015.** Sejm VII kadencji podejmuje pięć uchwał o wyborze sędziów TK: Romana Hausera, Andrzeja Jakubeckiego, Krzysztofa Ślebzaka, Bronisława Sitka i Andrzeja Jana Sokali. Uchwały ukazują się w M.P. 23.10.2015 (poz. 1038–1042). ⬛ [Sejm-ELI: MP/2015/1038–1042]

**Krok 2 — 19.11.2015.** Sejm VIII kadencji uchwala nowelizację ustawy o TK w dniu swojego pierwszego posiedzenia. Wniosek o odrzucenie: 151 za, 273 przeciw. Całość: **268 za, 0 przeciw, 192 posłów nie głosowało**. Ustawa ukazuje się w Dz.U. już **20.11.2015** (poz. 1928). ⬛ [Sejm-GŁ: term8, pos. 1, gł. 66 i 78; Sejm-ELI: DU/2015/1928]

**Krok 3 — 25.11.2015.** Sejm podejmuje pięć uchwał „w sprawie stwierdzenia braku mocy prawnej” uchwał z 8 października (druki 42–46). W głosowaniach końcowych oddano ok. **270–273 głosy za i 40–43 przeciw, przy ok. 145 niegłosujących**. Uchwały ukazują się w M.P. 26.11.2015 (poz. 1131–1135). ⬛ [Sejm-GŁ: term8, pos. 2, gł. 23–27; Sejm-PROC: term8/42; Sejm-ELI: MP/2015/1131–1135]

**Krok 4 — 30.11.2015.** TK wydaje postanowienie zabezpieczające, w którym wzywa Sejm do wstrzymania wyboru sędziów do czasu wyroku w sprawie K 34/15. Sejm się do niego nie stosuje. ◻️ [D1, przypis 27]

**Krok 5 — 2.12.2015.** Sejm wybiera Henryka Ciocha (236 za, 167 przeciw), Lecha Morawskiego (232/156), Mariusza Muszyńskiego (236/170), Julię Przyłębską (234/166) i Piotra Pszczółkowskiego (233/166). Uchwały ukazują się w M.P. **tego samego dnia** (poz. 1182–1186). ⬛ [Sejm-GŁ: term8, pos. 3, gł. 6–13; Sejm-ELI: MP/2015/1182–1186]

**Krok 6 — noc z 2 na 3.12.2015 i 9.12.2015.** Prezydent Andrzej Duda przyjmuje ślubowanie od osób wybranych 2 grudnia. Nie przyjmuje go od nikogo z osób wybranych 8 października. ◻️ [D1, przypisy 45–47]

**Krok 7 — 3.12.2015, wyrok K 34/15.** TK uznaje, że wybór trzech sędziów na miejsca zwolnione w listopadzie 2015 r. był zgodny z Konstytucją, a dwóch na miejsca grudniowe — niezgodny. Wyrok zostaje opublikowany dopiero **16.12.2015** (Dz.U. poz. 2129), po 13 dniach. Wstrzymanie publikacji przez premier Beatę Szydło opisuje ◻️ [D1]. ⬛ [Sejm-ELI: DU/2015/2129]

**Krok 8 — 9.12.2015, wyrok K 35/15.** TK uznaje za niekonstytucyjne przepisy o ponownym wyborze sędziów i wygaszeniu funkcji prezesa i wiceprezesa TK. Publikacja: **18.12.2015** (Dz.U. poz. 2147). ⬛ [Sejm-ELI: DU/2015/2147]

> **Stan po Etapie I:** w TK zasiadają trzy osoby wybrane na miejsca, które według K 34/15 zostały już skutecznie obsadzone. Trzech prawidłowo wybranych sędziów nie zostaje zaprzysiężonych. Ten stan, określany jako spór o „dublerów”, trwa do końca opisywanego okresu.

---

## Etap II. Ustawy „naprawcze” i odmowa publikacji wyroków (grudzień 2015 – 2018)

**Krok 9 — 15–28.12.2015.** Projekt nowelizacji ustawy o TK (druk 122) wpływa do Sejmu 15.12. Sejm uchwala go **22.12** (wniosek o odrzucenie: 195/233; całość: **235 za, 181 przeciw**). Senat zajmuje stanowisko **24.12**, a Prezydent podpisuje ustawę **28.12**. Ustawa ukazuje się w Dz.U. tego samego dnia (poz. 2217) i wchodzi w życie bez vacatio legis. Od wpłynięcia projektu do wejścia w życie minęło 13 dni. ⬛ [Sejm-PROC: term8/122; Sejm-GŁ: term8, pos. 6, gł. 44 i 68; Sejm-ELI: DU/2015/2217]

**Krok 10 — 7–8.03.2016.** Marszałek Sejmu ogłasza tekst jednolity ustawy o TK uwzględniający nowelizację z 22.12.2015 (Dz.U. 2016 poz. 293). ⬛ [Sejm-ELI: DU/2016/293]

**Krok 11 — 9.03.2016, wyrok K 47/15.** TK uznaje nowelizację z 22.12.2015 za niezgodną z Konstytucją w całości. Orzeka przy tym bezpośrednio na podstawie Konstytucji, z pominięciem badanej ustawy. Rząd odmawia publikacji, a premier nazywa wyrok „stanowiskiem niektórych sędziów”. ◻️ [D1] Publikacja następuje dopiero **5.06.2018** (Dz.U. 2018 poz. 1077), **po 818 dniach**. ⬛ [Sejm-ELI: DU/2018/1077]

**Krok 12 — 14.04.2016.** Sejm wybiera Zbigniewa Jędrzejewskiego: **227 za, 0 przeciw, 227 posłów nie głosowało** (bojkot opozycji). ⬛ [Sejm-GŁ: term8, pos. 16, gł. 61; Sejm-ELI: MP/2016/393]

**Krok 13 — 22.07–1.08.2016.** Nowa ustawa o TK (druk 558): III czytanie 7.07, stanowisko Senatu 21.07, rozpatrzenie poprawek 22.07, podpis Prezydenta 30.07, publikacja 1.08.2016 (Dz.U. poz. 1157). ⬛ [Sejm-PROC: term8/558; Sejm-ELI: DU/2016/1157]

**Krok 14 — 11.08.2016, wyrok K 39/16, i 7.11.2016, wyrok K 44/16.** TK kwestionuje m.in. przepisy o obowiązku dopuszczenia „dublerów” do orzekania. Oba wyroki rząd publikuje dopiero **5.06.2018** (Dz.U. 2018 poz. 1078 i 1079). ⬛ [Sejm-ELI] Bojkot rozpraw przez trzech sędziów wybranych w 2015 r. i 2016 r. przez Sejm VIII kadencji opisuje ◻️ [D1].

**Krok 15 — 30.11 i 13.12.2016.** Sejm uchwala trzy ustawy: o organizacji i trybie postępowania przed TK (228/200), o statusie sędziów TK (III czytanie 4.11.2016, poprawki Senatu przyjęte 30.11) oraz przepisy wprowadzające (229/198). Stanowisko Senatu w sprawie przepisów wprowadzających zapada 15.12. Prezydent podpisuje wszystkie trzy ustawy **19.12.2016** i tego samego dnia ukazują się one w Dz.U. (poz. 2072, 2073, 2074). ⬛ [Sejm-GŁ: term8, pos. 31, gł. 37; pos. 32, gł. 32; Sejm-PROC: term8/880, term8/1059; Sejm-ELI]
- Ten zapis wyjaśnia rozbieżność dat w D1. Data „4 listopada 2016” to III czytanie w Sejmie, a ustawa ostatecznie nosi datę 30 listopada 2016.

**Krok 16 — 15.12.2016.** Sejm wybiera Michała Warcińskiego. ⬛ [Sejm-ELI: MP/2016/1206]

**Krok 17 — 20 i 21.12.2016.** Prezydent wydaje postanowienie nr 1131.24.2016 o **powierzeniu pełnienia obowiązków Prezesa TK** (20.12, M.P. poz. 1229), a następnie postanowienie nr 1131.25.2016 o **powołaniu Prezesa TK** (21.12, M.P. poz. 1237). Funkcję obejmuje Julia Przyłębska. ⬛ [Sejm-ELI: MP/2016/1229, MP/2016/1237] Przebieg Zgromadzenia Ogólnego z 20.12.2016 (6 oddanych głosów, ośmioro sędziów odmówiło głosowania) oraz zarzuty, że nie doszło do ważnego powołania, opisuje ◻️ [D1].

**Krok 18 — 2017–2018: uzupełnianie składu przez Sejm VIII kadencji.** Sejm wybiera Grzegorza Jędrejka (24.02.2017), Andrzeja Zielonackiego (8.06.2017), **Justyna Piskorskiego** na miejsce zmarłego L. Morawskiego (15.09.2017: 248 za, 3 przeciw, 191 niegłosujących) oraz **Jarosława Wyrembaka** na miejsce zmarłego H. Ciocha (26.01.2018: 228 za, 25 przeciw, 205 niegłosujących). 5.07.2017 Prezydent powołuje Wiceprezesa TK (M.P. poz. 684; według D1 jest nim Mariusz Muszyński). ⬛ [Sejm-ELI: MP/2017/224, 610, 873, MP/2018/134, MP/2017/684; Sejm-GŁ: term8, pos. 47, gł. 3; pos. 57, gł. 93]

**Krok 19 — 24.10.2017, wyrok K 1/17.** TK uznaje przepisy ustaw z 2016 r. (m.in. o dopuszczeniu do orzekania sędziów zaprzysiężonych przez Prezydenta) za zgodne z Konstytucją. Publikacja: 27.10.2017 (Dz.U. poz. 2001). ⬛ [Sejm-ELI: DU/2017/2001]

**Krok 20 — 12.04–5.06.2018.** Nowelizacja przepisów wprowadzających (druk 2388): uchwalona 12.04, stanowisko Senatu 16.04, podpis Prezydenta 2.05, publikacja 8.05 (Dz.U. poz. 849). Na jej podstawie rząd publikuje 5.06.2018 trzy zaległe orzeczenia: K 47/15, K 39/16 i K 44/16. ⬛ [Sejm-PROC: term8/2388; Sejm-ELI: DU/2018/849, DU/2018/1077–1079]

---

## Etap III. Trybunał po zmianie kierownictwa (2019–2023)

**Krok 21 — skład TK.** Sejm VIII i IX kadencji wybiera kolejnych sędziów:
- Wojciech Sych (26.04.2019),
- Krystyna Pawłowicz, Stanisław Piotrowicz i Jakub Stelina (21.11.2019),
- Rafał Wojciechowski (20.12.2019),
- Bartłomiej Sochański (6.04.2020),
- Bogdan Święczkowski (8.02.2022).

⬛ [Sejm-ELI: MP/2019/414, 1132–1134, 1197; MP/2020/340; MP/2022/203]

**Krok 22 — orzeczenia ustrojowe** (wszystkie opublikowane):
- **K 12/18** z 25.03.2019, o wyborze sędziów-członków KRS przez Sejm (Dz.U. 2019 poz. 609),
- **U 2/20** z 20.04.2020, o uchwale trzech izb SN (M.P. 2020 poz. 376),
- **K 1/20** z 22.10.2020 (Dz.U. 2021 poz. 175, publikacja 27.01.2021, czyli po ponad trzech miesiącach; w M.P. 2020 poz. 1104 ukazało się „Stanowisko Rady Ministrów (…) w przedmiocie terminu publikacji wyroku”),
- **P 7/20** z 14.07.2021 (Dz.U. 2021 poz. 1309),
- **K 3/21** z 7.10.2021 (Dz.U. 2021 poz. 1852),
- **K 6/21** z 24.11.2021, o art. 6 EKPC (Dz.U. 2021 poz. 2161).

⬛ [Sejm-ELI]

**Krok 23 — orzecznictwo sądów krajowych.** Uchwała Sejmu z 13.03.2026 wymienia orzeczenia SN (**I KZ 29/21, V KZ 47/21, I KZP 5/23, II KK 76/23**) i NSA (**III OSK 1336/24** i III OSK 2528/2[…], sygnatura obcięta w tekście uchwały), które „stwierdza[ją], że Trybunał Konstytucyjny nie jest w stanie pełnić swojej konstytucyjnie przypisanej roli”. ⬛ [Sejm-ELI: MP/2026/299] Charakter postanowienia I KZP 5/23 z 13.12.2023 doprecyzowuje ◻️ [D2]: SN odmówił podjęcia uchwały, bo wyrok TK „nie wywiera skutków” z art. 190 Konstytucji.

---

## Etap IV. Próba „usunięcia skutków kryzysu” przez Sejm X kadencji (2024–2025)

**Krok 24 — koniec publikacji wyroków TK.** Ostatni wyrok TK opublikowany w Dzienniku Ustaw to wyrok z 27.02.2024 (SK 90/22), ogłoszony **4.03.2024** (Dz.U. 2024 poz. 300). W bazie ELI **nie ma żadnego wyroku TK opublikowanego w latach 2025–2026**. Liczba wyroków TK opublikowanych w Dz.U. i M.P. wynosiła: 2022 — 14, 2023 — 25, 2024 — 3, 2025 — 0, 2026 — 0. ⬛ [Sejm-ELI, wyszukiwanie po tytule „Wyrok Trybunału Konstytucyjnego”]

**Krok 25 — 6.03.2024, uchwała Sejmu** „w sprawie usunięcia skutków kryzysu konstytucyjnego lat 2015–2023 w kontekście działalności Trybunału Konstytucyjnego” (druk 226, projekt wpłynął 5.03). Głosowanie: **240 za, 197 przeciw**. Publikacja w M.P. 11.03.2024 (poz. 198). ⬛ [Sejm-PROC: term10/226; Sejm-GŁ: term10, pos. 7, gł. 8; Sejm-ELI: MP/2024/198] Według tekstu uchwały:
- dziesięć uchwał Sejmu (o wyborze Sitka i Sokali z 8.10.2015, trzy uchwały z 25.11.2015, wybór Muszyńskiego, Ciocha i Morawskiego z 2.12.2015 oraz wybór Piskorskiego i Wyrembaka) zostało podjętych „z rażącym naruszeniem prawa” i „są pozbawione mocy prawnej”,
- „Mariusz Muszyński, Justyn Piskorski i Jarosław Wyrembak nie są sędziami Trybunału Konstytucyjnego”,
- „funkcję Prezesa Trybunału Konstytucyjnego sprawuje osoba nieuprawniona”, a kadencja J. Przyłębskiej, nawet przy uznaniu powołania, „wygasła z dniem 21 grudnia 2022 r.” (art. 10 ust. 2 ustawy o organizacji TK: 6 lat),
- „uwzględnienie (…) rozstrzygnięć Trybunału Konstytucyjnego wydanych z naruszeniem prawa może zostać uznane za naruszenie zasady legalizmu”.

**Krok 26 — 28.05.2024, wyrok U 5/24.** Skład: B. Święczkowski (przewodniczący), S. Piotrowicz (sprawozdawca), B. Sochański. TK orzeka, że uchwała Sejmu z 6.03.2024 „jest niezgodna z art. 7 w związku z art. 87 ust. 1, art. 10 w związku z art. 173 i art. 190 ust. 1 Konstytucji”. Orzeczenie zapadło jednogłośnie, a wniosek złożyła grupa posłów. Wyrok został opublikowany w urzędowym zbiorze orzeczeń TK (OTK ZU A/2024, poz. 65), ale **nie w Monitorze Polskim**. ⬛ [TK-IPO: U 5/24; Sejm-ELI]

**Krok 27 — 6.03–7.10.2024, nowe ustawy o TK** (druki 253 i 254). Etapy:
- wpływ do Sejmu 6.03, I czytanie 26.04, wysłuchanie publiczne 24.05,
- uchwalenie **24.07.2024** (ustawa o TK: 242 za, 202 przeciw; przepisy wprowadzające: 242/200),
- **stanowisko Senatu z poprawkami 31.07.2024** (druki 590 i 591 z 1.08.2024),
- przyjęcie poprawek Senatu 13.09.2024, przekazanie Prezydentowi 16.09.2024,
- **7.10.2024 — Prezydent kieruje obie ustawy do TK** (kontrola prewencyjna).

Proces legislacyjny w bazie Sejmu **kończy się na etapie skierowania do TK**. Ustawy nie mają adresu ELI, czyli nie zostały ogłoszone. ⬛ [Sejm-PROC: term10/253, term10/254; Sejm-GŁ: term10, pos. 16, gł. 12 i 15]

**Krok 28 — listopad–grudzień 2024, zmiana prezesa TK.** Uchwała Sejmu z 13.03.2026 wskazuje, że J. Przyłębska kierowała TK „w okresie od 20 grudnia 2016 r. do 29 listopada 2024 r.”, a powołanie **Bogdana Święczkowskiego** na Prezesa TK jest „obarczone (…) tymi samymi wadami prawnymi”. ⬛ [Sejm-ELI: MP/2026/299] Datę powołania (ok. 10.12.2024, przez Prezydenta A. Dudę) podaje ◻️ [D2].

**Krok 29 — 2025: Sejm nie wybiera kandydatów PiS.** Kandydatury Marka Asta i Artura Kotowskiego przepadają w pięciu kolejnych głosowaniach:

| Data | Marek Ast | Artur Kotowski |
|---|---|---|
| 21.02.2025 | 173 za / 224 przeciw / 13 wstrz. | 172 / 224 / 15 |
| 9.05.2025 | 180 / 230 / 10 | 181 / 229 / 10 |
| 12.09.2025 | 181 / 233 / 21 | 181 / 235 / 19 |
| 23.01.2026 | 158 / 223 / 12 | 158 / 224 / 12 |
| 13.03.2026 | — | 171 / 249 / 4 (razem z Michałem Skwarzyńskim: 172 / 253 / 4) |
| 11.06.2026 | — | 173 / 245 / 6 |

⬛ [Sejm-GŁ: term10, pos. 29 gł. 78–79; pos. 34 gł. 50–51; pos. 40 gł. 29–30; pos. 50 gł. 106–107; pos. 53 gł. 128 i 130; pos. 59 gł. 68]

**Krok 30 — 6.05.2025, wyrok K 2/25** (wniosek Prezydenta wpłynął 27.02.2025). Skład: R. Wojciechowski (przewodniczący), K. Pawłowicz, S. Piotrowicz, B. Święczkowski (sprawozdawca), A. Zielonacki. Art. 1 ust. 2 ustawy budżetowej na 2025 r. w części dotyczącej TK, „w zakresie, w jakim ustala wydatki Trybunału Konstytucyjnego w wysokości mniejszej niż przewidziane w projekcie (…) przedłożonym Sejmowi przez Radę Ministrów (…), wskutek czego ogranicza możliwość wykonywania przez Trybunał (…) jego konstytucyjnie określonych zadań”, jest niezgodny m.in. z art. 10 Konstytucji. Wyrok jest w OTK ZU A/2025, poz. 51, ale **nie w Dz.U.** ⬛ [TK-IPO: K 2/25; Sejm-ELI] Sprawa ustawy budżetowej na 2026 r. (**K 4/26**, wniosek z 4.02.2026) jest w toku. ⬛ [TK-IPO: K 4/26]

**Krok 31 — 29.07.2025, wyrok Kp 3/24** (połączony z Kp 4/24, rozprawy 2.04 i 29.07.2025).
- **Skład:** B. Święczkowski (przewodniczący), B. Sochański (sprawozdawca), K. Pawłowicz, S. Piotrowicz, **J. Piskorski**, J. Stelina, W. Sych, M. Warciński, R. Wojciechowski, **J. Wyrembak** i A. Zielonacki.
- **Niekonstytucyjne przepisy:** TK uznaje za niezgodne z Konstytucją m.in.:
  - przepisy o wyznaczaniu składów przez Zgromadzenie Ogólne (art. 7 ust. 2 pkt 10 w zw. z art. 54),
  - **art. 20 ust. 2 i 3**, czyli 14-dniowy termin na umożliwienie sędziemu złożenia ślubowania przed Prezydentem,
  - całe art. 10–12 przepisów wprowadzających, w tym pojęcie „osoba nieuprawniona do orzekania”.
- **Skutek:** wskazane przepisy są „**nierozerwalnie związane z całą ustawą**”. Orzeczenie zapadło większością głosów, przy trzech zdaniach odrębnych. W uzasadnieniu TK stwierdza: „Prezydent Rzeczypospolitej Polskiej na podstawie art. 122 ust. 4 Konstytucji ma obowiązek odmówić podpisania obydwu kontrolowanych ustaw”.
- **Publikacja:** OTK ZU A/2025, poz. 82. ⬛ [TK-IPO: Kp 3/24]
- W bazie procesów legislacyjnych Sejmu **nie ma wpisu o odmowie podpisania** tych ustaw. Informacja z D1 o odmowie 19.02.2026 jest błędna: tego dnia zawetowano ustawę o KRS. ◻️ [D2, poz. 8]

---

## Etap V. „Trzeci spór o dublerów” — ślubowanie (2026)

**Krok 32 — 13.03.2026, uchwała Sejmu** „w sprawie działań niezbędnych do zapewnienia spełniania przez Trybunał Konstytucyjny wymogów sądu ustanowionego na mocy prawa, niezawisłego i bezstronnego” (druk 2316). Głosowanie: **235 za, 197 przeciw**. Publikacja w M.P. 18.03.2026 (poz. 299). ⬛ [Sejm-GŁ: term10, pos. 53, gł. 81; Sejm-ELI: MP/2026/299] Uchwała:
- powołuje się na wyroki TK K 34/15 i K 35/15, na orzeczenia SN i NSA, na uchwałę z 6.03.2024, na wyroki ETPCz (*Xero Flor*, 7.05.2021; *M.L. przeciwko Polsce*, 14.12.2023; *A.R. przeciwko Polsce*, 13.11.2025) oraz na wyrok TSUE z 18.12.2025 (C-448/23),
- stwierdza, że TK z udziałem Muszyńskiego, Ciocha i Morawskiego, a potem Piskorskiego i Wyrembaka, „nie spełniał” i nadal nie spełnia wymogów sądu ustanowionego ustawą,
- stwierdza, że Hauser, Jakubecki i Ślebzak „zostali prawidłowo wybrani (…), jednakże bezprawnie pozbawieni możliwości objęcia urzędu w wyniku odmowy przyjęcia przez Prezydenta (…) Andrzeja Dudę ślubowania”,
- uznaje za konieczny „wybór sędziów Trybunału Konstytucyjnego na wolne miejsca”.

**Krok 33 — 13.03.2026 (tego samego dnia).** Sejm wybiera sześcioro sędziów TK. Każdy otrzymuje 236–237 głosów za przy 182–187 przeciw:
- Magdalena Bentkowska,
- Marcin Dziurda,
- Anna Korwin-Piotrowska,
- Krystian Markiewicz,
- Dariusz Szostek,
- Maciej Taborowski.

Kandydatury PiS (Kotowski i Skwarzyński) przepadają. Uchwały ukazują się w M.P. 18.03.2026 (poz. 300–305). Podstawą prawną w każdej uchwale jest art. 194 ust. 1 Konstytucji i art. 2 ust. 2 ustawy o statusie sędziów TK. ⬛ [Sejm-GŁ: term10, pos. 53, gł. 125–132; Sejm-ELI: MP/2026/300–305]

**Krok 34 — 1.04 i 9.04.2026.** Prezydent Karol Nawrocki przyjmuje ślubowanie od Bentkowskiej i Szostka. Pozostała czwórka składa ślubowanie 9.04.2026 w Sejmie, bez udziału Prezydenta. Prezes TK uznaje, że stosunek służbowy nawiązało tylko dwoje sędziów. ◻️ [D1; D2, poz. 12]

**Krok 35 — 27.04.2026, spór kompetencyjny Kpt 1/26.** Prezydent wnosi do TK spór kompetencyjny z Sejmem, uczestniczy w nim Prokurator Generalny. Spór dotyczy pytań:
- czy czynności z **9.04.2026** w Sejmie „mogły wywołać jakiekolwiek skutki prawne w sferze objęcia urzędu sędziego TK”,
- czy kompetencja Prezydenta do odebrania ślubowania „ma charakter wyłączny”,
- czy Sejm „jest uprawniony do organizowania albo legitymizowania czynności mających zastępować ustawowy akt złożenia ślubowania”.

Według stanu na 16.11.2026 **sprawa jest w toku**. ⬛ [TK-IPO: Kpt 1/26]

**Krok 36 — 12.05.2026, wyrok K 3/26** (wniosek grupy posłów z 3.02.2026, rozprawy 17.03 i 12.05.2026).
- **Skład:** B. Święczkowski (przewodniczący), B. Sochański (sprawozdawca), R. Wojciechowski, **J. Piskorski** i **J. Wyrembak**.
- **Sentencja:** „Art. 4 ust. 1 ustawy (…) o statusie sędziów Trybunału Konstytucyjnego (…), **rozumiany w ten sposób, że wyznacza Prezydentowi Rzeczypospolitej Polskiej obowiązek odebrania ślubowania** od osoby wybranej przez Sejm (…) na sędziego Trybunału Konstytucyjnego, **jest niezgodny z art. 126 w związku z art. 2 Konstytucji**”. W pozostałym zakresie TK umorzył postępowanie, w tym co do zarzutów wobec art. 2 ust. 2 ustawy (trybu wyboru sędziów przez Sejm). Orzeczenie zapadło większością głosów.

⬛ [TK-IPO: K 3/26]
- Wyrok ma datę **12 maja**, a nie 13 maja, jak podawały media (D2). TK **nie** uznał też trybu wyboru sędziów za niekonstytucyjny, bo w tej części umorzył postępowanie.

**Krok 37 — 11.06.2026.** Sejm wybiera **Sławomira Patyrę** (235 za, 184 przeciw). Kandydatura Kotowskiego przepada. Publikacja w M.P. 12.06.2026 (poz. 603). ⬛ [Sejm-GŁ: term10, pos. 59, gł. 68–69; Sejm-ELI: MP/2026/603] Przyjęcie od niego ślubowania przez Prezydenta (lipiec 2026) opisują tylko media cytowane w ◻️ [D2].

**Krok 38 — 4.09.2026.** Sejm wybiera **Macieja Berka** w głosowaniu nad listą kandydatów, w którym padło 226 i 184 głosy. Publikacja w M.P. 8.09.2026 (poz. 900). ⬛ [Sejm-GŁ: term10, pos. 64, gł. 14; Sejm-ELI: MP/2026/900] Ślubowanie Berka w Sejmie 14.10.2026 i jego nieuznanie przez Prezydenta opisuje ◻️ [D2].

**Krok 39 — 13.10.2026.** Opinia Komisji Weneckiej w sprawie ślubowania. ◻️ [D1, D2] (dokument organu międzynarodowego, nie weryfikowałem go w źródłach polskich instytucji).

---

## Etap VI. Przejęcie kierownictwa TK (październik–listopad 2026)

**Krok 40 — 30.10.2026.** Na stronie TK ukazuje się informacja o zarządzeniu przerwy w czynnościach służbowych Prezesa B. Święczkowskiego i Wiceprezesa B. Sochańskiego na podstawie art. 130 ustawy — Prawo o ustroju sądów powszechnych. Kierowanie TK przejmuje A. Korwin-Piotrowska jako sędzia z najdłuższym stażem. ◻️ [D1, przypis 333 — tytuł komunikatu TK] Strona trybunal.gov.pl była niedostępna z tego środowiska, więc treści komunikatu nie odczytałem.

**Krok 41 — 10.11.2026, pierwszy akt nowego kierownictwa w dzienniku urzędowym.** W M.P. 2026 poz. 1133 ukazuje się **uchwała nr 1/2026 Zgromadzenia Ogólnego Sędziów TK z 10.11.2026** w sprawie zmiany Regulaminu TK. Podpisała ją „**Sędzia Trybunału Konstytucyjnego zastępująca Prezesa Trybunału Konstytucyjnego: A. Korwin-Piotrowska**”. Uchwała:
- pozwala co najmniej 5 sędziom zażądać zwołania Zgromadzenia Ogólnego (Prezes musi je zwołać w ciągu 14 dni),
- uzależnia przyjęcie informacji o wykonaniu budżetu TK od pozytywnej opinii Zgromadzenia Ogólnego o sprawozdaniu Dyrektora Kancelarii.

Opublikowano ją w dniu jej podjęcia. To pierwszy akt TK ogłoszony w dzienniku urzędowym od marca 2024 r. ⬛ [Sejm-ELI: MP/2026/1133]

**Krok 42 — listopad 2026 (stan otwarty).** Postępowania przed Sądem Najwyższym w sprawie zarządzeń z 30.10.2026 i terminy sądu dyscyplinarnego TK (19–20.11.2026) znane są tylko z relacji medialnych. ◻️ [D2, poz. 14]

---

## Synteza: mechanizm kryzysu w świetle dokumentów urzędowych

1. **Każdy organ wykorzystuje własną „bramkę”.** Sejm wybiera i unieważnia wybory uchwałami (2015, 2024, 2026). Prezydent decyduje o ślubowaniu (2015, 2026) i o powołaniu prezesa (2016, 2024). Rząd decyduje o publikacji wyroków (2015–2018 i od 2024 r.). TK orzeka o ustawach, które go dotyczą (K 47/15, K 1/17, Kp 3/24, K 3/26), i o uchwałach Sejmu, które go dotyczą (U 5/24). Konstytucja nie wskazuje arbitra dla żadnej z tych bramek.
2. **Liczby z dokumentów:** 818 dni zwłoki z publikacją K 47/15. Zero wyroków TK w Dz.U. od marca 2024 r. Sześć ustaw o TK w latach 2015–2016. Cztery uchwały Sejmu o statusie sędziów (25.11.2015, 2.12.2015, 6.03.2024, 13.03.2026). Pięć nieudanych głosowań nad kandydatami PiS w latach 2025–2026.
3. **Spór o ślubowanie jest sporem o wykładnię ustawy, nie Konstytucji.** TK w K 3/26 uznał, że ustawa **nie może** nakładać na Prezydenta obowiązku przyjęcia ślubowania. Sejm w uchwale z 13.03.2026 uznał odmowę przyjęcia ślubowania w 2015 r. za naruszenie Konstytucji. Rozstrzygnięcie sporu kompetencyjnego Kpt 1/26 pozostaje otwarte.
4. **Skład orzekający jako zarzut.** W sprawach Kp 3/24 i K 3/26 orzekali Piskorski i Wyrembak, czyli osoby, które Sejm w uchwałach z 2024 i 2026 r. uznał za niebędące sędziami. Dla Sejmu i rządu skutkuje to nieuznawaniem i niepublikowaniem tych wyroków (Krok 24).

---

## Wykaz źródeł

### Sejm RP — akty w Dz.U. i M.P. (API ELI)
Format: `https://api.sejm.gov.pl/eli/acts/{wydawca}/{rok}/{pozycja}` (tekst: dodać `/text.pdf`). Wersja dla człowieka: `https://isap.sejm.gov.pl` (wyszukiwanie po roku i pozycji).

| Akt | Adres |
|---|---|
| M.P. 2015 poz. 1038–1042 (wybór 8.10.2015) | https://api.sejm.gov.pl/eli/acts/MP/2015/1038 (…1042) |
| Dz.U. 2015 poz. 1928 (nowelizacja 19.11.2015) | https://api.sejm.gov.pl/eli/acts/DU/2015/1928 |
| M.P. 2015 poz. 1131–1135 (uchwały 25.11.2015) | https://api.sejm.gov.pl/eli/acts/MP/2015/1131 (…1135) |
| M.P. 2015 poz. 1182–1186 (wybór 2.12.2015) | https://api.sejm.gov.pl/eli/acts/MP/2015/1182 (…1186) |
| Dz.U. 2015 poz. 2129 (K 34/15), 2147 (K 35/15), 2217 (nowelizacja 22.12.2015) | https://api.sejm.gov.pl/eli/acts/DU/2015/2129 · …/2147 · …/2217 |
| Dz.U. 2016 poz. 293, 1157, 2072, 2073, 2074 | https://api.sejm.gov.pl/eli/acts/DU/2016/293 · …/1157 · …/2072 · …/2073 · …/2074 |
| M.P. 2016 poz. 393, 1206, 1229, 1237 | https://api.sejm.gov.pl/eli/acts/MP/2016/393 · …/1206 · …/1229 · …/1237 |
| M.P. 2017 poz. 224, 610, 684, 873; M.P. 2018 poz. 134 | https://api.sejm.gov.pl/eli/acts/MP/2017/224 · …/610 · …/684 · …/873 · https://api.sejm.gov.pl/eli/acts/MP/2018/134 |
| Dz.U. 2017 poz. 2001 (K 1/17) | https://api.sejm.gov.pl/eli/acts/DU/2017/2001 |
| Dz.U. 2018 poz. 849, 1077, 1078, 1079 | https://api.sejm.gov.pl/eli/acts/DU/2018/849 · …/1077 · …/1078 · …/1079 |
| M.P. 2019 poz. 414, 1132–1134, 1197; M.P. 2020 poz. 340; M.P. 2022 poz. 203 | https://api.sejm.gov.pl/eli/acts/MP/2019/414 · …/1132 · …/1197 · https://api.sejm.gov.pl/eli/acts/MP/2020/340 · https://api.sejm.gov.pl/eli/acts/MP/2022/203 |
| Dz.U. 2019 poz. 609 (K 12/18); M.P. 2020 poz. 376 (U 2/20), 1104; Dz.U. 2021 poz. 175, 1309, 1852, 2161 | https://api.sejm.gov.pl/eli/acts/DU/2019/609 · https://api.sejm.gov.pl/eli/acts/MP/2020/376 · …/MP/2020/1104 · https://api.sejm.gov.pl/eli/acts/DU/2021/175 · …/1309 · …/1852 · …/2161 |
| Dz.U. 2024 poz. 300 (ostatni opublikowany wyrok TK) | https://api.sejm.gov.pl/eli/acts/DU/2024/300 |
| M.P. 2024 poz. 198 (uchwała Sejmu 6.03.2024) | https://api.sejm.gov.pl/eli/acts/MP/2024/198/text.pdf |
| M.P. 2026 poz. 299 (uchwała Sejmu 13.03.2026) | https://api.sejm.gov.pl/eli/acts/MP/2026/299/text.pdf |
| M.P. 2026 poz. 300–305, 603, 900 (wybór sędziów 2026) | https://api.sejm.gov.pl/eli/acts/MP/2026/300 (…305) · …/603 · …/900 |
| M.P. 2026 poz. 1133 (uchwała ZO Sędziów TK 10.11.2026) | https://api.sejm.gov.pl/eli/acts/MP/2026/1133/text.pdf |

### Sejm RP — procesy legislacyjne
- VIII kadencja: druk 42 — https://api.sejm.gov.pl/sejm/term8/processes/42 · druk 122 — …/122 · druk 558 — …/558 · druk 880 — …/880 · druk 1059 — …/1059 · druk 2388 — …/2388
- X kadencja: druk 226 — https://api.sejm.gov.pl/sejm/term10/processes/226 · druk 253 — …/253 · druk 254 — …/254 · uchwały Senatu: https://api.sejm.gov.pl/sejm/term10/prints/590 · …/591
- Wersja dla człowieka: `https://www.sejm.gov.pl/Sejm10.nsf/PrzebiegProc.xsp?nr={druk}` (dla VIII kadencji `Sejm8.nsf`)

### Sejm RP — głosowania
Format: `https://api.sejm.gov.pl/sejm/term{kadencja}/votings/{posiedzenie}/{numer}`. Wersja dla człowieka: `https://www.sejm.gov.pl/Sejm10.nsf/agent.xsp?symbol=glosowania&NrKadencji={k}&NrPosiedzenia={p}&NrGlosowania={n}`.
- VIII kadencja: 1/66, 1/78 · 2/23–27 · 3/6, 3/8, 3/10, 3/12, 3/13 · 6/44, 6/68 · 16/61 · 31/37 · 32/32 · 47/3 · 57/93
- X kadencja: 7/8 · 16/12, 16/15 · 29/78–79 · 34/50–51 · 40/29–30 · 50/106–107 · 53/81, 53/125–132 · 59/68–69 · 64/14

### Trybunał Konstytucyjny — Internetowy Portal Orzeczeń
Format: `https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura={sygnatura}`
- U 5/24 — https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura=U%205/24
- K 2/25 — https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura=K%202/25
- Kp 3/24 — https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura=Kp%203/24
- K 3/26 — https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura=K%203/26
- Kpt 1/26 — https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura=Kpt%201/26
- K 4/26 — https://ipo.trybunal.gov.pl/ipo/Sprawa?&pokaz=dokumenty&sygnatura=K%204/26

### Senat RP
- Tekst Konstytucji: `Senat/konstytucja_rp_miniatura_w._polska.txt` (w repozytorium)
- Stanowiska Senatu: według [Sejm-PROC] (druki 122, 558, 880, 1059, 2388; druki 590 i 591 z X kadencji)

### Dokumenty w `./TK`
- [D1] [Chronologia_Kryzysu.md](Chronologia_Kryzysu.md) — CC BY-SA 4.0 (na podstawie Wikipedii)
- [D2] [Weryfikacja_Chronologii.md](Weryfikacja_Chronologii.md)
