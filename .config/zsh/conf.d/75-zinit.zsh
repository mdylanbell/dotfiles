# zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || mkdir -p "${ZINIT_HOME:h}"
[[ -d $ZINIT_HOME/.git ]] || git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ----------------------------------------------------------------------
# compinit configuration (zinit-managed)
#
# We let zinit run `compinit` via `zicompinit; zicdreplay`. The options
# are configured once here:
#   - Use `-i` to skip insecure-dir checks (assuming permissions are OK).
#   - If $ZSH_COMPDUMP is set (50-xdg.zsh), also pass `-d $ZSH_COMPDUMP`
#     so the dump file lives under XDG. Otherwise, fall back to zsh's
#     default .zcompdump path.
# ----------------------------------------------------------------------
if [[ -n ${ZSH_COMPDUMP:-} ]]; then
  ZINIT[COMPINIT_OPTS]="-i -d $ZSH_COMPDUMP"
else
  ZINIT[COMPINIT_OPTS]="-i"
fi

# ----------------------------------------------------------------------
# Phase 1: Core OMZ libraries and completion definitions
#
# Responsibilities:
#   - Load core OMZ libs (clipboard, history, key-bindings, etc.).
#   - Install extra completion definitions (zsh-completions) onto $fpath.
#   - Load OMZ's completion library, which:
#       * Tunes completion-related options and zstyles.
#       * Configures completion caching and COMPLETION_WAITING_DOTS.
#       * Enables bashcompinit for bash-style completions.
#
# Note:
#   - OMZ::lib/completion.zsh does *not* call compinit; the actual
#     compinit run is delegated to zinit in Phase 2.
# ----------------------------------------------------------------------
zinit lucid light-mode for \
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
# Completion and fzf-tab configuration
#
# These styles must be in place before compinit runs so that the
# resulting completion behavior reflects these settings. OMZ's
# completion library has already set its defaults; the styles below
# layer on top / override where needed.
# ----------------------------------------------------------------------
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# fzf-tab specific configuration; kept close to generic completion styles
# so all completion-related behavior is configured in one place.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# ----------------------------------------------------------------------
# Phase 2: Completion UI and interactive helpers
#
# Responsibilities:
#   - fzf-tab: replaces the default completion menu with an fzf UI.
#   - history-substring-search: incremental history search with highlight.
#   - zsh-autosuggestions: inline ghost-text suggestions.
#
# compinit:
#   - zinit intercepts compdef calls from Phase 1 (OMZ libs, zsh-
#     completions) and from the plugins below.
#   - Via `atinit"zicompinit; zicdreplay"` on fzf-tab, zinit runs
#       compinit $ZINIT[COMPINIT_OPTS]
#     exactly once, then replays all recorded compdef calls.
# ----------------------------------------------------------------------
zinit lucid light-mode for \
  atinit"zicompinit; zicdreplay"                    \
    Aloxaf/fzf-tab                                  \
  atload"!export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=white,bold'" \
    zsh-users/zsh-history-substring-search          \
  atload"_zsh_autosuggest_start"                    \
    zsh-users/zsh-autosuggestions

# ----------------------------------------------------------------------
# Phase 3: Visual feedback (syntax highlighting)
#
# fast-syntax-highlighting decorates the command line with syntax-aware
# colors. It wraps ZLE widgets, so it should load after the completion
# system is in place. Using `wait` defers its cost until after the first
# prompt, improving perceived startup latency.
# ----------------------------------------------------------------------
# TODO: specify theme in colors.zsh
zinit wait lucid light-mode for \
  atload"fast-theme XDG:catppuccin-mocha > /dev/null 2>&1" \
    zdharma-continuum/fast-syntax-highlighting

# ----------------------------------------------------------------------
# OMZ plugins
#
# Each of these plugins contributes aliases, functions, or keybindings
# (e.g., OMZP::fzf for ^R/^T/Alt-C). They do not own the completion
# system, so we can safely defer them with `wait` for better startup
# behavior.
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
