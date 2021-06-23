" vim-plug // Install Plugins {{{
call plug#begin('~/.vim/plugged')
if has('nvim')
  Plug 'iCyMind/NeoSolarized'
else
  Plug 'altercation/vim-colors-solarized'
endif

Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'airblade/vim-gitgutter'
Plug 'aklt/plantuml-syntax'
Plug 'andymass/vim-matchup'
Plug 'benmills/vimux'
" Plug 'craigemery/vim-autotag'
Plug 'dhruvasagar/vim-table-mode'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'gcmt/taboo.vim'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'int3/vim-extradite'
Plug 'janko-m/vim-test'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'junegunn/gv.vim'
Plug 'kassio/neoterm'
Plug 'krisajenkins/vim-pipe'
Plug 'leafgarland/typescript-vim'
"Plug 'luochen1990/rainbow'
" Plug 'majutsushi/tagbar'
"Plug 'mattboehm/vim-unstack'
"Plug 'mattn/gist-vim'
"Plug 'mattn/webapi-vim'
"Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-node'
"Plug 'mxw/vim-jsx'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --forzen lockfile'}
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'qpkorr/vim-bufkill'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'shumphrey/fugitive-gitlab.vim'
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
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tyru/open-browser.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-perl/vim-perl',
Plug 'vim-ruby/vim-ruby'
"Plug 'vim-scripts/L9'
"Plug 'vim-vdebug/vdebug'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'w0rp/ale'
call plug#end()
" }}}

" airline {{{
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}  " https://github.com/vim-airline/vim-airline/issues/520
  let g:airline_symbols.branch = ''
endif
" list buffers
let g:airline#extensions#tabline#enabled = 1
" show filename only
let g:airline#extensions#tabline#fnamemod = ':t'

" Git control
"let g:airline#extensions#hunks#enabled = 0
"let g:airline#extensions#branch#enabled = 0
" Only show tail (after last '/') # 2 for truncated pre-slash parts
" let g:airline#extensions#branch#format = 1
let g:airline#extensions#hunks#non_zero_only = 1

let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'

let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 130,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ 'warning': 80,
    \ 'error': 80,
    \ }

" show current function/module/etc in airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
"let g:airline_section_z = '%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v [  %{&tabstop}/%{&shiftwidth}]'

let g:airline_solarized_bg='dark'
let g:airline_theme='solarized'


" }}}

" Ale {{{
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_text_changed = 0
let g:ale_completion_enabled = 1
let g:ale_open_list = 1
let g:ale_set_highlights = 1
let g:ale_set_signs = 1
let g:ale_echo_cursor = 1
"}}}

" vim-jsx: don't require jsx extension
" let g:jsx_ext_required = 0

" gist-vim {{{
"let g:gist_open_browser_after_post = 0
" }}}

" fzf {{{
if executable('fzf')
  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit'
        \ }
  let g:fzf_layout = { 'up': '~30%' }
  " augroup fzf
  "   autocmd!
  "   autocmd! FileType fzf
  "   autocmd  FileType fzf set laststatus=0 noshowmode noruler
  "     \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  " augroup END
endif

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()
" }}}

" pymode {{{
let g:pymode_options = 0
let g:pymode_indent = 1
let g:pymode_motion = 1
let g:pymode_doc = 1
let g:pymode_run = 0
let g:pymode_lint_checkers = ['flake8', 'pyflakes', 'pep8', 'pylint']
let g:pymode_rope_complete_on_dot = 0
" }}}
"
" splitjoin {{{
let g:splitjoin_python_brackets_on_separate_lines = 1
" }}}

" Tags {{{
" taglist.vim {{{
" let Tlist_GainFocus_On_ToggleOpen = 1
" let Tlist_Close_On_Select = 1
" }}}

" use brew's ctags instead of the system one
" if filereadable('/usr/local/bin/ctags')
"   " let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
"   let g:autotagCtagsCmd = '/usr/local/bin/ctags'
" endif

" Tagbar {{{
" if executable('ripper-tags')
"   let g:tagbar_type_ruby = {
"     \ 'kinds'      : ['m:modules',
"                     \ 'c:classes',
"                     \ 'C:constants',
"                     \ 'F:singleton methods',
"                     \ 'f:methods',
"                     \ 'a:aliases'],
"     \ 'kind2scope' : { 'c' : 'class',
"                      \ 'm' : 'class' },
"     \ 'scope2kind' : { 'class' : 'c' },
"     \ 'ctagsbin'   : 'ripper-tags',
"     \ 'ctagsargs'  : ['-f', '-']
"     \ }
"   let g:autotagCtagsCmd = 'rippertags'
" else
"   if executable('ctags')
"     let g:autotagCtagsCmd = 'ctags'
"   endif

"   let g:tagbar_type_ruby = {
"     \ 'kinds' : [
"       \ 'm:modules',
"       \ 'c:classes',
"       \ 'd:describes',
"       \ 'C:contexts',
"       \ 'f:methods',
"       \ 'F:singleton methods'
"     \ ]
"   \ }
" endif
" }}}
" }}}

" vimux {{{
if strlen($TMUX)
  let tmuxver = str2float(matchstr(system("tmux -V"), '\d\d*\.\d\d*'))
  if tmuxver >= 1.8
    function! InterruptRunnerAndRunLastCommand()
      :VimuxInterruptRunner
      :VimuxRunLastCommand
    endfunction

    let g:VimuxRunnerType = 'pane'
    let g:VimuxUseNearest = 0
    let g:VimuxOrientation = "h"
    let g:VimuxHeight = "30"

    function! ToggleVimuxType()
      if g:VimuxRunnerType == 'window'
        let g:VimuxRunnerType = 'pane'
        let g:VimuxUseNearest = 1
        echo "VimuxType -> pane"
      else
        call VimuxCloseRunner()
        let g:VimuxRunnerType = 'window'
        let g:VimuxUseNearest = 0
        echo "VimuxType -> window"
      end
    endfunction
    command! ToggleVimuxType call ToggleVimuxType()

    noremap <Leader>tp :VimuxPromptCommand<CR>
    noremap <Leader>tr :VimuxRunLastCommand<CR>
    noremap <Leader>ty :call InterruptRunnerAndRunLastCommand()<CR>
    noremap <Leader>ti :VimuxInspectRunner<CR>
    noremap <Leader>tx :VimuxCloseRunner<CR>
    noremap <Leader>tc :VimuxInterruptRunner<CR>
    noremap <Leader>tz :VimuxZoomRunner<CR>
  else
    noremap <Leader>tp :echo "Upgrade tmux to at least 1.8"<CR>
  endif
endif
" }}}

" vim-table-mode {{{
let g:table_mode_realign_map = '<Leader>tR'
au FileType rst let g:table_mode_header_fillchar='='
au FileType rst let g:table_mode_corner_corner='+'
au FileType markdown let g:table_mode_corner='|'
au FileType pandoc let g:table_mode_corner='|'
" }}}

" vim-test {{{
if strlen($TMUX)
  let test#strategy = "vimux"
elseif has('nvim')
  let test#strategy = "neovim"
endif
let g:test#python#pytest#options = '--verbose'

let test#python#runner = 'pytest'
" }}}

" vim-startify {{{
augroup CustomStartup
  autocmd!
  autocmd VimEnter *
              \   if !argc()
              \ |   Startify
              \ |   NERDTree
              \ |   wincmd w
              \ | endif
augroup END

let startify_banner = system('figlet -c -k -f shadow serve automation')

let g:startify_custom_header = split(startify_banner, '\n')
" }}}

" coc-snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Deprecated (remove some day) {{{
" CtrlP {{{
" no default input
" let g:ctrlp_default_input = 0
" " set working dir starting at vim's working dir
" let g:ctrlp_working_path_mode = 0
" let g:ctrlp_mruf_relative = 1
" let g:ctrlp_match_window = 'top,order:ttb,min:1,max:10,results:100'
" let g:ctrlp_prompt_mappings = {
"   \ 'ToggleMRURelative()': ['<c-w>'],
"   \ }
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/](local|blib|target|node_modules|vendor|bower_components)$'
"   \ }
" let g:ctrlp_map = '<leader>ff'
" }}}

" rainbow {{{
" " clojure
" let g:rainbow_active = 1
" let g:rainbow_conf = {
"       \  'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
"       \  'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
"       \  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
"       \  'separately': {
"       \      '*': 0,
"       \      'clojure': {},
"       \  }
"       \}
" }}}

" vim-pipe {{{
" let g:vimpipe_invoke_map="<leader>w"
" let g:vimpipe_close_map="<leader>W"
" }}}
"
" YouCompleteMe / Ultisnips / supertab {{{
" YouCompleteMe and UltiSnips compatibility, with the helper of supertab
" (via http://stackoverflow.com/a/22253548/1626737)
" https://gist.github.com/lencioni/dff45cd3d1f0e5e23fe6
" let g:SuperTabDefaultCompletionType    = '<C-n>'
" let g:SuperTabCrMapping                = 0
" let g:UltiSnipsExpandTrigger           = '<tab>'
" let g:UltiSnipsJumpForwardTrigger      = '<tab>'
" let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'
" let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

" detect if we're on redhat/centos < 6 and skip ultisnips
" older versions don't have a new enough version of python
" if filereadable("/etc/redhat-release")
"   let line = readfile("/etc/redhat-release")[0]
"   let s:majorver = matchlist(line, '\(\d\)\(.\d*\)\? *(\(.*\))')[1]
"   if s:majorver < 6
"     let did_UltiSnips_vim=1
"     let did_UltiSnips_vim_after=1
"   endif
" endif
" }}}

" taboo {{{
" add tab number to tabs
" let g:taboo_renamed_tab_format = " %N [%l]%m "
" let g:taboo_tab_format = " %N %f%m "
" let g:taboo_tabline = 0
" }}}
" }}}
