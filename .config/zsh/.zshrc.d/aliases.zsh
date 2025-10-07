alias lc='colorls --sd -a'
alias gitnp='git --no-pager'
alias git-branch-cp="git --no-pager branch --show-current | tr -d '[:space:]' | pbcopy"
alias pyclean="find . -name '*.pyc' -o -name '__pycache__' -exec rm -rf {} \;"
alias ls='ls --color'

# git-push-again () {
#   git commit --amend --no-edit && git push origin +$(git branch --show-current)
# }
