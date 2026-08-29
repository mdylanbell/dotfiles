export ANTIDOTE_HOME="${ANTIDOTE_HOME:-${XDG_CACHE_HOME:-${HOME}/.cache}/antidote}"
_antidote_source_dir="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/.antidote"
if [[ ! -r "${_antidote_source_dir}/antidote.zsh" ]]; then
  print -u2 "zsh: antidote source missing at ${_antidote_source_dir}; run 'mise run bootstrap:antidote'"
  unset _antidote_source_dir
  return
fi

source "${_antidote_source_dir}/antidote.zsh"
unset _antidote_source_dir

_zsh_plugins_file="${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"
if [[ ! -r "$_zsh_plugins_file" ]]; then
  _zsh_plugins_file="${DOTFILES_ROOT}/.config/zsh/.zsh_plugins.txt"
fi

_zsh_plugins_static_dir="${ZSH_CACHE_DIR}/antidote"
_zsh_plugins_static="${_zsh_plugins_static_dir}/.zsh_plugins.zsh"
mkdir -p "$_zsh_plugins_static_dir"

if [[ ! -r "$_zsh_plugins_static" ]]; then
  print -u2 "zsh: antidote bundle missing; run 'mise run update:antidote'"
  unset _zsh_plugins_file _zsh_plugins_static _zsh_plugins_static_dir
  return
fi

source "$_zsh_plugins_static"

(($+functions[_zsh_autosuggest_start])) && _zsh_autosuggest_start
(($+functions[fast-theme])) && fast-theme XDG:catppuccin-mocha >/dev/null 2>&1

unset _zsh_plugins_file _zsh_plugins_static _zsh_plugins_static_dir
