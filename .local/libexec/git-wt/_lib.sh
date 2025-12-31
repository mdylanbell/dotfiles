#!/usr/bin/env bash
set -euo pipefail

wt_find_container() {
  local start="${1:-$PWD}"
  local dir="$start"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/main" && -d "$dir/wt" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(cd "$dir/.." && pwd)"
  done
  return 1
}

wt_container() {
  local c
  c="$(wt_find_container "$PWD")" || {
    echo "git-wt: not inside a repo container (expected main/ and wt/ above cwd)" >&2
    return 1
  }
  echo "$c"
}

wt_main() { echo "$(wt_container)/main"; }
wt_wt() { echo "$(wt_container)/wt"; }

wt_git() {
  git -C "$(wt_main)" "$@"
}

wt_slugify() {
  local s="${1:-}"
  s="$(echo "$s" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9._-')"
  s="$(echo "$s" | sed -E 's/-+/-/g; s/^-+//; s/-+$//')"
  echo "$s"
}

die() {
  echo "git-wt: $*" >&2
  exit 1
}
