#!/usr/bin/env bash
# Pełna kontrola projektu: dowody, aksjomaty oraz zgodność danych z rejestrem.
set -euo pipefail
cd "$(dirname "$0")"
lake build
(cd dane && python3 -I generuj.py)
git diff --exit-code -- dane
