" colors.vim

if !has('nvim')
  set redraw
else
  set inccommand=nosplit
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/bin/python3'

  set termguicolors

  " Term emulation stuff, not sure if required
  let &t_8f = "\e[38;2;%lu;%lu;%lum"
  let &t_8b = "\e[48;2;%lu;%lu;%lum"
  let &t_ut=''

  " Set the terminal default background and foreground colors, thereby
  " improving performance by not needing to set these colors on empty cells.
  hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
  let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
  let &t_te = &t_te . "\033]110\007\033]111\007"
endif

syntax enable
set bg=dark
if has('nvim')
  colorscheme NeoSolarized
else
  let g:solarized_termtrans = 0
  let g:solarized_termcolors = &t_Co
  colorscheme solarized
endif
