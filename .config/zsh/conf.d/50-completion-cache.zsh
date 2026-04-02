# Normalize and expose the shared zsh cache directory.
_zsh_cache_dir_init() {
  typeset -g ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}"
}

# Cache native zsh completions under $ZSH_CACHE_DIR/completions.
_zsh_cache_completion() {
  emulate -L zsh
  setopt no_aliases pipefail

  local command_name=$1
  local completion_name=$2
  shift 2

  (($+commands[$command_name])) || return 1

  _zsh_cache_dir_init

  local completion_dir="$ZSH_CACHE_DIR/completions"
  local completion_file="$completion_dir/$completion_name"
  local tmp_file="${completion_file}.tmp.$$"

  mkdir -p "$completion_dir" || return 1

  if [[ ! -s $completion_file || ${commands[$command_name]} -nt $completion_file ]]; then
    if "$command_name" "$@" >|"$tmp_file"; then
      mv -f "$tmp_file" "$completion_file"
    else
      rm -f "$tmp_file"
      return 1
    fi
  fi
}
