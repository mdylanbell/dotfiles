" base.vim

set nocompatible
set ai to shell=/bin/bash terse nowarn sm ruler sw=4 ts=4

"set noremap
set hls
set bs=2
set history=100
set showmode
set incsearch
"set ignorecase
set smartcase
set expandtab smarttab

runtime macros/matchit.vim

set foldmethod=marker

" printing options
set popt=paper:letter
set printdevice=dev_np24


" the famous leader character
let mapleader = ','
let maplocalleader = ","
" map backslash to comma so reversing line search is fast
nnoremap \ ,

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" for some reason this has to go in .vimrc
let perl_fold = 1
let perl_fold_anonymous_subs = 1

set laststatus=2

" set ruler
set colorcolumn=80

" configure vim-plug
call plug#begin('~/.vim/plugged')
if has('nvim')
  Plug 'iCyMind/NeoSolarized'
else
  Plug 'altercation/vim-colors-solarized'
endif
Plug 'AndrewRadev/sideways.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'craigemery/vim-autotag'
Plug 'dhruvasagar/vim-table-mode'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'gcmt/taboo.vim'
Plug 'godlygeek/tabular'
Plug 'guns/vim-sexp'
Plug 'honza/vim-snippets'
Plug 'int3/vim-extradite'
Plug 'janko-m/vim-test'
Plug 'jlanzarotta/bufexplorer'
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
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'sjl/gundo.vim'
Plug 'slim-template/vim-slim'
Plug 'stevearc/vim-arduino'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/L9'
Plug 'vim-vdebug/vdebug'
Plug 'w0rp/ale'
Plug 'yalesov/vim-ember-script'
call plug#end()

" use system clipboard for everything
if has("gui_running")
    set cb=unnamed
    set guioptions-=T
endif

" Always do vimdiff in vertical splits
set diffopt+=vertical
" and ignore whitespace
"set diffopt+=iwhite

" look for tags
set tags=./tags;

" use brew's ctags instead of the system one
if filereadable('/usr/local/bin/ctags')
  let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
  let g:autotagCtagsCmd = '/usr/local/bin/ctags'
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

" for gitgutter
set updatetime=100

" Enable global session caching (for Taboo)
set sessionoptions+=globals

" always show 5 lines of context
set scrolloff=5

set wildmenu

" allow writing files as root
command! W silent w !sudo tee % > /dev/null

" open web browser, mostly for vim-fugitive
command! -nargs=1 Browse call OpenURL(<f-args>)

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
