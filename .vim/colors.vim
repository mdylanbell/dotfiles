" colors.vim

" Term emulation stuff, not sure if required
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if !has('nvim')
  set redraw
else
  if has('macunix')
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
  else
    let g:python2_host_prog = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
  endif

" Set the terminal default background and foreground colors, thereby
" improving performance by not needing to set these colors on empty cells.
" hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
" let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
" let &t_te = &t_te . "\033]110\007\033]111\007"
endif

syntax enable
set background=dark

if has('nvim')
  colorscheme NeoSolarized
  let g:neosolarized_bold = 1
  let g:neosolarized_underline = 1
else
  let g:solarized_termtrans = 0
  let g:solarized_termcolors = &t_Co
  "let g:solarized_termcolors = 16
  colorscheme solarized
endif

" GitGutter
highlight GitGutterAdd ctermbg=0 guibg=#073642 guisp=#93a1a1
highlight GitGutterChange ctermbg=0 guibg=#073642 guisp=#93a1a1
highlight GitGutterDelete ctermbg=0 guibg=#073642 guisp=#93a1a1
highlight GitGutterChangeDelete ctermbg=0 guibg=#073642 guisp=#93a1a1

"cterm=bold
highlight CursorLineNr ctermbg=white ctermfg=black guibg=white guisp=black
