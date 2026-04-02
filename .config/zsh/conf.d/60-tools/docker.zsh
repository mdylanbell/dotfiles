# Generate Docker completions into the shared zsh completion cache.
command docker --version >/dev/null 2>&1 || return
_zsh_cache_completion docker _docker completion zsh || true
