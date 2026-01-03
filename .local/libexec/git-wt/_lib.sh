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

wt_libexec_dir() {
  local dir
  dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  echo "$dir"
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

wt_default_branch() {
  local ref
  ref="$(git -C "$(wt_main)" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  ref="${ref#origin/}"
  if [[ -n "$ref" ]]; then
    echo "$ref"
    return 0
  fi
  echo "main"
}

wt_hooks_pr_checkout() {
  local container
  container="$(wt_container)"
  local config="$container/git-wt.toml"
  [[ -f "$config" ]] || return 0
  command -v python3 >/dev/null 2>&1 || die "python3 required to read $config"
  local helper
  helper="$(wt_libexec_dir)/_read_toml.py"
  local hooks_out
  hooks_out="$(python3 "$helper" list "$config" hooks pr_checkout)" || {
    die "invalid hooks.pr_checkout in $config"
  }
  [[ -n "$hooks_out" ]] || return 0
  printf "%s\n" "$hooks_out"
}

wt_run_pr_checkout_hooks() {
  local dest="$1"
  local hooks_dir
  hooks_dir="$(wt_libexec_dir)/hooks"
  local hooks=()
  while IFS= read -r h; do
    [[ -n "$h" ]] && hooks+=("$h")
  done < <(wt_hooks_pr_checkout)

  if [[ ${#hooks[@]} -eq 0 ]]; then
    return 0
  fi

  for h in "${hooks[@]}"; do
    local hook_path="$hooks_dir/$h"
    if [[ ! -x "$hook_path" ]]; then
      echo "git-wt: hook not found or not executable: $hook_path" >&2
      return 1
    fi
  done

  for h in "${hooks[@]}"; do
    local hook_path="$hooks_dir/$h"
    (cd "$dest" && "$hook_path")
  done
}

wt_repo_slug() {
  local url="${1:-}"
  local slug
  slug="$(echo "$url" | sed -E 's#^.*[:/]{1}([^/:]+/[^/]+)$#\1#')"
  slug="${slug%.git}"
  if [[ "$slug" == "$url" ]]; then
    echo ""
    return 0
  fi
  echo "$slug"
}

wt_repo_host() {
  local url="${1:-}"
  local host=""

  if [[ "$url" =~ ^git@([^:]+): ]]; then
    host="${BASH_REMATCH[1]}"
  elif [[ "$url" =~ ^ssh://git@([^/]+)/ ]]; then
    host="${BASH_REMATCH[1]}"
  elif [[ "$url" =~ ^https?://([^/]+)/ ]]; then
    host="${BASH_REMATCH[1]}"
  fi

  echo "$host"
}

die() {
  echo "git-wt: $*" >&2
  exit 1
}

wt_require_git() {
  command -v git >/dev/null 2>&1 || die "git not found"
}

wt_require_gh() {
  command -v gh >/dev/null 2>&1 || die "gh not found"
}
