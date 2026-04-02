# Initialize Starship prompt
# This should run after plugins and options are configured, but before any
# local overrides. Starship will handle prompt rendering from this point.
if (( ${+commands[starship]} )); then
  eval "$(starship init zsh)"
fi
