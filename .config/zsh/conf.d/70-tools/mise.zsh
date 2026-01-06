# NOTE: Currently using a zinit plugin for mise activation and copmletions
# Activate mise (version/runtime manager) if present
# if (( $+commands[mise] )); then
#   eval "$(mise activate zsh)"
# fi

# Default python packages installed by mise after python install/upgrade
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME"/mise/default-python-packages

# Default node packages installed by mise after python install/upgrade
export MISE_NODE_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME"/mise/default-node-packages
