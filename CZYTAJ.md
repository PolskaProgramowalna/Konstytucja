# Konstytucja RP w Lean 4

Projekt zapisuje wybrane przepisy Konstytucji Rzeczypospolitej Polskiej w języku Lean 4 i dowodzi wniosków z tego zapisu. Procedury, progi, terminy, kompetencje i ograniczenia praw są sprawdzane maszynowo, a to, czego tekst nie rozstrzyga, jest jawnym założeniem.

Model jest roboczą interpretacją, a nie opinią prawną. Wynik znaczy zawsze: „przy tych założeniach z modelu wynika, że...”. Założenia i luki czekają na recenzję prawnika.

## Od czego zacząć

| Dla kogo | Dokument |
| --- | --- |
| Ogólny obraz metody | [METODOLOGIA.md](METODOLOGIA.md) |
| Prawnik | [inne/](inne/): recenzja prawna z założeniami, lukami i pytaniami |
| Plan i stan etapów | [plan.txt](plan.txt) |
| Wnioski z modelu | [LEAN/docs/luki.txt](LEAN/docs/luki.txt) |
| Założenia spoza tekstu | [LEAN/Konstytucja/Założenia.lean](LEAN/Konstytucja/Założenia.lean) |
| Pokrycie przepisów | [LEAN/dane/pokrycie_przepisy.csv](LEAN/dane/pokrycie_przepisy.csv) |

## Co obejmuje model

- **Procedury:** tworzenie rządu, ustawodawstwo, zmiana Konstytucji, wotum nieufności i dymisja, referendum, wybór Prezydenta i ciągłość urzędu, stany nadzwyczajne.
- **Kompetencje:** kontrasygnata z art. 144 i właściwość Trybunału Konstytucyjnego.
- **Prawa:** art. 31 ust. 3, klauzule szczególne i pojęcia ocenne jako parametry.
- **Analiza:** wykonalność wybranego systemu norm, kolizje i blokady procedur.

Pokrycie jest częściowe. Większość przepisów nie jest jeszcze ujęta, a ujęte mają zwykle tylko wskazany zakres. Etap 6 nie jest zakończony, bo wymaga recenzji prawnika.

## Struktura repozytorium

```text
LEAN/                 projekt Lean 4
  Konstytucja/        model i dowody
  Skrypty/            kontrola aksjomatów
  dane/               tekst, rejestr, warianty i pokrycie
  docs/luki.txt       luki i spory interpretacyjne
  sprawdź.sh          pełna kontrola projektu
Sejm/                 tekst wzorcowy i skan Dziennika Ustaw
Senat/                wydanie Senatu, użyte do porównania
inne/                 eksport dokumentu dla prawnika
METODOLOGIA.md        opis metody
plan.txt              plan, zasady i stan etapów
```

## Uruchomienie

Potrzebne są [elan](https://github.com/leanprover/elan), Python 3 i `pdftotext`. Wersję Lean przypina plik `LEAN/lean-toolchain`.

```bash
cd LEAN
./sprawdź.sh
```

Skrypt kompiluje dowody, odrzuca `sorry` i niedozwolone aksjomaty oraz sprawdza, czy dane zgadzają się z tekstem i rejestrem. Kod wyjścia 0 oznacza, że wszystkie te kontrole przeszły.

Samo `lake build` nie wystarcza, bo nie wykryje `sorry` w dowodach.

## Licencja

Kod jest na licencji [Apache 2.0](LICENSE), a dokumenty i dane projektu na [CC BY 4.0](LICENSE-CC-BY-4.0.txt). Tekst Konstytucji oraz pliki w `Sejm/`, `Senat/` i `inne/*.pdf` nie są nimi objęte. Szczegóły są w [LICENCJE.md](LICENCJE.md).

## Tekst Konstytucji

Tekstem wzorcowym projektu jest tekst ujednolicony Kancelarii Sejmu, `Sejm/D19970483Lj.pdf`. Źródła:

- **Sejm RP, ISAP:** Dz.U. 1997 nr 78 poz. 483, https://isap.sejm.gov.pl/isap.nsf/DocDetails.xsp?id=wdu19970780483
- **Senat RP, wersja PDF:** https://www.senat.gov.pl/gfx/senat/userfiles/_public/k10/kancelaria/wydawnictwa/pdf/konstytucja_rp_miniatura_w._polska.pdf
- **Prezydent RP:** https://www.prezydent.pl/prawo/konstytucja-rp

Wydania Sejmu i Senatu różnią się treścią tylko w art. 228 ust. 7: „przeprowadzane” i „przeprowadzone”. Skan Dziennika Ustaw potwierdza wersję Sejmu.
