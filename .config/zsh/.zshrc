export EDITOR='nvim'
export VISUAL='nvim'

if [ "$TERM" = "kitty" ]; then
  kitty + complete setup zsh | source /dev/stdin
fi

export CLICOLOR=1

# Turn off share_history, enabled by zsh
unsetopt share_history

# load remaining config -- local, os specific, and others in .zshrc.d
[[ -s "$ZDOTDIR"/.zshrc.load ]] && source "$ZDOTDIR"/.zshrc.load

# Activate mise (version/runtime manager)
eval "$(mise activate zsh)"
# FZF
# use fd, follow links, show hidden files, follow symlinks
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_COLORS="bg+:-1,bg:-1,fg:254,fg+:254,hl:61,hl+:61,info:136,prompt:136,pointer:61,marker:61,spinner:136,header:136,border:254"

# initialize zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# setup agnoster prompt
setopt prompt_subst
zinit light agnoster/agnoster-zsh-theme

# load OMZ stuff
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
  atinit"zicompinit; zicdreplay"                   \
      zdharma-continuum/fast-syntax-highlighting   \
  blockf atpull'zinit creinstall -q .'             \
      zsh-users/zsh-completions
  # pick"zsh-interactive-cd.plugin.zsh"            \
  #    changyuheng/zsh-interactive-cd

# load plugins
zinit wait lucid light-mode for \
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
  # OMZP::httpie
  # OMZP::macos
  # OMZP::pep8

## zstyle
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
# TODO: Fix coloring -- green default?
# zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# xdg tweaks
export HISTFILE="$XDG_STATE_HOME"/zsh/history
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
