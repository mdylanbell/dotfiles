# safer ls detection across platforms
if (( $+commands[gls] )); then
  alias ls='gls --color=auto'
elif ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

if (( $+commands[colorls] )); then
  alias lc='colorls --sd -a'
fi
alias gitnp='git --no-pager'
alias git-branch-cp="git --no-pager branch --show-current | tr -d '[:space:]' | pbcopy"
alias pyclean="find . -name '*.pyc' -o -name '__pycache__' -exec rm -rf {} \;"
alias nvimr='NVIM_REVIEW=1 nvim'
