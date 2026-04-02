#
# Keybindings are grouped by when they apply:
# - editor mode: base emacs-style zle behavior
# - navigation: terminal/home/end/page keys while editing the command line
# - interactive widgets: plugin-provided bindings such as fzf history and Tab
#

# Editor mode: use emacs-style zle bindings by default.
bindkey -e

# Ctrl-X Ctrl-E: open the current command line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Up/Down search history by the currently typed prefix.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Terminal navigation keys: prefer terminfo when the terminal reports them.
# Up Arrow: search backward through history entries matching the current prefix.
[[ -n ${terminfo[kcuu1]:-} ]] && bindkey -- "${terminfo[kcuu1]}" up-line-or-beginning-search
# Down Arrow: search forward through history entries matching the current prefix.
[[ -n ${terminfo[kcud1]:-} ]] && bindkey -- "${terminfo[kcud1]}" down-line-or-beginning-search
# Home: move to the beginning of the command line.
[[ -n ${terminfo[khome]:-} ]] && bindkey -- "${terminfo[khome]}" beginning-of-line
# End: move to the end of the command line.
[[ -n ${terminfo[kend]:-} ]] && bindkey -- "${terminfo[kend]}" end-of-line
# Page Up: move backward through history without prefix filtering.
[[ -n ${terminfo[kpp]:-} ]] && bindkey -- "${terminfo[kpp]}" up-line-or-history
# Page Down: move forward through history without prefix filtering.
[[ -n ${terminfo[knp]:-} ]] && bindkey -- "${terminfo[knp]}" down-line-or-history

# Terminal navigation fallback sequences for terminals that do not expose the
# relevant terminfo entries cleanly.
# Up Arrow: search backward through history entries matching the current prefix.
bindkey '^[[A' up-line-or-beginning-search
# Down Arrow: search forward through history entries matching the current prefix.
bindkey '^[[B' down-line-or-beginning-search
# Home: move to the beginning of the command line.
bindkey '^[[1~' beginning-of-line
# End: move to the end of the command line.
bindkey '^[[4~' end-of-line
# Page Up: move backward through history without prefix filtering.
bindkey '^[[5~' up-line-or-history
# Page Down: move forward through history without prefix filtering.
bindkey '^[[6~' down-line-or-history

# Ctrl-R: open the fzf-backed history search widget when available.
(($+widgets[fzf-history-widget])) && bindkey '^R' fzf-history-widget

# Treat path separators and assignment operators as word boundaries so shell
# editing stops more naturally inside paths and key=value arguments.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

if (($+widgets[fzf-tab-complete])); then
  zle -A fzf-tab-complete _zsh_fzf_tab_complete_orig

  _zsh_fzf_tab_complete() {
    local ret

    zle _zsh_fzf_tab_complete_orig
    ret=$?

    # Tab completion can leave fast-syntax-highlighting stale when fzf-tab hits
    # a no-match path without changing BUFFER. Mark the previous highlight state
    # dirty, rerun highlighting, then repaint once.
    if ((ret != 0)); then
      if (($+functions[_zsh_highlight])); then
        typeset -g _ZSH_HIGHLIGHT_PRIOR_BUFFER=''
        _zsh_highlight
      fi
      zle -R
    fi

    return $ret
  }

  zle -N fzf-tab-complete _zsh_fzf_tab_complete
  # Tab: run standard completion first, then hand off ambiguous results to
  # fzf-tab's interactive completion UI.
  bindkey '^I' fzf-tab-complete

  # Rebind newly-defined user widgets through fast-syntax-highlighting so the
  # normal post-widget highlight refresh still runs on Tab completion paths.
  (($+functions[_zsh_highlight_bind_widgets])) && _zsh_highlight_bind_widgets >/dev/null 2>&1
fi
