setlocal backspace=2
setlocal expandtab
setlocal shiftwidth=2
setlocal smarttab
setlocal tabstop=2

setlocal suffixesadd+=.rb

let ruby_operators = 1
let ruby_space_errors = 1
let ruby_fold = 1

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['rubocop']
