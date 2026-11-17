#!/usr/bin/env bash
# Pełna kontrola projektu: dowody, aksjomaty oraz aktualność danych.
set -euo pipefail
cd "$(dirname "$0")"
lake build
lake env lean --run Skrypty/KontrolaProjektu.lean
stan=$(sha256sum dane/*.csv dane/artykuly.txt)
(cd dane && python3 -I generuj.py)
# Test ciągłości TK (plan_tk.txt): walidacja rejestru, testy, aktualność CiagloscDane.lean
(cd dane && python3 -I tk_test.py waliduj && python3 -I tk_test.py testy)
[ "$stan" = "$(sha256sum dane/*.csv dane/artykuly.txt)" ] || {
  echo "Dane były nieaktualne względem rejestru lub PDF" >&2
  exit 1
}
