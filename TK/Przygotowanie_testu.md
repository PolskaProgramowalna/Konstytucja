# Przygotowanie testu ciągłości TK

Wygenerowano: 2026-11-16 przez `LEAN/dane/tk_test.py przygotuj` na podstawie `LEAN/dane/tk_rejestr.csv`. Dokument opisuje stan narzędzi i danych (plan_tk.txt, pkt 10, prace 1–4). **Nie zawiera wyników testu**: obliczenia historyczne wymagają zatwierdzenia parametrów i reguły R-PUB.

## 1. Walidacja rejestru (krok 1, kontrola F2)

- wiersze: 136, osoby z wyborem (E1): 47
- błędy: 0
- ostrzeżenia: 0

## 2. Kompletność danych (pkt 6)

| kategoria | ustalone | wszystkie | udział |
|---|---|---|---|
| D1 wakat zamierzony | 29 | 47 | 62% |
| D1 początek kadencji w uchwale | 20 | 47 | 43% |
| D1 wynik głosowania | 31 | 47 | 66% |
| D3 ślubowanie lub odmowa | 18 | 47 | 38% |
| D5 ZO: lista obecnych | 1 | 4 | 25% |
| D6 skład orzeczenia | 5 | 10 | 50% |
| D6 wynik głosowania | 4 | 10 | 40% |
| D10 dopuszczenie (E4) udokumentowane | 8 | 47 | 17% |

## 3. Założenia danych AD (jawne, przełączalne)

| id | treść | włączone |
|---|---|---|
| AD1 | zdarzenia E6 spoza rejestru nie występują | tak |
| AD2 | osoby bez E3 złożyły ślubowanie wobec Prezydenta w dniu wyboru albo w dniu początku kadencji z uchwały (późniejszym) | tak |
| AD3 | osoby bez E3 i bez E4 zostały dopuszczone do funkcji w dniu ślubowania | tak |
| AD4 | gdy uchwała nie podaje początku kadencji, a dane nie wskazują wakatu, faktyczny początek liczony od dnia wyboru | tak |
| AD5 | osoby spoza sporu zakończyły funkcję z faktycznym końcem kadencji, jeżeli brak E5 po tym dniu | tak |
| AD6 | postanowienia E7 w oknie badania są w rejestrze kompletne | tak |

Każde AD zastępuje brakującą daną. Wyłączenie AD daje w odpowiednich miejscach wynik NIEUSTALONY (P4). AD nie są parametrami interpretacji Konstytucji.

## 4. Warianty (pkt 5.1)

| moduł | parametry (dep) | nominalnie | po F1 (utożsamienia 4.6) |
|---|---|---|---|
| M1 | z1, z2, z4, z7, z12 | 216 | 192 |
| M2 | dep(M1) ∪ z3c, z3q, z3m, z5, z5z, z8 | 31104 | 27648 |
| M3 | dep(M2) ∪ z6, z9, z10, z11, z13, z14 | 1990656 | 1769472 |
| M4 | - | 1 | 1 |

Alternatywy danych A (przyporządkowania wakatów, po utożsamieniu wakatów nierozróżnialnych): 4. Łącznie do przeglądu: M3 × A = 7 077 888.

## 5. Ustalenia z danych istotne dla parametrów

- Konwencja dat (L2, pkt 4.5): daty początku kadencji w uchwałach Sejmu są o jeden dzień późniejsze od pierwszego dnia wakatu liczonego przedziałami półotwartymi od daty początku kadencji poprzednika z jego uchwały: hauser: uchwała 2015-11-07, pierwszy dzień wakatu 2015-11-06; jakubecki: uchwała 2015-11-07, pierwszy dzień wakatu 2015-11-06; jedrzejewski: uchwała 2016-04-28, pierwszy dzień wakatu 2016-04-27; przylebska: uchwała 2015-12-09, pierwszy dzień wakatu 2015-12-08; pszczolkowski: uchwała 2015-12-03, pierwszy dzień wakatu 2015-12-02; sitek: uchwała 2015-12-03, pierwszy dzień wakatu 2015-12-02; slebzak: uchwała 2015-11-07, pierwszy dzień wakatu 2015-11-06; sokala: uchwała 2015-12-09, pierwszy dzień wakatu 2015-12-08; warcinski: uchwała 2016-12-20, pierwszy dzień wakatu 2016-12-19. Praktyka uchwał odpowiada przedziałom domkniętym [początek, początek + 9 lat]. Plan (4.5) przyjmuje przedziały półotwarte; różnica może mieć znaczenie dla H1 i H5 i wymaga decyzji recenzenta.
- Stan wyjściowy (T2): miejsca pomocnicze z wyborów 2006–2012 bez wskazanego poprzednika: 15 (gintowt, hermelinski, kotlinowski, cieslak, baginska, liszcz, rzeplinski, biernat, wronkowska, rymar, tuleja, zubik, pyziak, wrobel, kieres). W dniu 2015-10-01 licznik osób w funkcji F = 16. Wynik powyżej 15 wynika z braku w rejestrze zdarzenia kończącego funkcję L. Bagińskiej (wybór 8.12.2006) albo z innego braku danych sprzed 2015 r.; nie jest to ustalenie o stanie TK.
- Wakat nieustalony w dokumentach (D1): 18 wyborów (granat, jedrejek, zielonacki, sych, pawlowicz, piotrowicz, stelina, wojciechowski, sochanski, swieczkowski, bentkowska, dziurda, korwin, markiewicz, szostek, taborowski, patyra, berek). Dla nich S2, S4 i tytuł są NIEUSTALONE. Uzupełnienie wymaga dokumentu wskazującego poprzednika (np. uzasadnienia, druku sejmowego, komunikatu TK) albo listy kandydujących wakatów do przeglądu alternatyw A.
- Uchwały Sejmu z 2026 r. o wyborze sędziów powołują się na ustawę o statusie sędziów TK „z 2018 r. poz. 1422 oraz z 2026 r. poz. 26” - zmiana ustawy z 2026 r. nie jest jeszcze w rejestrze aktów D11.

## 6. Warunki NIEPOKRYTE (P8)

- W1: zakaz ponownego wyboru - rejestr nie obejmuje wyborów sprzed 2006 r.
- W1: kryterium „wiedzy prawniczej” - ocenne, poza obliczeniem
- W2: odrębne głosowanie nad uchwałą ZO - wymóg ustawowy (P2), reguła nie wczytana
- W5: art. 131 ust. 1 - poza zakresem testu
- W6a: ostateczność orzeczeń - brak danych o kwestionowaniu
- Z11b: kworum i liczebność składów (gdy wybrany wariant b)
- Z12b: reguły ustawy i regulaminu Sejmu (D11) - nie wczytane, wynik NIEUSTALONY

## 7. Co dalej

1. Uzupełnić dane: wakaty wyborów oznaczonych `?`, ślubowania (D3), protokoły ZO z listami obecnych (D5), składy i wyniki głosowania orzeczeń (D6), akty D11.
2. Recenzja prawnika: parametry Z1–Z14, R-PUB, założenia AD1–AD6 i konwencja dat (pkt 5 niniejszego raportu).
3. Po zatwierdzeniu: `python3 tk_test.py oblicz --roboczo` (pełny przegląd, ok. 2–3 min) i zapis do `TK/Wynik_testu_ciaglosci.md`.

