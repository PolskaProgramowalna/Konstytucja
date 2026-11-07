# Jak zacząć

Ten przewodnik prowadzi od instalacji do pierwszego własnego twierdzenia. Nie musisz znać Lean ani prawa konstytucyjnego. Wystarczy podstawowa obsługa terminala.

Projekt zapisuje przepisy Konstytucji jako kod, a Lean sprawdza wnioski z tego zapisu. To nie jest opinia prawna. Więcej o metodzie jest w [METODOLOGIA.md](METODOLOGIA.md).

## 1. Zainstaluj narzędzia

Potrzebujesz:

- **git** do pobrania projektu,
- **elan** do zarządzania wersjami Lean,
- **Python 3** i **pdftotext** do pełnej kontroli projektu.

Na Linuksie lub macOS zainstaluj elan tak:

```bash
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh
```

Po instalacji otwórz nowy terminal. Na Ubuntu `pdftotext` jest w pakiecie `poppler-utils`:

```bash
sudo apt install poppler-utils
```

Na Windowsie użyj instrukcji z [repozytorium elan](https://github.com/leanprover/elan).

**Polecany edytor:** Visual Studio Code z rozszerzeniem **Lean 4**. Pokazuje błędy i stan dowodu podczas pisania.

## 2. Pobierz projekt

```bash
git clone https://github.com/PolskaProgramowalna/Konstytucja.git
cd Konstytucja/LEAN
```

Wszystkie dalsze polecenia uruchamiaj w katalogu `LEAN`.

## 3. Uruchom kontrolę

```bash
./sprawdź.sh
```

Przy pierwszym uruchomieniu elan pobierze właściwą wersję Lean, a kompilacja chwilę potrwa. Na końcu powinna pojawić się linia z liczbą modułów i deklaracji oraz tekst `bez niedozwolonych aksjomatów`.

Kod wyjścia 0 oznacza, że wszystko przeszło. Sprawdzisz go tak:

```bash
echo $?
```

## 4. Wypróbuj model

Utwórz w katalogu `LEAN` plik `Proba.lean`:

```lean
import Konstytucja.Twierdzenia.Progi
import Konstytucja.Twierdzenia.Kompetencje

open Konstytucja

#eval Izba.sejm.ustawowaLiczba
#eval Izba.zgromadzenieNarodowe.ustawowaLiczba
#check min_art158

open Kontrasygnata in
#eval wymagaKontrasygnaty true (.prerogatywa .prawoŁaski)
open Kontrasygnata in
#eval wymagaKontrasygnaty true .wprowadzenieStanuWojennego

open Trybunał in
#eval możeWystąpić (.posłowie 49) .zgodnośćZKonstytucją bezWarunków
open Trybunał in
#eval możeWystąpić (.posłowie 50) .zgodnośćZKonstytucją bezWarunków
```

Uruchom go:

```bash
lake env lean Proba.lean
```

Wynik powinien wyglądać tak:

```text
460
560
Konstytucja.min_art158 : JestMinimum wotumNieufności 231
false
true
false
true
```

Co to oznacza:

- `#eval` oblicza wartość. Sejm ma 460 posłów, a Zgromadzenie Narodowe 560 członków.
- `#check` pokazuje twierdzenie. Wotum nieufności wymaga co najmniej 231 głosów.
- Prawo łaski nie wymaga kontrasygnaty, a wprowadzenie stanu wojennego tak.
- 49 posłów nie może wystąpić do Trybunału, a 50 może.

## 5. Udowodnij pierwsze twierdzenie

Dopisz na końcu pliku `Proba.lean`:

```lean
theorem pięćdziesięciu_posłów_może_wystąpić :
    Trybunał.możeWystąpić (.posłowie 50) .zgodnośćZKonstytucją Trybunał.bezWarunków = true := by
  decide
```

Uruchom plik jeszcze raz. Brak błędu oznacza, że Lean przyjął dowód. Taktyka `decide` po prostu oblicza wynik.

Zmień teraz `50` na `49` i uruchom plik. Lean zgłosi błąd, bo takie twierdzenie jest fałszywe. Tak właśnie działa kontrola: fałszywego wniosku nie da się udowodnić.

**Usuń `Proba.lean`, gdy skończysz.** Kontrola projektu odrzuca pliki spoza biblioteki, więc `./sprawdź.sh` zakończy się błędem, dopóki ten plik istnieje.

```bash
rm Proba.lean
```

## 6. Zobacz, jak model wykrywa błąd

Otwórz `Konstytucja/Procedury/OdpowiedzialnośćRządu.lean`, znajdź `zgłoszenieNieufności` i zmień `n ≥ 46` na `n ≥ 45`. Potem uruchom:

```bash
lake build
```

Kompilacja przerwie się na twierdzeniu `wniosek_wymaga_46`, bo art. 158 ust. 1 wymaga 46 posłów. To jest test mutacyjny, jedna z głównych metod sprawdzania modelu.

Cofnij zmianę:

```bash
git restore Konstytucja/Procedury/OdpowiedzialnośćRządu.lean
```

## 7. Poznaj układ projektu

Czytaj w tej kolejności:

1. `Konstytucja/Podstawy/Głosowanie.lean`: kworum i rodzaje większości.
2. `Konstytucja/Twierdzenia/Progi.lean`: minimalne liczby głosów.
3. `Konstytucja/Procedury/TworzenieRządu.lean`: pierwszy automat procedury.
4. `Konstytucja/Twierdzenia/TworzenieRządu.lean`: co dowodzimy o procedurze.
5. `Konstytucja/Założenia.lean`: co przyjęliśmy spoza tekstu.

Automat to lista etapów i dozwolonych przejść. Każde przejście ma komentarz z przepisem, więc kod można czytać obok Konstytucji. Tekst przepisów jest w `dane/artykuly.txt`.

## 8. Jak wprowadzić zmianę

1. Znajdź przepis w `dane/artykuly.txt` i sprawdź, co jest już ujęte w `dane/pokrycie_przepisy.csv`.
2. Dodaj definicję lub przejście z komentarzem wskazującym przepis.
3. Jeśli tekst czegoś nie rozstrzyga, dopisz założenie do `Konstytucja/Założenia.lean`. Wariant dopisz do `dane/warianty.csv`, a lukę do `docs/luki.txt`.
4. Dodaj twierdzenie i dopisz je do `dane/rejestr.csv`.
5. Nowy moduł dopisz do importów w `Konstytucja.lean`.
6. Uruchom `python3 -I generuj.py` w katalogu `dane`, a potem `./sprawdź.sh` w katalogu `LEAN`.

Sprawdź też swoje twierdzenie:

- Czy teza zależy od założeń, czy jest prawdziwa niezależnie od modelu?
- Czy opisany stan jest osiągalny?
- Czy mała celowa usterka w modelu psuje dowód?

Nazwy w Lean zapisujemy po polsku, ze znakami diakrytycznymi.

## 9. Typowe problemy

| Objaw | Co zrobić |
| --- | --- |
| `lake: command not found` | otwórz nowy terminal albo dodaj `~/.elan/bin` do `PATH` |
| `sprawdź.sh` kończy się błędem o brakującym module | usuń pliki `.lean` spoza biblioteki, np. `Proba.lean` |
| `rejestr: brak deklaracji` | popraw nazwę w `dane/rejestr.csv` albo dodaj deklarację |
| `rejestr: nazwa niejednoznaczna` | dodaj przestrzeń nazw, np. `Ustawodawstwo.Krok` |
| `Dane były nieaktualne` | uruchom `python3 -I generuj.py` w katalogu `dane` |
| `lake build` przechodzi, ale `sprawdź.sh` nie | w kodzie może być `sorry`, którego sama kompilacja nie zatrzymuje |

## Dokąd dalej

- [METODOLOGIA.md](METODOLOGIA.md): jak i dlaczego model powstaje.
- [plan.txt](plan.txt): etapy, zasady i otwarte decyzje.
- `LEAN/docs/luki.txt`: wnioski czekające na ocenę prawnika.
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/): podręcznik języka.
