# zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || mkdir -p "${ZINIT_HOME:h}"
[[ -d $ZINIT_HOME/.git ]] || git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# hide username in prompt when local
if (( $+commands[whoami] )); then
  export DEFAULT_USER=$(whoami)
fi

# theme first, like origin/main (prompt_subst already set in 00-env)
zinit light agnoster/agnoster-zsh-theme

# OMZ libs + helpers (skip their compinit; we run it in 86-compinit.zsh)
skip_global_compinit=1
zinit light-mode for \
  OMZ::lib/clipboard.zsh                           \
  OMZ::lib/compfix.zsh                             \
  OMZ::lib/completion.zsh                          \
  OMZ::lib/correction.zsh                          \
  OMZ::lib/directories.zsh                         \
  OMZ::lib/functions.zsh                           \
  OMZ::lib/git.zsh                                 \
  OMZ::lib/history.zsh                             \
  OMZ::lib/key-bindings.zsh                        \
  OMZ::lib/spectrum.zsh                            \
  OMZ::lib/termsupport.zsh                         \
  Aloxaf/fzf-tab                                   \
  atload"!export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=white,bold'" \
     zsh-users/zsh-history-substring-search        \
  atload"_zsh_autosuggest_start"                   \
      zsh-users/zsh-autosuggestions                \
  blockf atpull'zinit creinstall -q .'             \
      zsh-users/zsh-completions

# fast-syntax-highlighting (keep PATH clean during load)
zinit ice atinit'PATH=/bin:/usr/bin:/usr/sbin:/sbin:$PATH'
zinit light zdharma-continuum/fast-syntax-highlighting

# OMZ plugins (single block, includes fzf as in origin/main)
zinit lucid light-mode for \
  OMZP::asdf \
  OMZP::aws \
  OMZP::bundler \
  OMZP::colored-man-pages \
  OMZP::docker \
  OMZP::fzf \
  OMZP::gem \
  OMZP::git \
  OMZP::jira \
  OMZP::jsontools \
  OMZP::npm \
  OMZP::pip \
  OMZP::python \
  OMZP::rvm \
  OMZP::ssh-agent \
  OMZP::urltools \
  OMZP::web-search

# zstyle config
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

unset skip_global_compinit
