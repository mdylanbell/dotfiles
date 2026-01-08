export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:=${HOME}/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=${HOME}/.cache}
export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
if [ -f $ZDOTDIR/.zshenv ]; then
  source $ZDOTDIR/.zshenv
fi

# XDG_RUNTIME_DIR fallback for mac
if [ -z "${XDG_RUNTIME_DIR-}" ]; then
    export XDG_RUNTIME_DIR="${TMPDIR-/tmp}/runtime-$UID"
    if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
        mkdir -p "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

# cargo / rust
if [ -f "${XDG_DATA_HOME}/cargo/env" ]; then
  source "$XDG_DATA_HOME"/cargo/env
elif [ -f "${HOME}/.cargo/env" ]; then
  source "$HOME"/.cargo/env
fi
