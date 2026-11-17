# Przygotowanie testu ciągłości TK

Wygenerowano: 2026-11-16, przez `tk_test przygotuj` (Lean). **Bez wyników testu historycznego.**

## Walidacja

Wiersze: 136; wybory: 47; błędy: 0; ostrzeżenia: 0.

## Kompletność danych

| kategoria | ustalone | wszystkie |
| --- | --- | --- |
| D1 wakat zamierzony | 29 | 47 |
| D1 początek kadencji w uchwale | 20 | 47 |
| D1 wynik głosowania | 31 | 47 |
| D3 ślubowanie lub odmowa | 18 | 47 |
| D5 ZO: lista obecnych | 1 | 4 |
| D6 skład orzeczenia | 5 | 10 |
| D6 wynik głosowania | 4 | 10 |
| D10 dopuszczenie udokumentowane | 8 | 47 |

## Założenia danych (robocze)

| id | treść | włączone |
| --- | --- | --- |
| AD1 | zdarzenia E6 spoza rejestru nie występują | tak |
| AD2 | osoby bez E3 i bez ślubowania innej formy złożyły ślubowanie wobec Prezydenta w późniejszym z dni wyboru i początku kadencji | tak |
| AD3 | osoby bez E3 i E4 dopuszczono w dniu ślubowania | tak |
| AD4 | brak daty początku kadencji: faktyczny początek liczony od wyboru | tak |
| AD5 | osoby spoza sporu zakończyły funkcję z faktycznym końcem kadencji, jeżeli brak późniejszych E5 | tak |
| AD6 | postanowienia E7 są kompletne w oknie badania | tak |
| AD7 | osoby z E3 bez E4 nie wykonywały funkcji przed pierwszym udokumentowanym E5 | tak |

## Warianty

| moduł | nominalnie | po utożsamieniu 4.6 |
| --- | --- | --- |
| M1 | 216 | 192 |
| M2 | 31104 | 27648 |
| M3 | 1990656 | 1769472 |
| M4 | 1 | 1 |

Alternatywy A: 4; M3 × A: 7077888. Liczby przed uzupełnieniami niepewności.

## Ustalenia robocze o danych

- hauser: początek w uchwale 2015-11-07, wakat według modelu 2015-11-06. Konwencja dat wymaga decyzji recenzenta.
- slebzak: początek w uchwale 2015-11-07, wakat według modelu 2015-11-06. Konwencja dat wymaga decyzji recenzenta.
- jakubecki: początek w uchwale 2015-11-07, wakat według modelu 2015-11-06. Konwencja dat wymaga decyzji recenzenta.
- sitek: początek w uchwale 2015-12-03, wakat według modelu 2015-12-02. Konwencja dat wymaga decyzji recenzenta.
- sokala: początek w uchwale 2015-12-09, wakat według modelu 2015-12-08. Konwencja dat wymaga decyzji recenzenta.
- przylebska: początek w uchwale 2015-12-09, wakat według modelu 2015-12-08. Konwencja dat wymaga decyzji recenzenta.
- pszczolkowski: początek w uchwale 2015-12-03, wakat według modelu 2015-12-02. Konwencja dat wymaga decyzji recenzenta.
- jedrzejewski: początek w uchwale 2016-04-28, wakat według modelu 2016-04-27. Konwencja dat wymaga decyzji recenzenta.
- warcinski: początek w uchwale 2016-12-20, wakat według modelu 2016-12-19. Konwencja dat wymaga decyzji recenzenta.
- Stan wyjściowy według roboczych AD: F = 16. Nie jest to ustalenie o TK. Rejestr zawiera lukę dotyczącą odejścia L. Bagińskiej.
- Wakat nieustalony: 18 wyborów (granat, jedrejek, zielonacki, sych, pawlowicz, piotrowicz, stelina, wojciechowski, sochanski, swieczkowski, bentkowska, dziurda, korwin, markiewicz, szostek, taborowski, patyra, berek).
- Do uzupełnienia: ślubowania, protokoły ZO, orzeczenia i akty D11, w tym zmiana ustawy Dz.U. 2026 poz. 26.

## Pokrycie i ograniczenia

- W1: wiedza prawnicza — ocenne, poza obliczeniem
- W1: zakaz ponownego wyboru — rejestr nie obejmuje wyborów sprzed 2006 r.
- W2: odrębne głosowanie nad uchwałą ZO — D11 nie wczytane
- W5: art. 131 ust. 1 — poza zakresem
- W6a: ostateczność orzeczeń — brak kompletnego modelu kwestionowania
- Z11a/Z12b: akty D11 nie wczytane; wyniki NIEUSTALONE
- Z11b: kworum składów NIEPOKRYTE
- F1 (osiągalność), F3, F5, F7, F8: otwarte; metoda liczników jest przybliżeniem przedziałowym

## Dalsze prace

Zatwierdzenie parametrów Z1–Z14, R-PUB, AD1–AD7 i konwencji dat przez prawnika. Kontrole formalne otwarte pozostają otwarte po migracji. Obliczenia: `./oblicz_tk.sh`.
