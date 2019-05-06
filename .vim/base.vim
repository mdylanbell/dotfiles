" base.vim

set nocompatible

set autoindent
set backspace=indent,eol,start
set colorcolumn=80
set cursorline

" Always do vimdiff in vertical splits
set diffopt+=vertical

set expandtab
set exrc " Run local vimrc, set secure disables unsafe commands
set secure
set foldmethod=marker
set history=100
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set nowarn
set number
set ruler

" printing options
set printoptions=paper:letter
set printdevice=dev_np24

" always show 5 lines of context
set scrolloff=5

" Enable global session caching (for Taboo)
set sessionoptions+=globals

set shell=/bin/bash
set shiftwidth=4
set showmatch
set showmode
set smartcase
set smarttab

" look for tags
set tags=./tags;

set tabstop=4
set terse
set timeout

" for gitgutter
set updatetime=100

set wildmenu

runtime macros/matchit.vim

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

" configure vim-plug
call plug#begin('~/.vim/plugged')
" supertab needs to come first
Plug 'ervandew/supertab'
if has('nvim')
  Plug 'iCyMind/NeoSolarized'
  Plug 'autozimu/LanguageClient-neovim', {  'do': 'bash install.sh' }
else
  Plug 'altercation/vim-colors-solarized'
endif
Plug 'AndrewRadev/sideways.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'SirVer/ultisnips'
Plug 'Valloric/YouCompleteMe'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'craigemery/vim-autotag'
Plug 'dhruvasagar/vim-table-mode'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'gcmt/taboo.vim'
Plug 'godlygeek/tabular'
"Plug 'guns/vim-sexp'
Plug 'honza/vim-snippets'
Plug 'int3/vim-extradite'
Plug 'janko-m/vim-test'
Plug 'jeetsukumaran/vim-buffergator'
" Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/gv.vim'
Plug 'kassio/neoterm'
Plug 'kien/ctrlp.vim'
Plug 'krisajenkins/vim-pipe'
Plug 'luochen1990/rainbow'
Plug 'majutsushi/tagbar'
Plug 'mattboehm/vim-unstack'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mbbill/undotree'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-node'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'python-mode/python-mode'
Plug 'qpkorr/vim-bufkill'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree',
Plug 'sjl/gundo.vim'
Plug 'slim-template/vim-slim'
Plug 'stevearc/vim-arduino'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rhubarb'
"Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-perl/vim-perl',
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/L9'
Plug 'vim-vdebug/vdebug'
Plug 'w0rp/ale'
Plug 'yalesov/vim-ember-script'
call plug#end()

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
    else
      call pmb#openurl(a:url)
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

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
