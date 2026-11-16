# Weryfikacja chronologii kryzysu wokół TK w źródłach spoza Wikipedii

Dokument sprawdza fakty z pliku [`Chronologia_Kryzysu.md`](Chronologia_Kryzysu.md), który opiera się na Wikipedii (rewizja 81177984). Weryfikacja i ponowny audyt obu plików: **16 listopada 2026**. Poniższe wyniki dotyczą wskazanych twierdzeń i źródeł, nie wszystkich zdań i przypisów chronologii. Sprostowania z audytu uwzględniono już w pliku chronologii.

## Metoda

1. **Źródła pierwotne:** pobrano metadane wszystkich 17 aktów z tabeli w API Sejmu ELI (`https://api.sejm.gov.pl/eli/acts/{DU|MP}/{rok}/{poz}`). Porównano tytuły, daty aktów (`announcementDate`), publikacji (`promulgation`) i — tam, gdzie dotyczy — wejścia w życie (`entryIntoForce`). Przeczytano także sentencje K 34/15, K 35/15, K 39/16, K 47/15, Kp 3/24, K 3/26, sentencję i istotne dla audytu fragmenty uzasadnienia postanowienia SN I KZP 5/23 oraz opinii Komisji Weneckiej CDL-AD(2016)001 i CDL-AD(2026)031. Dla C-448/23 sprawdzono komunikat TSUE, nie pełne uzasadnienie. Komunikat strony sporu potwierdza jej działania lub stanowisko; sam nie rozstrzyga sporu o ich legalność.
2. **Media i serwisy prawnicze:** relacje prasowe stanowią uzupełnienie źródeł urzędowych. Wikipedia służy wyłącznie do ustalenia, co zawiera sprawdzana rewizja. API MediaWiki potwierdziło tytuł artykułu, numer rewizji **81177984** i znacznik czasu **2026-11-11T05:01:16Z**; pobrano również jej tekst. Nie sprawdzono ponownie każdego opisu bibliograficznego w 381 przypisach liczbowych.
3. **Ograniczenia:** ✅ odnosi się tylko do zakresu wskazanego w danym wierszu. ✅ᴹ oznacza zgodność z relacją prasową, a nie niezależne potwierdzenie w aktach. Część linków prasowych i strony SN blokują automatyczny odczyt; nie traktowano tego jako dowodu fałszu. Twierdzenia o wynagrodzeniach, spornych skutkach prawnych i brakujących dokumentach wymagają osobnej oceny. Potwierdzenie 17 dat publikacji nie pozwala uznać całego opisu lat 2015–2018 za zweryfikowany.

**Oznaczenia:**

- ✅ potwierdzone w źródle urzędowym,
- ✅ᴹ potwierdzone w mediach lub serwisach prawniczych,
- ⚠️ częściowo zgodne albo nieprecyzyjne,
- ❌ błąd w sprawdzanym twierdzeniu (może pochodzić z Wikipedii albo z opracowania),
- ➕ zdarzenie, którego brakuje w Wikipedii.

---

## 1. Akty prawne i publikacje (2015–2024) — API Sejmu ELI

Wszystkie poniższe daty aktów i publikacji są **zgodne** z chronologią. Każdy tytuł prowadzi do sprawdzonych metadanych ELI; zgodność dat nie potwierdza automatycznie opisu treści aktu.

| Akt | Data aktu | Data wydania dziennika | Wynik |
|---|---|---|---|
| [M.P. 2015 poz. 1038 — uchwała Sejmu o wyborze sędziego TK](https://api.sejm.gov.pl/eli/acts/MP/2015/1038) | 8.10.2015 | 23.10.2015 | ✅ |
| [Dz.U. 2015 poz. 1928 — nowelizacja ustawy o TK](https://api.sejm.gov.pl/eli/acts/DU/2015/1928) | 19.11.2015 | 20.11.2015 | ✅ |
| [M.P. 2015 poz. 1131 — uchwała o „braku mocy prawnej”](https://api.sejm.gov.pl/eli/acts/MP/2015/1131) | 25.11.2015 | 26.11.2015 | ✅ |
| [M.P. 2015 poz. 1182 — wybór sędziego TK przez Sejm VIII kadencji](https://api.sejm.gov.pl/eli/acts/MP/2015/1182) | 2.12.2015 | 2.12.2015 (ten sam dzień) | ✅ |
| [Dz.U. 2015 poz. 2129 — wyrok K 34/15](https://api.sejm.gov.pl/eli/acts/DU/2015/2129) | 3.12.2015 | **16.12.2015** | ✅ |
| [Dz.U. 2015 poz. 2147 — wyrok K 35/15](https://api.sejm.gov.pl/eli/acts/DU/2015/2147) | 9.12.2015 | **18.12.2015** | ✅ |
| [Dz.U. 2015 poz. 2217 — nowelizacja ustawy o TK](https://api.sejm.gov.pl/eli/acts/DU/2015/2217) | 22.12.2015 | 28.12.2015 | ✅ |
| [Dz.U. 2016 poz. 293 — obwieszczenie Marszałka (tekst jednolity)](https://api.sejm.gov.pl/eli/acts/DU/2016/293) | 7.03.2016 | 8.03.2016 | ✅ |
| [Dz.U. 2016 poz. 1157 — ustawa o TK](https://api.sejm.gov.pl/eli/acts/DU/2016/1157) | 22.07.2016 | 1.08.2016 | ✅ |
| [Dz.U. 2016 poz. 2072 — ustawa o organizacji i trybie postępowania przed TK](https://api.sejm.gov.pl/eli/acts/DU/2016/2072) | 30.11.2016 | 19.12.2016 | ✅ |
| [Dz.U. 2016 poz. 2073 — **ustawa o statusie sędziów TK**](https://api.sejm.gov.pl/eli/acts/DU/2016/2073) | **30.11.2016** | 19.12.2016 | ✅ (rozstrzyga niespójność z przypisu 221 Wikipedii) |
| [Dz.U. 2016 poz. 2074 — przepisy wprowadzające](https://api.sejm.gov.pl/eli/acts/DU/2016/2074) | 13.12.2016 | 19.12.2016 | ✅ |
| [Dz.U. 2018 poz. 849 — nowelizacja przepisów wprowadzających](https://api.sejm.gov.pl/eli/acts/DU/2018/849) | 12.04.2018 | 8.05.2018; wejście w życie 23.05.2018 (po upływie 14 dni) | ✅ |
| [Dz.U. 2018 poz. 1077 — wyrok K 47/15](https://api.sejm.gov.pl/eli/acts/DU/2018/1077) | 9.03.2016 | **5.06.2018** | ✅ |
| [Dz.U. 2018 poz. 1078 — wyrok K 39/16](https://api.sejm.gov.pl/eli/acts/DU/2018/1078) | 11.08.2016 | 5.06.2018 | ✅ |
| [Dz.U. 2018 poz. 1079 — wyrok K 44/16](https://api.sejm.gov.pl/eli/acts/DU/2018/1079) | 7.11.2016 | 5.06.2018 | ✅ |
| [M.P. 2024 poz. 198 — uchwała Sejmu „w sprawie usunięcia skutków kryzysu konstytucyjnego…”](https://api.sejm.gov.pl/eli/acts/MP/2024/198) | 6.03.2024 | 11.03.2024 | ✅ |

---

## 2. Wydarzenia z lat 2023–2026

| # | Twierdzenie z chronologii (za Wikipedią) | Wynik | Ustalenia i źródła |
|---|---|---|---|
| 1 | 13.12.2023 — I KZP 5/23: TK z „dublerami” nie jest trybunałem; orzeczenie ma moc zasady prawnej | ❌ / ⚠️ | Data i siedmioosobowy skład są zgodne. **Sentencja odmawia podjęcia uchwały**, nie nadaje mocy zasady prawnej. Sam skład siedmiu sędziów nie wystarcza do jej uzyskania (art. 87 § 1 ustawy o SN); [wyjaśnienie SN](https://sn.pl/pl/aktualnosci/komunikaty-o-sprawach/sad-najwyzszy-pyta-trybunal-konstytucyjny-o-konstytucyjnosc-przepisu-pozwalajacego-uchwale-zapadlej-w-skladzie-7-sedziow-nadac-moc-zasady-prawnej). Uzasadnienie (s. 7–10) odmawia skutków wyrokowi SK 78/21 wydanemu z udziałem J. Wyrembaka i zawiera ogólniejszą ocenę wadliwie obsadzonego organu. Wcześniejsza weryfikacja przeoczyła błąd dotyczący zasady prawnej. [SN — odpis w BIP RPO](https://bip.brpo.gov.pl/sites/default/files/2024-01/Postanowienie_SN_pytanie_prawne_wynagrodzenie_obrona_z_urzedu_13.12.2023_0.pdf). |
| 2 | 28.05.2024 — TK (3 sędziów) uznał uchwałę Sejmu z 6.03.2024 za niekonstytucyjną | ✅ | Potwierdzono datę, skład i sentencję, **U 5/24**, OTK ZU A/2024 poz. 65. To potwierdzenie treści orzeczenia, nie rozstrzygnięcie zastrzeżeń do kompetencji TK. [Informacja urzędowa TK za 2024, załącznik nr 3](https://trybunal.gov.pl/fileadmin/content/dokumenty/publikacje/informacje_o_problemach/TK_Informacja_2024.pdf). |
| 3 | 5.11.2024 — Jakubecki i Ślebzak informują RPO o skargach do ETPCz | ✅ | Potwierdzone w BIP RPO. Numery skarg: **22520/24** (Jakubecki) i **38940/23** (Ślebzak). Według pisma MSZ z 4.12.2024 skargi nie zostały jeszcze zakomunikowane rządowi. Doniesienie o pozwie Ślebzaka z grudnia 2025 r. nie jest objęte potwierdzeniem urzędowym w tym wierszu. [BIP RPO](https://bip.brpo.gov.pl/pl/content/rpo-etpc-niedopuszczeni-sedziowie-tk-msz), [odpowiedź MSZ](https://bip.brpo.gov.pl/pl/content/rpo-etpc-niedopuszczeni-sedziowie-tk-msz-odpowiedz), [Gazeta Prawna](https://www.gazetaprawna.pl/prawnik/orzecznictwo/artykuly/10956623,pozew-po-10-latach-wybrany-sedzia-tk-domaga-sie-pieniedzy.html) |
| 4 | 2.12.2024 — Przyłębska zrzeka się funkcji prezesa | ⚠️ | 2 grudnia to data publicznej informacji o rezygnacji; nie należy utożsamiać jej automatycznie z datą dokonania czynności. [Relacja z 2.12](https://notesfrompoland.com/2024/12/02/head-of-polish-constitutional-court-steps-down-and-prepares-to-elect-successor/). ➕ Powołanie Bogdana Święczkowskiego nastąpiło dokładnie **9.12.2024**, a nie „ok. 10.12”, jak podawała wcześniejsza wersja weryfikacji. [KPRP — akt powołania i uroczystość](https://k.prezydent.pl/kancelaria/archiwum/andrzej-duda/aktualnosci/nominacje/prezydent-powolal-bogdana-swieczkowskiego-na-prezesa-tk,95276). |
| 5 | 21.02.2025 — Sejm odrzuca kandydatury Asta i Kotowskiego | ✅ / ⚠️ | Potwierdzono bezpośrednio w API: Ast **173/224/13**, Kotowski **172/224/15**. Wyniki 180/230/10 i 181/229/10 dotyczą **9.05.2025**. W sprawdzonych danych Ast nie uzyskał wyboru czterokrotnie, Kotowski siedmiokrotnie, ostatnio w głosowaniu nad listą **4.09.2026**. [21.02 — Ast](https://api.sejm.gov.pl/sejm/term10/votings/29/78), [21.02 — Kotowski](https://api.sejm.gov.pl/sejm/term10/votings/29/79), [4.09.2026 — lista](https://api.sejm.gov.pl/sejm/term10/votings/64/14). Pełna tabela: [KryzysKonstytucyjny.md](KryzysKonstytucyjny.md), krok 29. |
| 6 | Luty 2025 — sędziowie TK bez wynagrodzenia; 6.05.2025 wyrok o budżecie, nieopublikowany | ⚠️ | Potwierdzono **K 2/25 z 6.05.2025**, obejmujący ograniczenia wydatków TK i KRS. [KRS — urzędowy wykaz z odnośnikiem do wyroku](https://krs.pl/pl/dzialalnosc/wyroki-tk/3019-wyroki-tk.html). Brak wypłaty za luty opiera się na wypowiedzi Pawłowicz przytoczonej przez [TVP Info](https://www.tvp.info/85578215/sedziowie-trybunalu-konstytucyjnego-bez-wyplaty-krystyna-pawlowicz-brak-slow); dokumentacji płacowej ani tezy „pierwszy raz w historii” nie zweryfikowano. Informacja o braku ogłoszenia dotyczy **Dziennika Ustaw**, nie samej dostępności tekstu w serwisach TK/KRS. |
| 7 | 29.07.2025 — wyrok Kp 3/24 (pełny skład) | ✅ / ⚠️ | Data, skład i połączenie z Kp 4/24 potwierdzone. Sentencja stwierdza niezgodność **wybranych przepisów**, a następnie nierozerwalny związek części z nich z całymi ustawami. Odmowa podpisania w następstwie kontroli prewencyjnej (art. 122 ust. 4) jest innym trybem niż weto (ust. 5). [TK — pełny tekst, OTK ZU A/2025 poz. 82](https://otkzu.trybunal.gov.pl/downloadOTK?mpo=48212). |
| 8 | 19.02.2026 — Nawrocki odmawia podpisania obu ustaw o TK | ❌ | **Pomylenie przedmiotu ustawy.** Urzędowy komunikat KPRP wymienia weto ustawy z 23.01.2026 o zmianie ustawy o **KRS i Kodeksu wyborczego** (druk 2108), nie ustaw o TK. Daty odrębnej odmowy podpisania ustaw o TK nie ustalono. [KPRP — decyzje z 19.02.2026](https://www.prezydent.pl/prawo/wnioski-do-tk/prezydent-rp-podpisal-dwie-ustawy-dwie-zawetowal,115305), [pisemny wniosek do Sejmu](https://www.prezydent.pl/storage/file/core_files/2026/5/11/cbf597a54b6338fb67cbb9d9dca89adb/Wniosek%20Prezydenta%20RP%20ws%20ustawy%20o%20zmianie%20ustawy%20o%20KRS%20oraz%20ustawy%20%E2%80%93%20Kodeks%20wyborczy%20%5Bdot%C4%99pno%C5%9B%C4%87%5D.pdf). |
| 9 | Pawłowicz w stanie spoczynku od 5.12.2025 | ✅ᴹ / ⚠️ | Potwierdzenie w [relacji Rzeczpospolitej z odejścia](https://www.rp.pl/sady-i-trybunaly/art43452061-sedzia-krystyna-pawlowicz-odchodzi-z-trybunalu-konstytucyjnego-zapadl-ostatni-wyrok). Termin zwykłego zakończenia kadencji przypadałby na 5.12.2028. Wcześniejszą datę uchwały Zgromadzenia Ogólnego („początek czerwca 2025”) usunięto jako nieustaloną w dokumencie źródłowym. |
| 10 | 18.12.2025 — TSUE C-448/23: TK nie jest niezawisłym sądem ustanowionym ustawą | ✅ / ⚠️ | Potwierdzone **w komunikacie nr 157/25**, nie w pełnym uzasadnieniu. TSUE uwzględnił skargę Komisji przeciwko Polsce dotyczącą także wyroków TK P 7/20 i K 3/21 z 2021 r. oraz naruszenia zasad prawa UE. Nieprawidłowości dotyczą wyboru trzech sędziów w grudniu 2015 i prezes TK w grudniu 2016. Ocena statusu TK odnosi się do wymogów prawa UE. [CURIA — komunikat PL](https://curia.europa.eu/jcms/upload/docs/application/pdf/2025-12/cp250157pl.pdf). |
| 11 | 13.03.2026 — Sejm wybiera sześcioro sędziów (w Wikipedii bez przypisu) | ✅ | Fakt i nazwiska potwierdza [urzędowe podsumowanie 53. posiedzenia Sejmu](https://www.sejm.gov.pl/sejm10.nsf/komunikat.xsp?documentId=2423F00CD1B28A44C1258DC000367A8A&symbol=KOMUNIKATY_KOMUNIKAT). Potwierdzenie wyboru nie rozstrzyga zarzutów proceduralnych. Większość bezwzględną określał art. 31 ust. 1 Regulaminu Sejmu, a nie art. 194 ust. 1 Konstytucji. |
| 12 | 1.04.2026 — ślubowanie Bentkowskiej i Szostka; 9.04.2026 — ślubowanie w Sejmie | ✅ / ⚠️ | Daty potwierdzone. 9 kwietnia ślubowanie w Sejmie złożyło **sześcioro**, w tym Bentkowska i Szostek ponownie. Nie należy sugerować, że uczestniczyło wyłącznie czworo. [Sejm — komunikat 9.04.2026](https://www.sejm.gov.pl/sejm10.nsf/komunikat.xsp?documentId=6B3DF195E108B7FFC1258DD400430C99&symbol=M_WYDARZENIA_KOMUNIKAT). Skuteczność procedury pod nieobecność prezydenta pozostaje przedmiotem sporu. |
| 13 | 13.10.2026 — opinia Komisji Weneckiej o ślubowaniu | ✅ / ⚠️ | **CDL-AD(2026)031** przyjęto na 148. sesji 9–10 października; 13 października to data dokumentu. Potwierdzono w pełnym tekście. Opinia jest stanowiskiem doradczym. [Komisja Wenecka — dokument](https://rm.coe.int/poland-opinion-on-the-powers-of-the-president-in-the-context-of-the-oa/48802e450a). |
| 14 | 30.10.2026 — przerwy w czynnościach Święczkowskiego i Sochańskiego, ogłoszenie kierowania TK przez Korwin-Piotrowską | ✅ / ⚠️ | W audycie nowego pliku odczytano dokumenty bezpośrednio w serwisie TK: [zarządzenie dotyczące Święczkowskiego](https://trybunal.gov.pl/fileadmin/content/uroczystosci_spotkania_wizyty/2026/2026_10_30/Z2.pdf), [dotyczące Sochańskiego](https://trybunal.gov.pl/fileadmin/content/uroczystosci_spotkania_wizyty/2026/2026_10_30/Z1.pdf), [informację o podstawach działania](https://trybunal.gov.pl/fileadmin/content/uroczystosci_spotkania_wizyty/2026/2026_10_30/Informacja_w_sprawie_zarzadzenia_przerwy_w_czynnosciach_sluzbowych_sedziow_TK_Bogdana__Swieczkowskiego_i_Bartlomieja_Sochanskiego.pdf). Potwierdza to wydanie dokumentów, nie ich sporną skuteczność. Datę 30 października ustalono z zarządzeń; metryka strony zawiera niespójną datę „21 X 2026”. Dalsze etapy SN: 6 listopada przekazanie sprawy do TK, 10 listopada uchylenie wcześniejszego postanowienia, a następnie obu zarządzeń — [relacja RDC](https://www.rdc.fm/aktualnosci/polska/co-z-sedziami-swieczkowskim-i-sochanskim-sad-najwyzszy-oglosil-ze-uchyla-zarzadzenia-w-ich-sprawie_L2Pfc1aPDpaMijCFo1PS). Pełnych postanowień SN nie odczytano. |

---

## 3. Zdarzenia z 2026 r., których brakuje w rewizji Wikipedii (➕)

| Data | Zdarzenie | Źródło |
|---|---|---|
| 13.04.2026 (relacja z 14.04) | Prokurator Generalny poleca wszczęcie śledztwa w sprawie pomocnictwa do niedopełnienia obowiązków i nadużycia uprawnień w związku ze sporem o ślubowanie; artykuł z 14 kwietnia cytuje komunikat prokuratury z 13 kwietnia. Data publikacji artykułu nie jest datą polecenia | [Notes from Poland](https://notesfrompoland.com/2026/04/14/polish-justice-minister-orders-criminal-investigation-into-presidential-advisors-over-judge-dispute/) |
| **30.04.2026; 5.05.2026** | Czworo sędziów, od których prezydent nie przyjął ślubowania, występuje do ETPCz; 5 maja ETPCz wskazuje środek tymczasowy dotyczący nieutrudniania objęcia i wykonywania obowiązków. To nie wyrok kończący sprawę. Daty według urzędowej opinii KW; nie odczytano odrębnie decyzji ETPCz | [CDL-AD(2026)031, pkt 25](https://rm.coe.int/poland-opinion-on-the-powers-of-the-president-in-the-context-of-the-oa/48802e450a) |
| **12.05.2026** | **K 3/26:** TK uznaje określone rozumienie art. 4 ust. 1 ustawy o statusie sędziów TK, nakładające na prezydenta obowiązek odebrania ślubowania, za niekonstytucyjne. **Pozostałe zarzuty umorzono**, więc twierdzenie o sentencji uznającej procedurę wyboru za niekonstytucyjną było błędne. Wcześniejsza weryfikacja pomyliła datę wyroku z datą relacji prasowej; por. [KryzysKonstytucyjny.md](KryzysKonstytucyjny.md), krok 36 | [TK — sentencja](https://trybunal.gov.pl/postepowanie-i-orzeczenia/wyroki/art/zasady-i-tryb-wyboru-sedziego-trybunalu-konstytucyjnego-3) |
| **11.06.2026** | Sejm wybiera **Sławomira Patyrę**; datę i wynik 235/184/5 potwierdza przebieg prac. Uchwała: M.P. 2026 poz. 603 | [Sejm — druk 2619](https://www.sejm.gov.pl/sejm10.nsf/PrzebiegProc.xsp?nr=2619) |
| 28.07.2026 | Prezydent przyjmuje ślubowanie od Patyry (✅). Zapowiedź odmowy orzekania do czasu dopuszczenia czworga innych sędziów potwierdza prasa (✅ᴹ) | [KPRP — ślubowanie](https://www.prezydent.pl/aktualnosci/nominacje/slubowanie-sedziego-trybunalu-konstytucyjnego,123825), [Notes from Poland 29.07](https://notesfrompoland.com/2026/07/29/newly-sworn-in-judge-of-polands-constitutional-court-stages-boycott-over-blocked-colleagues/) |
| 4.09.2026 | Sejm wybiera **Macieja Berka**. Potwierdzenie wyboru nie rozstrzyga sporu o wymagany staż zawodowy | [Sejm — druk 3006](https://www.sejm.gov.pl/Sejm10.nsf/PrzebiegProc.xsp?nr=3006), [Notes from Poland](https://notesfrompoland.com/2026/09/04/prime-ministers-right-hand-man-elected-as-polish-constitutional-court-judge/) |
| 14.10.2026 | Berek składa ślubowanie w Sejmie pod nieobecność prezydenta. To piąta osoba, od której prezydent nie przyjął ślubowania, a nie piąty uczestnik sejmowej ceremonii — 9 kwietnia uczestniczyło sześcioro | [Sejm — komunikat po ślubowaniu](https://www.sejm.gov.pl/sejm10.nsf/komunikat.xsp?documentId=2D8D06C7149A1BF4C1258E90002DBD9A&symbol=KOMUNIKATY_KOMUNIKAT), [OKO.press](https://oko.press/berek-zlozyl-slubowanieale-pat-w-trybunale-konstytucyjnym-trwa) |

**Konsekwencja dla chronologii:** Wikipedia przechodzi od opinii Komisji Weneckiej (13.10.2026) od razu do 30.10.2026. Pomija wybór i ślubowanie Berka. Nie przesądza to legalności późniejszego ogłoszenia przejęcia kierowania TK. Tekst rewizji sprawdzono przez API MediaWiki: nie zawiera nazwisk Patyry ani Berka. Wybrane uzupełnienia z tej tabeli dodano do chronologii i oznaczono jako weryfikacyjne.

---

## 4. Dodatkowe błędy i nieprecyzyjności ujawnione w audycie obu plików

| Miejsce | Ustalenie i korekta | Podstawa |
|---|---|---|
| Analiza, „Wybór sędziów zwykłą większością (art. 194 ust. 1)” | Błąd opracowania: art. 194 ust. 1 nie określa większości. Dla wyboru z marca 2026 Regulamin Sejmu przewidywał większość **bezwzględną** | [Regulamin, art. 31 ust. 1](https://eli.gov.pl/eli/MP/2022/990/ogl), [Konstytucja, art. 194](https://eli.gov.pl/eli/DU/1997/483/ogl) |
| Ślubowanie 2026, „art. 21 ust. 1 ustawy o statusie sędziów TK” | Błąd Wikipedii powtórzony w chronologii: właściwy jest **art. 4 ust. 1 ustawy z 2016 r.**; art. 21 dotyczył ustawy z 2015 r. | [Ustawa z 2016 r., Dz.U. poz. 2073](https://eli.gov.pl/eli/DU/2016/2073/ogl) |
| K 34/15 | Sentencja kontrolowała **art. 137 ustawy**, nie indywidualne uchwały o wyborze. Poprawiono skrót sugerujący bezpośrednie orzekanie o ważności wyboru | [Dz.U. 2015 poz. 2129 — sentencja, pkt 8](https://api.sejm.gov.pl/eli/acts/DU/2015/2129/text.html) |
| Ustawy z 2024 r. | 6 marca: wniesienie projektów; 24 lipca: uchwalenie; 13 września: rozpatrzenie poprawek Senatu. Nie unieważniano wszystkich wyroków po 2016 r., lecz określone orzeczenia związane z wadliwym składem | [Sejm, druk 253](https://www.sejm.gov.pl/sejm10.nsf/PrzebiegProc.xsp?nr=253), [Kp 3/24 — opis przepisów wprowadzających](https://otkzu.trybunal.gov.pl/downloadOTK?mpo=48212) |
| K 39/16 | Skrót „9 z 10 zaskarżonych przepisów” zastąpiono opisem bez tej liczby. Chodzi o 9 punktów sentencji stwierdzających niezgodność i jeden punkt interpretacyjny stwierdzający zgodność; zakresy kontroli obejmowały więcej przepisów | [Dz.U. 2018 poz. 1078 — sentencja](https://api.sejm.gov.pl/eli/acts/DU/2018/1078/text.html) |
| Publikacja 5.06.2018 | 818 dni dotyczy **K 47/15**. Dla K 39/16 było to 663 dni, a K 44/16 — 575 dni. Wyliczono różnice dat kalendarzowych | Metadane ELI z tabeli 1 |
| Licencja chronologii | Nota we wstępie nie obejmowała wyraźnie analizy własnej, choć repozytoryjny rejestr obejmuje licencją **CC BY-SA 4.0 cały plik**. Ujednolicono notę | [LICENCJE.md](../LICENCJE.md) |

## 5. Okres 2015–2023 — granice dalszej weryfikacji

Poniższe pozycje nie zostały objęte pełnym ponownym sprawdzeniem. Sama obecność przypisu do dokumentu urzędowego nie jest potwierdzeniem treści zdania:

- zalecenia KE (UE) 2016/1374 (27.07.2016), 2017/146, 2017/1520, 2018/103 oraz wniosek z art. 7 ust. 1 TUE (20.12.2017),
- opinia Komisji Weneckiej z 14.10.2016 (opinię z 11.03.2016 **sprawdzono** w pełnym tekście: [CDL-AD(2016)001](https://www.venice.coe.int/webforms/documents/default.aspx?pdffile=CDL-AD(2016)001-e), zwłaszcza pkt 121–124 i 135–140),
- wyroki TK: K 1/17 (24.10.2017), K 12/18 (25.03.2019), U 2/20 (20.04.2020), K 6/21 (24.11.2021),
- pełne uzasadnienie wyroku ETPCz *Xero Flor* (4907/18, 7.05.2021); datę i podstawowy wynik potwierdza [materiał urzędowy ETPCz, s. 120](https://www.echr.coe.int/documents/d/echr/ceeli-2024-a_guide_to_protecting_the_rule_of_law_in_the_european_courts),
- wybór Przyłębskiej na prezesa TK (21.12.2016), Piskorskiego (15.09.2017) i Wyrembaka (styczeń 2018).

---

## 6. Wynik i zakres potwierdzenia

- **17/17 aktów:** potwierdzono daty aktów i publikacji w API Sejmu. To kontrola metadanych, nie pełna ocena treści historycznej i prawnej.
- **Metryka Wikipedii:** potwierdzono numer rewizji, tytuł i datę; nie przeprowadzono pełnego audytu wszystkich 381 opisów przypisów.
- **Błędy Wikipedii powtórzone w opracowaniu:** pomylone weto ustawy o KRS, nieprawidłowa moc zasady prawnej I KZP 5/23 i błędny numer przepisu o ślubowaniu. Korekty opisano wyżej i wprowadzono do chronologii.
- **Błędy opracowania i wcześniejszej weryfikacji:** m.in. zwykła zamiast bezwzględnej większości, 13 zamiast 12 maja 2026, nadinterpretacja sentencji K 3/26, niedokładna data powołania Święczkowskiego oraz pomylenie kolejnych etapów postępowania SN ze sprzecznymi relacjami.
- **Uzupełnienia:** tabela 3 zawiera **7 pozycji dotyczących 2026 r.**; odrębnie uzupełniono powołanie prezesa z 9 grudnia 2024. Nie sumuje się ocen z tabeli 2 jako liczby zweryfikowanych faktów, ponieważ wiersze obejmują po kilka twierdzeń o różnym stopniu potwierdzenia.

Nie ma podstaw do wcześniejszego wniosku, że całe lata 2015–2018 opisano rzetelnie wyłącznie na podstawie zgodności 17 dat. Pozostałe ograniczenia obejmują pełne uzasadnienia części orzeczeń, dokumentację wypłat i sporne skutki prawne działań z 2026 r. Informacje o terminach posiedzeń 19–20 listopada 2026 są na datę audytu **zapowiedziami**, nie zdarzeniami dokonanymi.


## 7. Audyt KryzysKonstytucyjny.md

**Data: 16 listopada 2026.** Sprawdzono nowy opis [42 kroków w sześciu etapach](KryzysKonstytucyjny.md) i podsumowanie źródeł. W API Sejmu ponownie odczytano **51 metryk aktów, 42 wyniki głosowań i dziewięć procesów legislacyjnych**; ponadto kompletne roczniki Dz.U. i M.P. za lata 2022–2026. Dla każdej z dziesięciu odpowiedzi rocznikowych sprawdzono równość `count`, `totalCount` i liczby `items` — łącznie **17 415 rekordów**, bez pominiętej paginacji. Nie jest to pełne sprawdzenie wszystkich ocen prawnych i informacji oznaczonych D1/D2.

### Potwierdzone zestawienie publikacji

Wybrano rekordy z tytułem zaczynającym się od `Wyrok Trybunału Konstytucyjnego`; typ rekordu w API to `Orzeczenie`, a nie `Wyrok`. Zlicza się rok **publikacji**, nie rok wydania wyroku. Ostatni rok obejmuje okres do dnia audytu.

| Rok publikacji | Dz.U. | M.P. | Razem |
|---|---|---|---|
| 2022 | [14](https://api.sejm.gov.pl/eli/acts/DU/2022) | [0](https://api.sejm.gov.pl/eli/acts/MP/2022) | 14 |
| 2023 | [24](https://api.sejm.gov.pl/eli/acts/DU/2023) | [1](https://api.sejm.gov.pl/eli/acts/MP/2023) | 25 |
| 2024 | [3](https://api.sejm.gov.pl/eli/acts/DU/2024) | [0](https://api.sejm.gov.pl/eli/acts/MP/2024) | 3 |
| 2025 | [0](https://api.sejm.gov.pl/eli/acts/DU/2025) | [0](https://api.sejm.gov.pl/eli/acts/MP/2025) | 0 |
| 2026 do 16.11 | [0](https://api.sejm.gov.pl/eli/acts/DU/2026) | [0](https://api.sejm.gov.pl/eli/acts/MP/2026) | 0 |

Ostatni znaleziony wyrok ogłoszono **4.03.2024**: [SK 90/22 z 27.02.2024, Dz.U. poz. 300](https://api.sejm.gov.pl/eli/acts/DU/2024/300). Wcześniejsze dwie publikacje w 2024 r. to Dz.U. poz. 95 i 96, obie z 26 stycznia. Zestawienie dotyczy Dz.U./M.P.; wyroki nadal udostępniano w OTK ZU i serwisach TK.

### Korekty i doprecyzowania

| Miejsce | Wynik audytu |
|---|---|
| Wstęp: „zwykła większość” | Poprawiono na **bezwzględną**. Dane API dla wyborów z marca i września 2026 zawierają `majorityType=ABSOLUTE_MAJORITY`; art. 194 Konstytucji sam nie określa większości. |
| Krok 2: 19.11.2015 „w dniu pierwszego posiedzenia” | Chodzi o **piąty dzień pierwszego posiedzenia**, rozpoczętego 12 listopada, nie pierwszy dzień obrad. |
| Krok 7 i stan po etapie I | K 34/15 kontrolował art. 137 ustawy, nie indywidualne uchwały. Wybór trzech osób w grudniu 2015 nie oznaczał jeszcze dopuszczenia ich do orzekania; nastąpiło ono w grudniu 2016. |
| Krok 12: Jędrzejewski | Wynik 227 za / 0 przeciw / 227 niegłosujących był niepełny: **sześć osób się wstrzymało**. [API 16/61](https://api.sejm.gov.pl/sejm/term8/votings/16/61). |
| Krok 14: K 39/16 i K 44/16 | Rozdzielono przedmioty spraw: K 39/16 stwierdza niekonstytucyjność m.in. dopuszczenia osób wybranych na zajęte miejsca; K 44/16 stwierdza zgodność badanych regulacji o przedstawianiu kandydatów na prezesa w określonym zakresie i rozumieniu. [K 44/16 — sentencja](https://api.sejm.gov.pl/eli/acts/DU/2018/1079/text.pdf). |
| Krok 28: Przyłębska i Święczkowski | Data **29.11.2024** rzeczywiście występuje w [uchwale Sejmu, M.P. 2026 poz. 299](https://api.sejm.gov.pl/eli/acts/MP/2026/299/text.pdf). To świadectwo treści uchwały; nie dokument rezygnacji Przyłębskiej i nie zaprzeczenie ogłoszenia rezygnacji 2 grudnia. Powołanie Święczkowskiego potwierdza [KPRP: 9.12.2024](https://k.prezydent.pl/kancelaria/archiwum/andrzej-duda/aktualnosci/nominacje/prezydent-powolal-bogdana-swieczkowskiego-na-prezesa-tk,95276). |
| Kroki 29 i 38: liczba głosowań | Tabela zawierała sześć dat, a tekst mówił o pięciu. Ponadto pominięto nieudaną kandydaturę Kotowskiego **4.09.2026**: łącznie Kotowski **siedem**, Ast **cztery**. W głosowaniu nad listą Berek otrzymał 226, Kotowski 184, a 27 posłów było przeciw wszystkim. Nie należy mylić głosów na konkurenta z głosami przeciw Berkowi. [API 64/14](https://api.sejm.gov.pl/sejm/term10/votings/64/14). |
| Krok 30: budżet 2026 | Wniosek Prezydenta to **K 1/26**, a **K 4/26** to wniosek KRS, połączony z pierwszym. Potwierdza [urzędowy zapis Komisji Ustawodawczej](https://www.sejm.gov.pl/sejm10.nsf/biuletyn.xsp?documentId=5840B8E9FCF0A84CC1258E7B0046DCC4), dostępny w indeksowanej treści. Daty wpływu 4 lutego i aktualnego statusu połączonej sprawy nie potwierdzono ponownie. |
| Krok 31: Kp 3/24 | Sentencja obejmuje art. 12 **ust. 2 i 3**, nie cały art. 12 ustawy wprowadzającej. Nierozerwalny związek z ustawą o TK dotyczy tylko przepisów z części I pkt 1 i 4; dla ustawy wprowadzającej — części III. Potwierdzono cytat o obowiązku odmowy podpisania obu ustaw. [Pełny wyrok](https://otkzu.trybunal.gov.pl/downloadOTK?mpo=48212). |
| Krok 34: ślubowanie 9.04.2026 | Komunikat Sejmu mówi o **sześciorgu**, w tym Bentkowskiej i Szostku ślubujących ponownie. Jest źródło urzędowe, więc oznaczenie wyłącznie D1/D2 zastąpiono odnośnikiem do komunikatu. |
| Kroki 35–36: Kpt 1/26 i K 3/26 | Potwierdzono metrykę Kpt 1/26: wpływ 27.04.2026, stan metryki 23.07.2026, oznaczenie „w toku”. K 3/26: **12.05.2026**, zarzuty poza wykładnią art. 4 ust. 1 umorzono. Synteza błędnie wyłączała Konstytucję ze sporu, choć wzorcami kontroli są art. 126 i art. 2. |
| Kroki 37–39: Patyra, Berek, Komisja Wenecka | Uzupełniono bezpośrednie źródła urzędowe: **KPRP — ślubowanie Patyry 28.07**, **Sejm — ślubowanie Berka 14.10**, **KW — opinia przyjęta 9–10.10, dokument z 13.10**. Dawne ograniczenie „wyłącznie pliki lokalne” jest nieaktualne. |
| Kroki 40–42: kierownictwo TK | Odczytano oba zarządzenia z 30.10 w serwisie TK. Potwierdzono uchwałę ZO nr 1/2026, podpis A. Korwin-Piotrowskiej, publikację **10.11** i wejście w życie **11.11**. Jest to pierwsza znaleziona publikacja aktu TK/ZO w Dz.U./M.P. po 4.03.2024, nie pierwszy dokument tych osób. Publikacja nie rozstrzyga sporu o legalność kierownictwa. Pełnych postanowień SN nadal nie odczytano. |
| Synteza: „cztery uchwały” | Cztery podane **daty** obejmują **12 uchwał**: 5 + 5 + 1 + 1. Poprawiono też liczbę nieudanych kandydatur i opis uchwał Sejmu, który sugerował bezsporne unieważnienie wyborów. |

Zachowano 42 kroki i sześć etapów. Pozostałe informacje oparte wyłącznie na D1/D2 nadal są tak oznaczone. Linki do uzupełniających dokumentów zebrano przy odpowiednich krokach i w przypisach nowego pliku; nie wydaje się ogólnej oceny legalności działań spornych organów.
