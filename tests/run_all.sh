#!/usr/bin/env bash
set -uo pipefail

cd "$(dirname "$0")"

failures=0
failed_tests=()
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

for test_file in test_*.sh; do
  if [[ ! -f "$test_file" ]]; then
    continue
  fi

  printf 'RUN  %s\n' "$test_file"
  output_file="$tmpdir/${test_file}.log"

  if bash "$test_file" >"$output_file" 2>&1; then
    printf 'PASS %s\n' "$test_file"
  else
    printf 'FAIL %s\n' "$test_file"
    failures=$((failures + 1))
    failed_tests+=("$test_file")
  fi
done

if ((failures > 0)); then
  printf '\nFailed tests: %d\n' "$failures"
  for test_file in "${failed_tests[@]}"; do
    output_file="$tmpdir/${test_file}.log"
    if [[ -f "$output_file" ]]; then
      printf '\n=== %s ===\n' "$test_file"
      cat "$output_file"
    fi
  done
  exit 1
fi

printf '\nAll tests passed.\n'
