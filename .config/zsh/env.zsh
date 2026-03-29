# Detect OS
if [[ "$(uname -r)" == *[Mm]icrosoft* ]]; then
  ZSH_OS="wsl"
else
  case $OSTYPE in
    darwin*) ZSH_OS=darwin ;;
    linux*) ZSH_OS=linux ;;
    *) ZSH_OS=${OSTYPE%%-*} ;;
  esac
fi
export ZSH_OS

if [[ -r "${ZDOTDIR:-$HOME/.config/zsh}/env.local.zsh" ]]; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/env.local.zsh"
fi

export DOTFILES_ENV="${DOTFILES_ENV:-personal}"

# ---- mise env ----
# Let MISE_ENV follow DOTFILES_ENV by default, but preserve an explicit override.
export MISE_ENV="${MISE_ENV:-$DOTFILES_ENV},${ZSH_OS}"

# ---- secrets / integrations ----
export DOTFILES_1PASSWORD_VAULT="${DOTFILES_1PASSWORD_VAULT:-dotfiles-${DOTFILES_ENV}}"
