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
alias nvimr='nvim -c "ReviewPR"'

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
  find . \( \
    -name '*.pyc' -o \
    -name '*.pyo' -o \
    -name '__pycache__' -o \
    -name '.ruff_cache' -o \
    -name '.pytest_cache' -o \
    -name '.mypy_cache' -o \
    -name '.hypothesis' -o \
    -name '.tox' -o \
    -name '.nox' -o \
    -name '.eggs' -o \
    -name 'pip-wheel-metadata' -o \
    -name 'build' -o \
    -name 'dist' \
    \) -exec rm -rf {} +
}
