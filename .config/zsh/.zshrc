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
  atinit"zicompinit; zicdreplay"                   \
      zdharma-continuum/fast-syntax-highlighting   \
  atload"_zsh_autosuggest_start"                   \
      zsh-users/zsh-autosuggestions                \
  blockf atpull'zinit creinstall -q .'             \
      zsh-users/zsh-completions                    \
  atload"!export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=white,bold'" \
     zsh-users/zsh-history-substring-search \
  pick"zsh-interactive-cd.plugin.zsh" \
     changyuheng/zsh-interactive-cd

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

# xdg tweaks
export HISTFILE="$XDG_STATE_HOME"/zsh/history
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# Activate mise (version/runtime manager)
eval "$(mise activate zsh)"
