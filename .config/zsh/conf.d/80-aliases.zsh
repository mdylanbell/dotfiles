# normalize interactive ls across macOS and Linux
if (($+commands[gls])); then
  alias ls='gls --color=auto'
elif ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

if command grep --version 2>/dev/null | head -n1 | grep -q 'GNU grep'; then
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

if diff --color=auto --version >/dev/null 2>&1; then
  alias diff='diff --color=auto'
fi

# custom nvim review mode
alias nvimr='nvim -c "Pier open"'

# Work around glow not supporting var expansion (https://github.com/charmbracelet/glow/issues/776)
alias glow='glow -s $HOME/.config/glow/styles/catppuccin-mocha.json'

gcb() {
  local branch
  branch="$(git --no-pager branch --show-current 2>/dev/null | tr -d '[:space:]')"

  if [[ -z $branch ]]; then
    return 1
  fi

  clipboard_copy "$branch"
}

pyclean() {
  fd --hidden --no-ignore --exclude .git \
    --glob \
'{'\
'.venv,'\
'*.pyc,'\
'*.pyo,'\
'__pycache__,'\
'.ruff_cache,'\
'.pytest_cache,'\
'.mypy_cache,'\
'.hypothesis,'\
'.tox,'\
'.nox,'\
'.eggs,'\
'pip-wheel-metadata,'\
'build,'\
'dist'\
'}' \
    --exec-batch rm -rf
}
