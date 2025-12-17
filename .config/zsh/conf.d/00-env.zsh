export EDITOR='nvim'
export VISUAL='nvim'
export CLICOLOR=1

# detect OS early for loader
case $OSTYPE in
  darwin*) ZSH_OS=darwin ;;
  linux*) ZSH_OS=linux ;;
  *) ZSH_OS=${OSTYPE%%-*} ;;
esac
export ZSH_OS

# history location (XDG state)
export HISTFILE="$XDG_STATE_HOME"/zsh/history

# set default mise env; override in local.zsh if something else is needed (e.g. work)
export MISE_ENV=personal
