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

# env.local.zsh is the supported place to set machine-local DOTFILES_FEATURES.
if [[ -r "${ZDOTDIR:-$HOME/.config/zsh}/env.local.zsh" ]]; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/env.local.zsh"
fi

# Keep defaults shell-local so bootstrap can distinguish them from explicit
# inputs. Empty features remain a valid "none" selection.
DOTFILES_ENV="${DOTFILES_ENV:-personal}"
DOTFILES_FEATURES="${DOTFILES_FEATURES-}"

# ---- mise env ----
append_mise_env() {
  local value="$1"
  case ",${composed_mise_env}," in
    *,"${value}",*) ;;
    *) composed_mise_env="${composed_mise_env:+${composed_mise_env},}${value}" ;;
  esac
}

dotfiles_env_error() {
  printf '%s\n' "$1" >&2
}

compose_mise_env() {
  local feature
  local intersection_config
  local remaining_features

  case "${DOTFILES_ENV}" in
    personal | work) ;;
    *)
      dotfiles_env_error "unsupported DOTFILES_ENV value: ${DOTFILES_ENV}"
      return 1
      ;;
  esac

  composed_mise_env=""
  has_workstation=0
  has_gui=0

  if [[ -n "${DOTFILES_FEATURES}" ]]; then
    if [[ "${DOTFILES_FEATURES}" == *, ]]; then
      dotfiles_env_error "DOTFILES_FEATURES contains an empty token"
      return 1
    fi

    remaining_features="${DOTFILES_FEATURES}"
    while [[ -n "${remaining_features}" ]]; do
      if [[ "${remaining_features}" == *,* ]]; then
        feature="${remaining_features%%,*}"
        remaining_features="${remaining_features#*,}"
      else
        feature="${remaining_features}"
        remaining_features=""
      fi

      case "${feature}" in
        workstation | gui)
          if [[ "${feature}" == "workstation" ]]; then
            has_workstation=1
          else
            has_gui=1
          fi
          ;;
        "")
          dotfiles_env_error "DOTFILES_FEATURES contains an empty token"
          return 1
          ;;
        *)
          dotfiles_env_error "unsupported DOTFILES_FEATURES value: ${feature}"
          return 1
          ;;
      esac
    done
  fi

  append_mise_env "${DOTFILES_ENV}"

  for feature in workstation gui; do
    if [[ "${feature}" == "workstation" && "${has_workstation}" -ne 1 ]]; then
      continue
    fi
    if [[ "${feature}" == "gui" && "${has_gui}" -ne 1 ]]; then
      continue
    fi

    append_mise_env "${feature}"

    intersection_config="${DOTFILES_ROOT}/.config/mise/config.${DOTFILES_ENV}-${feature}.toml"
    if [[ -f "${intersection_config}" ]]; then
      append_mise_env "${DOTFILES_ENV}-${feature}"
    fi
  done

  if [[ "${ZSH_OS}" == "wsl" ]]; then
    append_mise_env "wsl"
  fi
}

if [[ -n "${MISE_ENV-}" ]]; then
  export MISE_ENV
else
  compose_mise_env || return 1 2>/dev/null || exit 1
  export MISE_ENV="${composed_mise_env}"
fi

# ---- secrets / integrations ----
export DOTFILES_1PASSWORD_VAULT="${DOTFILES_1PASSWORD_VAULT:-dotfiles-${DOTFILES_ENV}}"
