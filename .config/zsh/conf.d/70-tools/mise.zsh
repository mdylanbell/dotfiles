# Activate mise (version/runtime manager) if present
# if (( $+commands[mise] )); then
#   eval "$(mise activate zsh)"
# fi

# Default Python packages installed by mise after python install/upgrade
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/mise/default-python-packages"
