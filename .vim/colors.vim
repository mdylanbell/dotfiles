" colors.vim

if !has('nvim')
  set redraw
else
  " Set the terminal default background and foreground colors, thereby
  " improving performance by not needing to set these colors on empty cells.
  " hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
  " let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
  " let &t_te = &t_te . "\033]110\007\033]111\007"
endif

syntax enable
set background=dark

if has('nvim')
  " Term emulation stuff, not sure if required
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif

  colorscheme NeoSolarized
  let g:neosolarized_bold = 1
  let g:neosolarized_underline = 1

  " GitGutter
  highlight GitGutterAdd ctermbg=0 guibg=#073642 guisp=#93a1a1
  highlight GitGutterChange ctermbg=0 guibg=#073642 guisp=#93a1a1
  highlight GitGutterDelete ctermbg=0 guibg=#073642 guisp=#93a1a1
  highlight GitGutterChangeDelete ctermbg=0 guibg=#073642 guisp=#93a1a1
else
  let g:solarized_termtrans = 0
  " let g:solarized_termcolors = &t_Co
  let g:solarized_termcolors = 16
  colorscheme solarized

  " GitGutter
  highlight link GitGutterAdd DiffAdd
  highlight link GitGutterChange DiffChange
  highlight link GitGutterDelete DiffDelete
  highlight link GitGutterChangeDelete DiffText
endif

" Set up line highlighting
highlight CursorLineNr ctermbg=white ctermfg=black guibg=white guisp=black

highlight! link ALEWarningSign DiffChange
highlight! link ALEErrorSign DiffDelete
