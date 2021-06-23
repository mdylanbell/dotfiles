alias lc="colorls --sd -a"
alias gitnp="git --no-pager"
alias ctagsjs="ctags -R . && sed -i '' -E '/^(if|switch|function|module\.exports|it|describe).+language:js$/d' tags"
alias git-branch-cp="git --no-pager branch --show-current | tr -d '[:space:]' | pbcopy"
alias vimup="vi --headless +PlugUpdate +qall"
alias upd="brew update; brew upgrade; vi --headless +PlugUpdate +qall; omz update; zplug update"
alias pyclean="find . -name '*.pyc' -o -name '__pycache__' -exec rm -rf {} \;"

git-push-again () {
  git commit --amend --no-edit && git push origin +$(git branch --show-current)
}
