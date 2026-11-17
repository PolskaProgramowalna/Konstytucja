#!/usr/bin/env bash
# Regresja: -o/--wyjście zapisuje oba raporty poza standardowymi plikami TK/.
set -euo pipefail

KATALOG="$(cd "$(dirname "$0")/.." && pwd)"
TEST_TMP="$(mktemp -d)"
trap 'rm -rf "$TEST_TMP"' EXIT

raporty_stan() {
  sha256sum "$KATALOG/TK/Przygotowanie_testu.md" \
    "$KATALOG/TK/Wynik_testu_ciaglosci.md"
}

STAN_PRZED="$(raporty_stan)"
TEST_NR=0
for OPCJA in -o --wyjście; do
  TEST_NR=$((TEST_NR + 1))
  if [ "$OPCJA" = -o ]; then
    CEL="wynik test.md"
  else
    CEL="podkatalog/wynik"
  fi
  LOG="$TEST_TMP/test-$TEST_NR.log"
  if ! (cd "$TEST_TMP" && "$KATALOG/oblicz_tk.sh" --limit-m1 1 "$OPCJA" "$CEL") >"$LOG" 2>&1; then
    cat "$LOG" >&2
    exit 1
  fi
  [ -s "$TEST_TMP/$CEL" ]
  [ -s "$TEST_TMP/${CEL%.md}.przygotowanie.md" ]
  grep -q 'NIEPEŁNY PRZEGLĄD' "$TEST_TMP/$CEL"
  grep -q 'O2 o pewności nieustalonej - wymaga oceny P11' "$TEST_TMP/$CEL"
  [ "$STAN_PRZED" = "$(raporty_stan)" ] || {
    echo "Opcja $OPCJA zmieniła standardowy raport w TK/" >&2
    exit 1
  }
done

echo "Testy oblicz_tk.sh: -o i --wyjście zapisują oba raporty osobno; pliki TK/ bez zmian"
