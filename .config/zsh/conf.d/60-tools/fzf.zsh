# use fd, follow links, show hidden files, follow symlinks
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-mocha.sh
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# Prefer plain completion semantics when fzf falls back, rather than zsh's
# more expansion-heavy default widget.
typeset -g fzf_default_completion=complete-word

# Keep Ctrl-R inline, but place the prompt at the top so results appear
# directly beneath it instead of accumulating empty space above the list.
export FZF_CTRL_R_OPTS='--height 50% --layout=reverse'

# Load fzf's native shell integration for Ctrl-R / Ctrl-T / Alt-C.
if (($+commands[fzf])) && [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]]; then
  if fzf --zsh >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
  else
    local fzf_shell_dir

    for fzf_shell_dir in \
      /home/linuxbrew/.linuxbrew/opt/fzf/shell \
      /usr/local/opt/fzf/shell \
      /usr/share/fzf \
      /usr/share/doc/fzf/examples; do
      [[ -r $fzf_shell_dir/completion.zsh ]] && source "$fzf_shell_dir/completion.zsh"
      [[ -r $fzf_shell_dir/key-bindings.zsh ]] && source "$fzf_shell_dir/key-bindings.zsh"
    done
  fi
fi

# Keep fzf's history/file/cd bindings, but leave Tab owned by the standard
# completion system so fzf-tab wraps `complete-word` instead of `fzf-completion`.
if [[ -o interactive ]] && (($+widgets[complete-word])); then
  bindkey '^I' complete-word
fi

# TODO: Also define solarized colors and make FZF_DEFAULT_OPTS = selected scheme
