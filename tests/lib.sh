#!/usr/bin/env bash

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "expected file $path"
}

assert_not_file() {
  local path="$1"
  [[ ! -e "$path" ]] || fail "expected $path to not exist"
}

assert_contains() {
  local path="$1"
  local pattern="$2"
  grep -Fq -- "$pattern" "$path" || fail "expected $path to contain: $pattern"
}

assert_not_contains() {
  local path="$1"
  local pattern="$2"
  if grep -Fq -- "$pattern" "$path"; then
    fail "expected $path to not contain: $pattern"
  fi
}

assert_line() {
  local path="$1"
  local line="$2"
  grep -Fxq -- "$line" "$path" || fail "expected $path to contain line: $line"
}

assert_not_line() {
  local path="$1"
  local line="$2"
  if grep -Fxq -- "$line" "$path"; then
    fail "expected $path to not contain line: $line"
  fi
}

assert_order() {
  local path="$1"
  local first="$2"
  local second="$3"
  local first_line second_line
  first_line="$(grep -nF -- "$first" "$path" | head -n1 | cut -d: -f1)"
  second_line="$(grep -nF -- "$second" "$path" | head -n1 | cut -d: -f1)"
  [[ -n "$first_line" && -n "$second_line" ]] || fail "missing order markers in $path"
  ((first_line < second_line)) || fail "expected '$first' before '$second' in $path"
}
