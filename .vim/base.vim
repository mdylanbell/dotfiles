" base.vim

" Basics {{{
set nocompatible

" Use modern encoding
set encoding=utf-8
scriptencoding utf-8

set exrc " Run local vimrc, set secure disables unsafe commands
set secure
set history=100
set laststatus=2

set shell=/bin/bash
" }}}

" UI {{{
set colorcolumn=81
set cursorline

set number
set ruler

" Search
set hlsearch
set ignorecase
set incsearch
set nowarn

set showmatch
set showmode
set smartcase

" for gitgutter
set updatetime=100

set wildmenu

" Always do vimdiff in vertical splits
set diffopt+=vertical
" }}}

" Editing {{{
" Indentation {{{
set autoindent
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4
set smarttab
set expandtab
" }}}

" Folds {{{
set foldclose=all
set foldenable
set foldmethod=marker
set foldlevelstart=99
set foldnestmax=7 " 5
set foldopen+=jump
" }}}

" printing options
set printoptions=paper:letter
set printdevice=dev_np24

" always show 5 lines of context
set scrolloff=5

" Enable global session caching (for Taboo)
set sessionoptions+=globals

" look for tags
set tags=./tags;

set terse
set timeout
" }}}

" {{{ Testing new stuff

 if v:version >= 704
  " j Remove comment leader when joining lines (added in Vim 7.4)
  set formatoptions+=j
endif

set ttyfast

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

set lazyredraw

" Maintain indent when wrapping
if exists('+breakindent')
  set breakindent
endif

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

set list
" Highlight trailing spaces
set listchars=trail:·,tab:»·
" Show wrap indicators
set listchars+=extends:»,precedes:«

" Hide the intro screen, use [+] instead of [Modified], use [RO] instead
" of [readyonly], and don't give completion match messages
set shortmess+=Imrc

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
  autocmd!
  autocmd FileType help,qf nnoremap <buffer> q :q<cr>
  autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
  autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
  " Undo <cr> -> : shortcut
  autocmd FileType help,qf nnoremap <buffer> <cr> <cr>
augroup END

set completeopt=longest,menuone,noinsert,noselect,preview

" }}}

" the famous leader character
let mapleader = ','
let maplocalleader = ","
" map backslash to comma so reversing line search is fast
nnoremap \ ,

" Specify python paths
if has('macunix')
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python2_host_prog = '/usr/bin/python'
  let g:python3_host_prog = '/usr/bin/python3'
endif


" for some reason this has to go in .vimrc
let perl_fold = 1
let perl_fold_anonymous_subs = 1

" use system clipboard for everything
if has("gui_running")
    set clipboard=unnamed
    set guioptions-=T
endif

if exists('&inccommand')
  set inccommand=nosplit
endif

" enable persistent undo
if v:version >= 703
  " ensure undo directory exists
  if !isdirectory("~/.vimundo")
    call system("mkdir ~/.vimundo")
  endif

  set undodir=~/.vimundo
  set undofile
  set undolevels=1000
  set undoreload=10000
endif

" allow writing files as root
command! W silent w !sudo tee % > /dev/null

" open web browser, mostly for vim-fugitive
command! -nargs=1 Browse call OpenURL(<f-args>)

function! OpenURL(url)
  if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
      call system("open ".a:url)
    endif
  endif
endfunction

" Autoclose loclist when related buffer is closed  (namely for :ALELint)
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" .t files are perl
au BufNewFile,BufRead *.t set filetype=perl

" tt and mt files are tt2html
au BufNewFile,BufRead *.tt set filetype=tt2html
au BufNewFile,BufRead *.mt set filetype=tt2html

let g:vim_json_syntax_conceal = 0
au FileType json setlocal foldmethod=syntax

function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction

" remove trailing whitespace when writing
autocmd BufWritePre * :%s/\s\+$//e
