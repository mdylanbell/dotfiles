# Make local completion functions available before zinit runs compinit.
_zsh_local_completions_dir="${ZDOTDIR:-$HOME/.config/zsh}/completions"
if [[ -d "$_zsh_local_completions_dir" ]]; then
  typeset -gU fpath
  fpath=("$_zsh_local_completions_dir" $fpath)
fi
unset _zsh_local_completions_dir
