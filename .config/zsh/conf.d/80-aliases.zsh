# safer ls detection across platforms
if (($+commands[gls])); then
  alias ls='gls --color=auto'
elif ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

if (($+commands[colorls])); then
  alias lc='colorls --sd -a'
fi

if command grep --version 2>/dev/null | head -n1 | grep -q 'GNU grep'; then
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

if diff --color=auto --version >/dev/null 2>&1; then
  alias diff='diff --color=auto'
fi
alias gitnp='git --no-pager'
alias git-branch-cp="git --no-pager branch --show-current | tr -d '[:space:]' | pbcopy"
alias nvimr='nvim -c "ReviewPR"'
# Work around glow not supporting var expansion (https://github.com/charmbracelet/glow/issues/776)
alias glow='glow -s $HOME/.config/glow/styles/catppuccin-mocha.json'

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
