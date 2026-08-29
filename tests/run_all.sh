#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

for test_file in test_*.sh; do
  [[ -x "$test_file" ]] || {
    printf "FAIL %s is not executable\n" "$test_file" >&2
    exit 1
  }

  printf "RUN  %s\n" "$test_file"
  bash "$test_file"
done

printf "\nAll tests passed.\n"
