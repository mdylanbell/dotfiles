# initialize zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# setup agnoster prompt
setopt prompt_subst
zinit light agnoster/agnoster-zsh-theme

# load plugins
zinit wait lucid light-mode for \
  OMZ::lib/git.zsh \
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

# https://github.com/zdharma/zinit-configs/blob/a60ff64823778969ce2b66230fd8cfb1a957fe89/psprint/zshrc.zsh#L277
zinit wait lucid for \
 silent atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 as"completion" \
    zsh-users/zsh-completions \
 atload"!export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=white,bold'" \
    zsh-users/zsh-history-substring-search \
 pick"zsh-interactive-cd.plugin.zsh" \
    changyuheng/zsh-interactive-cd

export EDITOR='vi'
export VISUAL='vi'

if [ "$TERM" = "kitty" ]; then
  kitty + complete setup zsh | source /dev/stdin
fi

export CLICOLOR=1

# Turn off share_history, enabled by zsh
unsetopt share_history

# load more stuff
for cfg_file in .zshrc.load .shellrc.load .profile; do
  cfg="$HOME/${cfg_file}"
  [[ -s $cfg ]] && source ${cfg}
done
