#!/usr/bin/env bash
set -euo pipefail

hook_default_branch() {
  local ref
  ref="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  ref="${ref#origin/}"
  if [[ -n "$ref" ]]; then
    echo "$ref"
    return 0
  fi
  echo "main"
}

hook_changed_files() {
  local base="origin/$(hook_default_branch)"
  git fetch origin "${base#origin/}" --quiet || true
  git diff --name-only "$base...HEAD"
}

hook_component_roots() {
  local repo_root
  repo_root="$(git rev-parse --show-toplevel)"
  local -A comps=()

  while IFS= read -r rel; do
    [[ -z "$rel" ]] && continue
    local dir abs
    dir="$(dirname "$rel")"
    abs="$repo_root/$dir"
    while [[ $abs == "$repo_root"* ]]; do
      if [[ -f "$abs/pyproject.toml" ]]; then
        comps["$abs"]=1
        break
      fi
      [[ $abs == "$repo_root" ]] && break
      abs="$(cd "$abs/.." && pwd)"
    done
  done

  for c in "${!comps[@]}"; do
    echo "$c"
  done
}

hook_container_root() {
  local dir
  dir="$(pwd -P)"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/main" && -d "$dir/wt" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(cd "$dir/.." && pwd)"
  done
  return 1
}

hook_config_bool() {
  local hook="$1"
  local key="$2"
  local container
  local hook_dir
  hook_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  container="$(hook_container_root || true)"
  if [[ -z "$container" ]]; then
    echo ""
    return 0
  fi
  local config="$container/git-wt.toml"

  if [[ ! -f "$config" ]]; then
    echo ""
    return 0
  fi
  if ! command -v python3 >/dev/null 2>&1; then
    echo ""
    return 0
  fi

  local helper="$hook_dir/../_read_toml.py"
  local out
  out="$(python3 "$helper" bool "$config" hooks "$hook" "$key")" || {
    echo "git-wt hook: invalid config for hooks.$hook.$key" >&2
    exit 1
  }
  echo "$out"
}
