" fold go files with syntax
setlocal foldmethod=syntax
setlocal foldnestmax=1

" use goimports for formatting
let g:go_fmt_command = "goimports"
let g:go_fmt_experimental=1

setlocal nolist
setlocal tabstop=2 shiftwidth=2
