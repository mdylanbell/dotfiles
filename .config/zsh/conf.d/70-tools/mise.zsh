# Activate mise (version/runtime manager) if present
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi
