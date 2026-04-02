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

# ez-compinit provides the compinit baseline; keep styles local and explicit.
zstyle ':plugin:ez-compinit' compstyle 'none'
zstyle ':plugin:ez-compinit' use-cache yes

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|?=**'
zstyle ':completion:*' menu no
zstyle ':completion:*' special-dirs true

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -d $realpath ]]; then
    eza -1 --color=always --group-directories-first $realpath
  elif [[ -f $realpath ]]; then
    if file --mime "$realpath" | grep -q "charset=binary"; then
      file "$realpath"
    else
      bat --color=always --style=plain --line-range=:200 "$realpath"
    fi
  else
    file "$realpath" 2>/dev/null || print -r -- "$realpath"
  fi
'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg:2 '--preview-window=right,50%,<40(hidden)'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

if [[ ! -r "$_zsh_plugins_static" ]]; then
  print -u2 "zsh: antidote bundle missing; run 'mise run update:antidote'"
  unset _zsh_plugins_file _zsh_plugins_static _zsh_plugins_static_dir
  return
fi

source "$_zsh_plugins_static"

(($+functions[_zsh_autosuggest_start])) && _zsh_autosuggest_start
(($+functions[fast-theme])) && fast-theme XDG:catppuccin-mocha >/dev/null 2>&1

unset _zsh_plugins_file _zsh_plugins_static _zsh_plugins_static_dir
