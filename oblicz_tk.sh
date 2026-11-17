#!/usr/bin/env bash
# Obliczenie roboczego testu ciągłości TK (plan_tk.txt).
#
# Użycie (z dowolnego katalogu):
#   ./oblicz_tk.sh                          # wynik -> TK/Wynik_testu_ciaglosci.md
#   ./oblicz_tk.sh -o /tmp/wynik.md         # inny plik wynikowy
#   ./oblicz_tk.sh --bez-ad ad1_brak_innych_E6   # wyłączenie założenia danych (można powtarzać)
#
# Kolejność: walidacja rejestru -> testy -> raport przygotowawczy -> pełne obliczenie.
# Wynik jest ROBOCZY: parametry Z1-Z14, R-PUB i AD1-AD6 nie są zatwierdzone (pkt 10 planu).
set -euo pipefail

KATALOG="$(cd "$(dirname "$0")" && pwd)"
DANE="$KATALOG/LEAN/dane"
WYJSCIE="$KATALOG/TK/Wynik_testu_ciaglosci.md"
DODATKOWE=()

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--wyjście) WYJSCIE="$(realpath -m "$2")"; shift 2 ;;
    --bez-ad) DODATKOWE+=(--bez-ad "$2"); shift 2 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "Nieznany argument: $1" >&2; exit 2 ;;
  esac
done

command -v python3 >/dev/null || { echo "Brak python3" >&2; exit 1; }
cd "$DANE"

echo "== 1/4 Walidacja rejestru"
python3 -I tk_test.py waliduj

echo "== 2/4 Testy jednostkowe"
python3 -I tk_test.py testy

echo "== 3/4 Raport przygotowawczy"
python3 -I tk_test.py przygotuj "${DODATKOWE[@]}"

echo "== 4/4 Obliczenie (pełny przegląd wariantów, ok. 2,5 min)"
start=$(date +%s)
python3 -I tk_test.py oblicz --roboczo --wyjście "$WYJSCIE" "${DODATKOWE[@]}"
echo "Czas: $(( $(date +%s) - start )) s"
echo "Wynik ROBOCZY zapisano w: $WYJSCIE"
