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

wt_abs_path() {
  local path="${1:?}"
  echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
}

wt_parse_container_arg() {
  local val="${1:-}"
  [[ -n "$val" ]] || die "--container requires a path"
  echo "$val"
}

wt_parse_protect_default_arg() {
  local val="${1:-}"
  [[ -n "$val" ]] || die "--protect-default requires a value (chain|false)"
  echo "$val"
}

wt_resolve_container() {
  local path="${1:-$PWD}"
  local c
  c="$(wt_find_container "$path")" || {
    die "no git-wt container found above $path (use --container to specify one)"
  }
  echo "$c"
}

wt_main_for() { echo "${1:?}/main"; }
wt_wt_for() { echo "${1:?}/wt"; }

wt_git_for() {
  local container="${1:?}"
  shift
  git -C "$(wt_main_for "$container")" "$@"
}

wt_slugify() {
  local s="${1:-}"
  s="$(echo "$s" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9._-')"
  s="$(echo "$s" | sed -E 's/-+/-/g; s/^-+//; s/-+$//')"
  echo "$s"
}

wt_default_branch_for() {
  local container="${1:?}"
  local ref
  ref="$(git -C "$(wt_main_for "$container")" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  ref="${ref#origin/}"
  if [[ -n "$ref" ]]; then
    echo "$ref"
    return 0
  fi
  echo "main"
}

wt_is_container_root() {
  local dir="${1:?}"
  [[ -d "$dir/main" && -d "$dir/wt" && ( -d "$dir/main/.git" || -f "$dir/main/.git" ) ]]
}

wt_find_parent_container() {
  local dir
  dir="$(cd "$1/.." && pwd)"
  while [[ "$dir" != "/" ]]; do
    if wt_is_container_root "$dir"; then
      echo "$dir"
      return 0
    fi
    dir="$(cd "$dir/.." && pwd)"
  done
  return 1
}

wt_write_protect_hook() {
  local hook_path="${1:?}"
  cat <<'EOF' >"$hook_path"
#!/usr/bin/env bash
set -euo pipefail

# git-wt hook wrapper
default_branch="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
default_branch="${default_branch#origin/}"
if [[ -z "$default_branch" ]]; then
  default_branch="main"
fi

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
if [[ "$branch" == "$default_branch" ]]; then
  echo "Refusing commit/push on protected branch: $branch" >&2
  exit 1
fi

backup="${0}.git-wt.bak"
if [[ -f "$backup" ]]; then
  if [[ ! -x "$backup" ]]; then
    echo "git-wt: hook exists but is not executable: $backup" >&2
    exit 1
  fi
  "$backup"
fi
EOF
  chmod +x "$hook_path"
}

wt_install_protect_hooks() {
  local main_dir="${1:?}"
  local hooks_dir="$main_dir/.git/hooks"
  mkdir -p "$hooks_dir"

  wt_write_protect_hook "$hooks_dir/pre-commit"
  wt_write_protect_hook "$hooks_dir/pre-push"
}

wt_apply_protect_default() {
  local main_dir="${1:?}"
  local mode="${2:-}"
  local hooks_dir="$main_dir/.git/hooks"

  if [[ -z "$mode" ]]; then
    if [[ -e "$hooks_dir/pre-commit" || -e "$hooks_dir/pre-push" ]]; then
      die "hooks already exist in $hooks_dir; use --protect-default=chain to wrap them or --protect-default=false to skip"
    fi
    wt_install_protect_hooks "$main_dir"
    return 0
  fi

  if [[ "$mode" == "false" ]]; then
    return 0
  fi

  if [[ "$mode" != "chain" ]]; then
    die "invalid --protect-default value: $mode (expected chain|false)"
  fi

  mkdir -p "$hooks_dir"
  local found_existing=false

  for hook in pre-commit pre-push; do
    local hook_path="$hooks_dir/$hook"
    local backup_path="$hook_path.git-wt.bak"
    if [[ -e "$hook_path" ]]; then
      found_existing=true
      if grep -q "git-wt hook wrapper" "$hook_path" 2>/dev/null; then
        continue
      fi
      if [[ -e "$backup_path" ]]; then
        die "refusing to overwrite existing hook backup: $backup_path"
      fi
      mv "$hook_path" "$backup_path"
    fi
  done

  if ! $found_existing; then
    echo "git-wt: no existing hooks to chain; installing protection hooks"
  fi

  wt_install_protect_hooks "$main_dir"
}

wt_hooks_pr_checkout() {
  local container="${1:?}"
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
  local container="${2:-}"
  local hooks_dir
  hooks_dir="$(wt_libexec_dir)/hooks"
  local hooks=()
  while IFS= read -r h; do
    [[ -n "$h" ]] && hooks+=("$h")
  done < <(wt_hooks_pr_checkout "$container")

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

wt_require_worktree_path() {
  local container="${1:?}"
  local target="${2:?}"
  local main_path
  main_path="$(wt_main_for "$container")"

  if [[ "$target" == "$main_path" ]]; then
    die "refusing to operate on main worktree: $target"
  fi

  local found=false
  while IFS= read -r line; do
    case "$line" in
      worktree\ "$target")
        found=true
        break
        ;;
    esac
  done < <(wt_git_for "$container" worktree list --porcelain)

  $found || die "path is not a worktree in this container: $target"
}

wt_branch_for_worktree_path() {
  local container="${1:?}"
  local target="${2:?}"
  local current_path=""
  local branch=""
  while IFS= read -r line; do
    case "$line" in
      worktree\ *)
        current_path="${line#worktree }"
        ;;
      branch\ refs/heads/*)
        if [[ "$current_path" == "$target" ]]; then
          branch="${line#branch refs/heads/}"
          break
        fi
        ;;
    esac
  done < <(wt_git_for "$container" worktree list --porcelain)
  echo "$branch"
}

wt_delete_branch_if_safe() {
  local container="${1:?}"
  local branch="${2:?}"
  local main_dir
  main_dir="$(wt_main_for "$container")"
  local git_main
  git_main() { git -C "$main_dir" "$@"; }

  local default_branch
  default_branch="$(wt_default_branch_for "$container")"
  case "$branch" in
    "$default_branch" | main | master | trunk)
      return 0
      ;;
  esac

  if git_main show-ref --verify --quiet "refs/heads/$branch"; then
    git_main branch -D "$branch"
  fi
}

wt_remove_worktree() {
  local container="${1:?}"
  local target="${2:?}"
  local delete_branch="${3:-false}"
  local force="${4:-false}"

  wt_require_worktree_path "$container" "$target"

  local main_dir
  main_dir="$(wt_main_for "$container")"
  local git_main
  git_main() { git -C "$main_dir" "$@"; }

  local branch default_branch pr_num
  branch="$(git -C "$target" branch --show-current 2>/dev/null || true)"
  pr_num=""
  if [[ "$branch" =~ ^pr/([0-9]+)$ ]]; then
    pr_num="${BASH_REMATCH[1]}"
  fi

  local rm_flags=()
  $force && rm_flags+=(--force)

  git_main worktree remove "${rm_flags[@]}" "$target"

  if $delete_branch && [[ -n "$branch" ]]; then
    wt_delete_branch_if_safe "$container" "$branch"
  fi

  if [[ -n "$pr_num" ]]; then
    local still_used=false
    while IFS= read -r line; do
      case "$line" in
        branch\ refs/heads/pr/"$pr_num")
          still_used=true
          break
          ;;
      esac
    done < <(git_main worktree list --porcelain)

    if ! $still_used; then
      git_main remote remove "pr-$pr_num" >/dev/null 2>&1 || true
    fi
  fi
}
