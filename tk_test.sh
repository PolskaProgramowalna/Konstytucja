#!/usr/bin/env bash
# Polecenia testu TK: skompilowany program Lean, bez interpretera Python.
set -euo pipefail
KATALOG="$(cd "$(dirname "$0")" && pwd)"
(
  cd "$KATALOG/LEAN"
  lake build tk_test
)
exec "$KATALOG/LEAN/.lake/build/bin/tk_test" "$@" --repo "$KATALOG"
