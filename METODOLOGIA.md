# Metodologia formalizacji Konstytucji RP

Projekt zapisuje wybrane przepisy Konstytucji RP w języku Lean 4, a Lean sprawdza wnioski wyprowadzone z tego zapisu. Wynik jest formalnym modelem jednej roboczej interpretacji, a nie opinią prawną ani dowodem Konstytucji.

Każdy wniosek należy czytać tak: „przy tych założeniach z tego modelu wynika, że...”.

## Co jest dowodzone

Konstytucja nie jest dowodem, lecz zbiorem norm. W projekcie:

- przepisy stają się definicjami, typami i automatami,
- to, czego tekst nie rozstrzyga, staje się jawnym założeniem albo parametrem,
- dowodami są dopiero wnioski, np. minimalny próg głosów albo osiągalny stan bez wyjścia.

Lean gwarantuje, że wniosek wynika z modelu. Nie gwarantuje, że model trafnie oddaje przepis. Tę zgodność sprawdzają inne środki opisane niżej, a ostatecznie recenzja prawnika.

## Tekst źródłowy

Tekstem wzorcowym jest tekst ujednolicony Kancelarii Sejmu, `Sejm/D19970483Lj.pdf` (Dz.U. 1997 nr 78 poz. 483 ze zm.).

`LEAN/dane/generuj.py` wyodrębnia z niego tekst i dzieli go na 243 artykuły oraz 624 wiersze: ustępy i punkty. Skrypt porównuje wynik z wydaniem Senatu token po tokenie i kończy się błędem przy każdej nieoczekiwanej różnicy. Jedyna dozwolona różnica to art. 228 ust. 7: Senat ma „przeprowadzone”, a Sejm „przeprowadzane”. Skan Dziennika Ustaw potwierdza wersję Sejmu.

Pełnego porównania ze skanem Dziennika Ustaw nie ma, bo skan nie ma warstwy tekstowej.

## Zasady modelowania

Pełna lista zasad Z1–Z11 jest w `plan.txt`. Najważniejsze z nich:

- **Źródło każdej konstrukcji.** Definicje wskazują przepis, a konstrukcje techniczne są oznaczone jako pomocnicze.
- **Jawne założenia.** Założenia spoza tekstu są zebrane w `LEAN/Konstytucja/Założenia.lean`, a warianty ze statusem w `LEAN/dane/warianty.csv`.
- **Pojęcia ocenne bez definicji.** Pojęcia takie jak „konieczne” czy „istota prawa” są parametrami. Model pokazuje, od których z nich zależy wynik, ale nie ustala ich treści.
- **Luka jest wynikiem.** Brak sankcji, terminu albo reguły kolizyjnej nie jest ukrywany. Trafia do `LEAN/docs/luki.txt`.
- **Blokada musi być osiągalna.** Opis stanu bez wyjścia wymaga dowodu, że przebieg faktycznie do niego prowadzi.

## Warstwy modelu

| Warstwa | Pliki w `LEAN/Konstytucja/` | Zawartość |
| --- | --- | --- |
| Podstawy | `Podstawy/` | czas, głosowanie, organy, akty, normy, automaty |
| Procedury | `Procedury/` | automaty stanów dla procedur Konstytucji |
| Kompetencje | `Kompetencje/` | kontrasygnata i właściwość Trybunału Konstytucyjnego |
| Prawa | `Prawa/` | pojęcia ocenne, art. 31 ust. 3 i klauzule szczególne |
| Twierdzenia | `Twierdzenia/` | dowody własności |
| Modele | `Modele/` | konkretne instancje założeń i scenariusze |
| Analiza | `Analiza/` | system norm i własności całościowe |

## Procedury jako automaty

Każda procedura to automat: etapy, dozwolone przejścia i warunki z przepisów. Terminy są warunkami przejść, a progi głosowań pochodzą ze wspólnych definicji.

Parametrem jest to, czego tekst nie mówi, np. czy organ działa albo jaki limit przyjąć dla czynności bez terminu. Gdy czas ma znaczenie, automat dopuszcza jego upływ w etapach oczekiwania.

Dla każdej procedury dowodzimy osobno:

1. osiągalności wyników,
2. zachowania ograniczeń z przepisów,
3. zakończenia przy jawnie nazwanych warunkach,
4. maksymalnego czasu albo jego braku.

Brak górnej granicy czasu jest dopuszczalnym wynikiem. Art. 122 nie podaje na przykład terminu Trybunałowi, więc model tego nie uzupełnia.

Kilka automatów można złożyć w większy przebieg. Przyjęta dymisja uruchamia art. 154, a opróżnienie urzędu uruchamia wybory.

## Interpretacja i warianty

Gdy tekst dopuszcza kilka odczytań, model zachowuje je jako warianty. Przykładami są liczenie głosów wstrzymujących się i pytanie, czy klauzule szczególne działają obok art. 31 ust. 3, czy zamiast niego.

Dla pojęć ocennych służą dwa pojęcia:

- `ZależyOd`: zmiana samego pojęcia zmienia wynik, co pokazuje para instancji,
- `NieZależyOd`: zmiana samego pojęcia nigdy nie zmienia wyniku.

Dowód dla wariantu nie przesądza o jego dopuszczalności prawnej. Każdy wariant ma status: roboczy, przyjęty do głównego modelu albo zweryfikowany przez recenzenta. Obecnie wszystkie są robocze.

## Cztery odrębne własności

Etap 6 rozdziela własności, które łatwo pomylić:

| Własność | Pytanie | Czego nie oznacza |
| --- | --- | --- |
| Spełnialność | Czy istnieje instancja warunków? | spójności wszystkich norm |
| Wykonalność | Czy działające nakazy i zakazy da się spełnić? | wykonalności całej Konstytucji |
| Rozstrzygnięcie kolizji | Czy każda kolizja ma regułę pierwszeństwa? | trafności tej reguły |
| Brak blokad | Czy stan niekońcowy ma następnika? | braku rozwiązania poza tekstem |

Wykonalność ma dwie formy. Wykonalność statyczna dotyczy jednej chwili. Wykonalność terminowa sprawdza, czy w oknie obowiązku istnieje dzień bez zakazu. Dlatego para przepisów sprzeczna w danej chwili może być wykonalna później.

Kolizja też nie zawsze oznacza niewykonalność. Dozwolenie z art. 225 koliduje z zakazem z art. 228 ust. 7, ale można przestrzegać obu, nie skracając kadencji.

## Kontrola jakości

Kompilacja to tylko pierwszy krok. Projekt korzysta z kilku niezależnych kontroli.

| Kontrola | Co wykrywa | Gdzie |
| --- | --- | --- |
| `lake build` | błędy dowodów | każda kompilacja |
| Kontrola aksjomatów | `sorry`, własne aksjomaty i `native_decide`, także w modułach niezaimportowanych | `LEAN/Skrypty/KontrolaProjektu.lean` |
| Instancje | warunki niemożliwe do spełnienia | `LEAN/Konstytucja/Modele/` |
| Porównanie tekstu | błędy wyodrębniania | `LEAN/dane/generuj.py` |
| Rejestr | odwołania do nieistniejących przepisów lub nazw | `LEAN/dane/rejestr.csv` |
| Frazy | klauzule bez podstawy w tekście | `pojecia.csv`, `klauzule.csv` |
| Testy mutacyjne | twierdzenia, które niczego nie wymuszają | wykonywane ręcznie na kopii |
| Recenzja techniczna | puste tezy, zbyt mocne wnioski, błędy modelu | po każdym etapie |

Wszystkie kontrole oprócz testów mutacyjnych i recenzji uruchamia `LEAN/sprawdź.sh`. Te same kroki wykonuje `.github/workflows/lean.yml`.

### Testy mutacyjne

Test polega na celowym zepsuciu modelu, np. zmianie 46 posłów na 45, i sprawdzeniu, czy dowód przestaje przechodzić. Przeżycie mutacji oznacza, że żadne twierdzenie nie wymusza danej reguły.

Takie testy znalazły realne braki. Mutacja „motyw dozwolony” przeszła bez błędu, więc doszło twierdzenie o pełnej liście z art. 233 ust. 2. Mutacja kandydata ujawniła warunek, który niczego nie wymagał. Testy nie są częścią repozytorium i nie zastępują recenzji.

### Puste tezy

Twierdzenie może być poprawne i nic nie mówić. Tak było z `Przebieg a a`, które dowodzi samo przejście puste, i z blokadami stanów nieosiągalnych przy stałym parametrze. Dlatego przegląd tez sprawdza, czy konkluzja zależy od założeń i czy opisany stan jest osiągalny.

## Pokrycie

Postęp mierzymy na poziomie ustępu i punktu. `LEAN/dane/rejestr.csv` wiąże przepis z definicjami i twierdzeniami, a `pokrycie_przepisy.csv` powstaje z tego automatycznie.

Status `częściowo` oznacza, że ujęto tylko zakres wskazany w rejestrze. Jeden wiersz może zawierać kilka norm, więc liczba wierszy nie mierzy jakości interpretacji. Klasyfikacja typów przepisów w `pokrycie.csv` jest wstępna i opiera się na wzorcach tekstowych.

## Jak czytać wyniki

- **„Lean dowodzi”** znaczy, że wniosek wynika z modelu i założeń, a nie że tak stanowi prawo.
- **„Blokada”** znaczy, że sam tekst Konstytucji nie podaje dalszego przejścia. Rozwiązanie może istnieć w ustawie, orzecznictwie lub praktyce.
- **„Kolizja”** w modelu nie przesądza, że nie ma reguły wykładni, np. lex specialis.
- **Liczby głosów** dotyczą przyjętego wariantu liczenia i często skrajnego przypadku.
- **Przykładowe daty i głosy** pokazują możliwość, a nie obowiązujący stan.

## Czego model nie obejmuje

Model nie zawiera ustaw, regulaminów izb, orzecznictwa, doktryny, praktyki ustrojowej ani pojęcia terytorium. Nie rozróżnia podmiotów praw, a rozdziały I i II są ujęte punktowo. Analiza wykonalności obejmuje tylko 10 wybranych norm.

Etap 6 nie jest zakończony, bo wymaga recenzji prawnika.

## Odtworzenie wyników

Potrzebne są `elan` z wersją Lean z `LEAN/lean-toolchain`, Python 3 i `pdftotext`. Potem wystarczy:

```bash
cd LEAN
./sprawdź.sh
```

Kod wyjścia 0 oznacza, że dowody się kompilują, nie ma niedozwolonych aksjomatów, a dane zgadzają się z rejestrem i tekstem.
