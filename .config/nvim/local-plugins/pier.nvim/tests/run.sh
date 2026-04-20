#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

find_plenary_path() {
  local candidate

  if [[ -n "${PLENARY_PATH:-}" && -d "${PLENARY_PATH}" ]]; then
    printf '%s\n' "${PLENARY_PATH}"
    return 0
  fi

  for candidate in \
    "$HOME/.local/share/nvim/lazy/plenary.nvim" \
    "$HOME/.local/share/nvim/site/pack/*/start/plenary.nvim" \
    "$HOME/.local/share/nvim/site/pack/*/opt/plenary.nvim"; do
    for match in $candidate; do
      if [[ -d "$match" ]]; then
        printf '%s\n' "$match"
        return 0
      fi
    done
  done

  return 1
}

if ! plenary_path="$(find_plenary_path)"; then
  cat >&2 <<'EOF'
Could not locate plenary.nvim for tests.
Set PLENARY_PATH to a local plenary.nvim checkout, for example:
  PLENARY_PATH=$HOME/.local/share/nvim/lazy/plenary.nvim tests/run.sh
EOF
  exit 1
fi

export PLENARY_PATH="$plenary_path"
export XDG_CONFIG_HOME="$tmpdir/config"
export XDG_DATA_HOME="$tmpdir/data"
export XDG_STATE_HOME="$tmpdir/state"
export XDG_CACHE_HOME="$tmpdir/cache"

exec nvim --headless --clean -u tests/minimal_init.lua \
  -c "PlenaryBustedDirectory tests/spec { minimal_init = 'tests/minimal_init.lua' }"
