# zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || mkdir -p "${ZINIT_HOME:h}"
[[ -d $ZINIT_HOME/.git ]] || git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Suppress username in agnoster prompt when it matches $USER
export DEFAULT_USER=$USER

# ----------------------------------------------------------------------
# Prompt theme
#
# Keep the theme early so the initial prompt looks correct from the start.
# prompt_subst is configured in 00-env.zsh to support dynamic segments.
# ----------------------------------------------------------------------
zinit light agnoster/agnoster-zsh-theme

# ----------------------------------------------------------------------
# Completion and fzf-tab configuration
#
# These styles should be set before 'compinit' runs. OMZ::lib/completion.zsh
# will eventually call compinit, and zinit's 'wait' will ensure these
# zstyles are already in place by then.
# ----------------------------------------------------------------------
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# fzf-tab specific configuration; kept close to generic completion styles
# so that all completion-related behavior is configured in one place.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# ----------------------------------------------------------------------
# Phase 1: Core OMZ libraries and completion layer
#
# Responsibilities:
#   - Load core OMZ libs (clipboard, history, key-bindings, etc.).
#   - Install extra completion definitions (zsh-completions) onto $fpath.
#   - Run compinit via OMZ::lib/completion.zsh, using $ZSH_COMPDUMP
#     (configured in 50-xdg.zsh to point into $XDG_CACHE_HOME).
#
# Ordering notes:
#   - zsh-users/zsh-completions appears before OMZ::lib/completion.zsh so
#     that its functions are visible to compinit.
#   - OMZ::lib/compfix.zsh is loaded before OMZ::lib/completion.zsh so the
#     completion-fix logic is available.
# ----------------------------------------------------------------------
zinit wait lucid light-mode for \
  OMZ::lib/clipboard.zsh                           \
  OMZ::lib/compfix.zsh                             \
  OMZ::lib/correction.zsh                          \
  OMZ::lib/directories.zsh                         \
  OMZ::lib/functions.zsh                           \
  OMZ::lib/git.zsh                                 \
  OMZ::lib/grep.zsh                                \
  OMZ::lib/history.zsh                             \
  OMZ::lib/key-bindings.zsh                        \
  OMZ::lib/spectrum.zsh                            \
  OMZ::lib/termsupport.zsh                         \
  blockf atpull'zinit creinstall -q .'             \
    zsh-users/zsh-completions                      \
  OMZ::lib/completion.zsh

# ----------------------------------------------------------------------
# Phase 2: Completion UI and interactive helpers
#
# Responsibilities:
#   - fzf-tab: replaces the built-in completion menu with an fzf UI.
#   - history-substring-search: incremental history search on the current
#     line, with a highlighted match.
#   - zsh-autosuggestions: ghost-text suggestions based on history.
#
# Ordering notes (from fzf-tab documentation):
#   - fzf-tab must be loaded after compinit but before widgets that wrap
#     completion, such as zsh-autosuggestions.
#   - fast-syntax-highlighting (another widget wrapper) is loaded in a
#     separate "Phase 3" block after this one.
# ----------------------------------------------------------------------
zinit wait lucid light-mode for \
  Aloxaf/fzf-tab                                   \
  atload"!export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=white,bold'" \
    zsh-users/zsh-history-substring-search        \
  atload"_zsh_autosuggest_start"                   \
    zsh-users/zsh-autosuggestions

# ----------------------------------------------------------------------
# Phase 3: Visual feedback (syntax highlighting)
#
# fast-syntax-highlighting decorates the command line with syntax-aware
# colors. It wraps ZLE widgets, so it should be loaded after fzf-tab and
# other completion-related wrappers. Using 'wait' defers its cost until
# after the first prompt, improving perceived startup time.
# ----------------------------------------------------------------------
zinit wait lucid light-mode for \
  zdharma-continuum/fast-syntax-highlighting

# ----------------------------------------------------------------------
# OMZ plugins
#
# Each of these plugins contributes aliases, functions, or keybindings
# (e.g., OMZP::fzf for ^R/^T/Alt-C). They do not wrap completion widgets
# in a way that conflicts with fzf-tab, so they can be deferred together.
# ----------------------------------------------------------------------
zinit wait lucid light-mode for \
  OMZP::1password \
  OMZP::aliases \
  OMZP::aws \
  OMZP::colored-man-pages \
  OMZP::docker \
  OMZP::fzf \
  OMZP::gem \
  OMZP::gh \
  OMZP::git \
  OMZP::jira \
  OMZP::jsontools \
  OMZP::k9s \
  OMZP::kubectl \
  OMZP::mise \
  OMZP::npm \
  OMZP::poetry \
  OMZP::pip \
  OMZP::python \
  OMZP::rust \
  OMZP::ssh \
  OMZP::ssh-agent \
  OMZP::urltools \
  OMZP::web-search
  # OMZP::httpie \  # not downloading 12/6/2025 for some reason
  # OMZP::go \
  # OMZP::jira \
  # OMZP::brew  # ??
