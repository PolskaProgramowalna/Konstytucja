# Licencje

Projekt używa dwóch licencji: Apache 2.0 dla kodu i CC BY 4.0 dla dokumentów i danych. Opracowania oparte na Wikipedii są wyjątkiem i mają licencję CC BY-SA 4.0. Tekst Konstytucji i pliki źródłowe nie są objęte licencjami projektu.

Copyright 2026 autorzy projektu Konstytucja.

| Zakres | Licencja |
| --- | --- |
| `LEAN/Konstytucja/`, `LEAN/Konstytucja.lean`, `LEAN/Skrypty/`, `LEAN/dane/generuj.py`, `LEAN/sprawdź.sh`, `LEAN/lakefile.toml`, `LEAN/lean-toolchain`, `LEAN/lake-manifest.json`, `tk_test.sh`, `oblicz_tk.sh`, `.github/` | [Apache 2.0](LICENSE) |
| `CZYTAJ.md`, `METODOLOGIA.md`, `LICENCJE.md`, `plan.txt`, `LEAN/docs/`, `LEAN/dane/CZYTAJ.txt`, `inne/*.md` | [CC BY 4.0](LICENSE-CC-BY-4.0.txt) |
| `LEAN/dane/` poza tekstem Konstytucji: `rejestr.csv`, `warianty.csv`, `pojecia.csv`, `klauzule.csv`, `pokrycie.csv`, `pokrycie_przepisy.csv` | [CC BY 4.0](LICENSE-CC-BY-4.0.txt) |
| `TK/Weryfikacja_Chronologii.md`, `TK/Weryfikacja_planu_tk.md`, `TK/Przygotowanie_testu.md`, `plan_tk.txt`, `plan_tk_etap_1.txt`, `LEAN/dane/tk_rejestr.csv` | [CC BY 4.0](LICENSE-CC-BY-4.0.txt) |
| `TK/KryzysKonstytucyjny.md` | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.pl) — korzysta z `TK/Chronologia_Kryzysu.md`; dokumenty urzędowe, które cytuje, nie są przedmiotem prawa autorskiego (art. 4 ustawy o prawie autorskim) |
| `TK/Chronologia_Kryzysu.md` | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.pl) — patrz niżej |

## Materiały oparte na Wikipedii (CC BY-SA 4.0)

`TK/Chronologia_Kryzysu.md` streszcza i przeredagowuje artykuł Wikipedii [„Kryzys wokół Trybunału Konstytucyjnego w Polsce”](https://pl.wikipedia.org/w/index.php?oldid=81177984) w wersji nr 81177984 z 11 listopada 2026. Autorami artykułu są redaktorzy Wikipedii, wymienieni w [historii edycji](https://pl.wikipedia.org/w/index.php?title=Kryzys_wok%C3%B3%C5%82_Trybuna%C5%82u_Konstytucyjnego_w_Polsce&action=history). Treść Wikipedii ma licencję CC BY-SA 4.0, więc ten plik jako utwór zależny też jest na tej licencji, także w części z analizą własną. Kto rozpowszechnia ten plik albo utwór na nim oparty, musi:

- podać autorstwo i źródło: artykuł Wikipedii, jego wersję i link do historii edycji,
- zaznaczyć, że wprowadzono zmiany,
- udostępnić utwór na tej samej licencji (CC BY-SA 4.0 albo zgodnej).

Opisy bibliograficzne w przypisach pochodzą z tego samego artykułu. Dokumenty, do których prowadzą, mają własny status prawny. Nowe pliki oparte na Wikipedii wpisuj do tabeli powyżej z licencją CC BY-SA 4.0.

## Poza licencjami projektu

- **Tekst Konstytucji:** w tym `LEAN/dane/artykuly.txt`, kolumna tekstu w `LEAN/dane/przepisy.csv` oraz cytaty z przepisów w innych plikach. Akty normatywne nie są przedmiotem prawa autorskiego (art. 4 ustawy o prawie autorskim i prawach pokrewnych).
- **`Sejm/` i `Senat/`:** to materiały źródłowe Kancelarii Sejmu i Kancelarii Senatu. Ich opracowanie redakcyjne i grafika nie są objęte licencjami projektu.
- **`inne/*.pdf`:** eksport dokumentu z osadzonymi czcionkami. Plik nie jest objęty licencjami projektu do czasu sprawdzenia warunków tych czcionek. Tekst dokumentu jest dostępny w `inne/*.md`.
- **Zależności:** Lean 4 ma własną licencję.

## Uznanie autorstwa

Przy korzystaniu z materiałów na CC BY 4.0 podaj nazwę projektu, adres repozytorium i informację o zmianach. Część kodu i dokumentów powstała z pomocą AI.

Te zapisy nie są poradą prawną.
