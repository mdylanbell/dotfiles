# Make local and cached completion functions available before compinit runs.
_zsh_local_completions_dir="${ZDOTDIR:-$HOME/.config/zsh}/completions"
if [[ -d "$_zsh_local_completions_dir" ]]; then
  typeset -gU fpath
  fpath=("$_zsh_local_completions_dir" $fpath)
fi

_zsh_cache_dir_init
_zsh_cache_completions_dir="${ZSH_CACHE_DIR}/completions"
if [[ -d "$_zsh_cache_completions_dir" ]]; then
  typeset -gU fpath
  fpath=("$_zsh_cache_completions_dir" $fpath)
fi

unset _zsh_local_completions_dir
unset _zsh_cache_completions_dir
