ANTIDOTE_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"
[[ -r "${ANTIDOTE_HOME}/antidote.zsh" ]] || return
source "${ANTIDOTE_HOME}/antidote.zsh"

_zsh_plugins_file="${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"
if [[ ! -r "$_zsh_plugins_file" ]]; then
  _zsh_plugins_file="${DOTFILES_ROOT:-$HOME/.dotfiles}/.config/zsh/.zsh_plugins.txt"
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
