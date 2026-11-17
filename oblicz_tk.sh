#!/usr/bin/env bash
# Obliczenie roboczego testu ciągłości TK (plan_tk.txt).
#
# Użycie (z dowolnego katalogu):
#   ./oblicz_tk.sh                          # wynik -> TK/Wynik_testu_ciaglosci.md
#   ./oblicz_tk.sh -o /tmp/wynik.md         # wynik i /tmp/wynik.przygotowanie.md
#   ./oblicz_tk.sh --bez-ad ad1_brak_innych_E6   # wyłączenie założenia danych (można powtarzać)
#   ./oblicz_tk.sh --limit-m1 2 -o /tmp/proba.md  # jawna próba techniczna
#
# Kolejność: walidacja rejestru -> testy -> raport przygotowawczy -> pełne obliczenie.
# Wynik jest ROBOCZY: parametry Z1-Z14, R-PUB i AD1-AD7 nie są zatwierdzone (pkt 10 planu).
set -euo pipefail

KATALOG="$(cd "$(dirname "$0")" && pwd)"
WYJSCIE="$KATALOG/TK/Wynik_testu_ciaglosci.md"
PRZYGOTOWANIE="$KATALOG/TK/Przygotowanie_testu.md"
DODATKOWE=()

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--wyjście)
      [ "$#" -ge 2 ] || { echo "Brak ścieżki po $1" >&2; exit 2; }
      WYJSCIE="$(realpath -m "$2")"
      PRZYGOTOWANIE="${WYJSCIE%.md}.przygotowanie.md"
      shift 2 ;;
    --bez-ad|--limit-m1)
      [ "$#" -ge 2 ] || { echo "Brak wartości po $1" >&2; exit 2; }
      DODATKOWE+=("$1" "$2"); shift 2 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "Nieznany argument: $1" >&2; exit 2 ;;
  esac
done

cd "$KATALOG/LEAN"
lake build tk_test
TK_TEST="$KATALOG/LEAN/.lake/build/bin/tk_test"

echo "== 1/4 Walidacja rejestru"
"$TK_TEST" waliduj --repo "$KATALOG"

echo "== 2/4 Testy jednostkowe"
"$TK_TEST" testy --repo "$KATALOG"

echo "== 3/4 Raport przygotowawczy"
"$TK_TEST" przygotuj --repo "$KATALOG" --wyjście "$PRZYGOTOWANIE" "${DODATKOWE[@]}"

echo "== 4/4 Obliczenie skompilowanym programem Lean"
start=$(date +%s)
"$TK_TEST" oblicz --repo "$KATALOG" --roboczo --wyjście "$WYJSCIE" "${DODATKOWE[@]}"
echo "Czas: $(( $(date +%s) - start )) s"
echo "Wynik ROBOCZY zapisano w: $WYJSCIE"
