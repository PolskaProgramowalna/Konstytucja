#!/usr/bin/env bash
# Pełna kontrola projektu: dowody, aksjomaty oraz aktualność danych.
set -euo pipefail
cd "$(dirname "$0")"
lake build
lake build tk_test
lake env lean --run Skrypty/KontrolaProjektu.lean
stan=$(sha256sum dane/*.csv dane/artykuly.txt)
(cd dane && python3 -I generuj.py)
# Test TK działa w Lean; Python powyżej dotyczy tylko danych tekstu Konstytucji.
./.lake/build/bin/tk_test waliduj --repo ..
./.lake/build/bin/tk_test testy --repo ..
[ "$stan" = "$(sha256sum dane/*.csv dane/artykuly.txt)" ] || {
  echo "Dane były nieaktualne względem rejestru lub PDF" >&2
  exit 1
}
