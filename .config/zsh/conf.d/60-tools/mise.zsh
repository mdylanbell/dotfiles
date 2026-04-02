if (($+commands[mise])); then
  eval "$(mise activate zsh)"
  _zsh_cache_completion mise _mise completion zsh || true
fi
