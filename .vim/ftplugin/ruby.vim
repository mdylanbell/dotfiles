set backspace=2
set expandtab
set shiftwidth=2
set smarttab
set tabstop=2

let ruby_operators = 1
let ruby_space_errors = 1
let ruby_fold = 1

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['rubocop']
