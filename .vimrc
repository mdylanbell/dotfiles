set nocp
set ai to shell=/bin/bash terse nowarn sm ruler sw=4 ts=4
if !has('nvim')
  set redraw
else
  set inccommand=nosplit
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/bin/python3'
  let &t_8f = "\e[38;2;%lu;%lu;%lum"
  let &t_8b = "\e[48;2;%lu;%lu;%lum"
  let &t_ut=''
  set termguicolors
endif

" Set the terminal default background and foreground colors, thereby
" improving performance by not needing to set these colors on empty cells.
hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
let &t_te = &t_te . "\033]110\007\033]111\007"

"set noremap
set hls
set bs=2
set history=100
set showmode
set incsearch
"set ignorecase
set smartcase
set expandtab smarttab

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
let g:airline_powerline_fonts = 1

" set ruler
set cc=80

" for gitgutter
set updatetime=100

" Enable global session caching (for Taboo)
set sessionoptions+=globals
" add tab number to tabs
let g:taboo_renamed_tab_format = " %N [%l]%m "
let g:taboo_tab_format = " %N %f%m "

" show current function/module/etc in airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
let g:airline_section_z = '%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v [  %{&tabstop}/%{&shiftwidth}]'
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
let g:airline_symbols = {}
let g:airline_symbols.branch = ''

" configure ale
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

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" detect if we're on redhat/centos < 6 and skip ultisnips
" older versions don't have a new enough version of python
if filereadable("/etc/redhat-release")
  let line = readfile("/etc/redhat-release")[0]
  let s:majorver = matchlist(line, '\(\d\)\(.\d*\)\? *(\(.*\))')[1]
  if s:majorver < 6
    let did_UltiSnips_vim=1
    let did_UltiSnips_vim_after=1
  endif
endif

" settings for gist-vim
"let g:gist_browser_command = 'pmb openurl %URL%'
"let g:gist_clip_command = 'pmb openurl'
"let g:gist_open_browser_after_post = 0

" Easy searching within a range:
" step 1: Visual highlight the lines to search
" step 2: Type ,/
" step 3: Type the pattern you wish to find and hit enter
" bonus: Visual highlight a new area and just hit 'n' to search again
vmap <leader>/ <Esc>/\%V
" TODO: this one conflicts with mark.vim
"map <leader>/ /\%V

" custom surroundings for confluence editing
" 'l' for literal
let g:surround_108 = "{{\r}}"
" 'n' for noformat
let g:surround_110 = "{noformat}\r{noformat}"

" Navigate wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" always show 5 lines of context
set scrolloff=5

set wildmenu

" scroll up and down the page a little faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" alias for quit all
map <leader>d :qa<CR>

" for editing files next to the open one
" http://vimcasts.org/episodes/the-edit-command/
noremap <leader>ew :e <C-R>=expand("%:.:h") . "/" <CR>
noremap <leader>es :sp <C-R>=expand("%:.:h") . "/" <CR>
noremap <leader>ev :vsp <C-R>=expand("%:.:h") . "/" <CR>
noremap <leader>et :tabe <C-R>=expand("%:.:h") . "/" <CR>

" use the octopress syntax for markdown files
"au BufNewFile,BufRead *.markdown setfiletype octopress

" no default input
let g:ctrlp_default_input = 0
" set working dir starting at vim's working dir
let g:ctrlp_working_path_mode = 0
let g:ctrlp_mruf_relative = 1
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:10,results:100'
let g:ctrlp_prompt_mappings = {
  \ 'ToggleMRURelative()': ['<c-w>'],
  \ 'PrtDeleteWord()':     ['<F2>']
  \ }
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](local|blib|target|node_modules|vendor|bower_components)$'
  \ }
let g:ctrlp_map = '<leader>ff'
noremap <leader>fg :CtrlPRoot<CR>
noremap <leader>fr :CtrlPMRU<CR>
noremap <leader>fl :CtrlPMRU<CR>
noremap <leader>ft :CtrlPTag<CR>
noremap <leader>fb :CtrlPBuffer<CR>
noremap <leader>fc :CtrlPClearCache<CR>

let g:pymode_options = 0
let g:pymode_run = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint']
let g:pymode_rope_complete_on_dot = 0

" configure vim-table-mode
let g:table_mode_realign_map = '<Leader>tR'
au FileType rst let g:table_mode_header_fillchar='='
au FileType rst let g:table_mode_corner_corner='+'
au FileType markdown let g:table_mode_corner='|'
au FileType pandoc let g:table_mode_corner='|'

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

syntax enable
set bg=dark
if has('nvim')
  colorscheme NeoSolarized
else
  let g:solarized_termtrans = 0
  let g:solarized_termcolors = &t_Co
  colorscheme solarized
endif

" settings for javascript/jsx
"au FileType javascript setlocal foldmethod=syntax
"au FileType javascript setlocal foldnestmax=1

" settings for go
" fold go files with syntax
"au FileType go setlocal foldmethod=syntax
"au FileType go setlocal foldnestmax=1
" use goimports for formatting
"let g:go_fmt_command = "goimports"
"let g:go_fmt_experimental=1

map <F2> :map<CR>
nnoremap <F5> :GundoToggle<CR>
map <F7> :call ToggleSyntax()<CR>
map <F8> :set paste!<CR>
map <F10> :diffu<CR>
map <F11> :echo 'Current change: ' . changenr()<CR>
map <F12> :noh<CR>

" remove trailing whitespace when writing
autocmd BufWritePre * :%s/\s\+$//e

map <leader>nt :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>

" Testing aliases
map ,tv :!./Build test --verbose 1 --test-files %<CR>

function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction

runtime macros/matchit.vim

set foldmethod=marker

" printing options
set popt=paper:letter
set printdevice=dev_np24

" ruby settings
"au BufNewFile,BufRead *.rb set sw=2 ts=2 bs=2 et smarttab

" .t files are perl
au BufNewFile,BufRead *.t set filetype=perl

" tt and mt files are tt2html
au BufNewFile,BufRead *.tt set filetype=tt2html
au BufNewFile,BufRead *.mt set filetype=tt2html

map ,cp :%w ! pbcopy<CR>

" older versions of this file contain helpers for HTML, JSP and Java

" sessionman.vim mappings
noremap <leader>sa :SessionSaveAs<CR>
noremap <leader>ss :SessionSave<CR>
noremap <leader>so :SessionOpen
noremap <leader>sl :SessionList<CR>
noremap <leader>sc :SessionClose<CR>

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

" configure taglist.vim
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
noremap <leader>tl :TlistToggle<CR>

" use brew's ctags instead of the system one
if filereadable('/usr/local/bin/ctags')
    let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
    let g:autotagCtagsCmd = '/usr/local/bin/ctags'
endif

" tabular mappings (http://vimcasts.org/episodes/aligning-text-with-tabular-vim/)
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>

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

" make searches the most magical
"nnoremap / /\v
"vnoremap / /\v
"noremap :s :s/\v

" MBE
"let g:miniBufExplSplitBelow = 0              " MBE on top (or left if vert.)
"let g:miniBufExplorerMoreThanOne = 1         " Always show MBE
"let g:miniBufExplMapWindowNavVim = 1       " control+hjkl to cycle through windows
"let g:miniBufExplMapCTabSwitchBufs = 1     " control+(shift?)+tab cycle through buffers
"let g:miniBufExplForceSyntaxEnable = 1     " Fix vim bug where buffers don't syntax

" allow writing files as root
command! W silent w !sudo tee % > /dev/null

" http://stackoverflow.com/questions/7400743/create-a-mapping-for-vims-command-line-that-escapes-the-contents-of-a-register-b
cnoremap <c-x> <c-r>=<SID>PasteEscaped()<cr>
function! s:PasteEscaped()
  echo "\\".getcmdline()."\""
  let char = getchar()
  if char == "\<esc>"
    return ''
  else
    let register_content = getreg(nr2char(char))
    let escaped_register = escape(register_content, '\'.getcmdtype())
    return substitute(escaped_register, '\n', '\\n', 'g')
  endif
endfunction

" use space bar to open/close folds
nnoremap <space> za

" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" clear highlight quick
nnoremap <leader><Space> :nohls<CR>

" easy tab navigation
nnoremap <silent> <C-N> :tabnext<CR>
nnoremap <silent> <C-P> :tabprev<CR>

" vimux config
if strlen($TMUX)
    let tmuxver = str2float(matchstr(system("tmux -V"), '\d\d*\.\d\d*'))
    if tmuxver >= 1.8
        function! InterruptRunnerAndRunLastCommand()
            :VimuxInterruptRunner
            :VimuxRunLastCommand
        endfunction

        let g:VimuxRunnerType = 'pane'
        let g:VimuxUseNearest = 1

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

" vim-test config
if strlen($TMUX)
  let test#strategy = "vimux"
elseif has('nvim')
  let test#strategy = "neovim"
endif
let g:test#python#pytest#options = '--verbose'
noremap <leader>tn :TestNearest<CR>
noremap <leader>tf :TestFile<CR>
noremap <leader>ta :TestSuite<CR>
noremap <leader>tl :TestLast<CR>

" sideways.vim
nnoremap <leader>h :SidewaysLeft<cr>
nnoremap <leader>l :SidewaysRight<cr>

" clojure rainbow parens
let g:rainbow_active = 1
let g:rainbow_conf = {
      \  'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
      \  'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
      \  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \  'separately': {
      \      '*': 0,
      \      'clojure': {},
      \  }
      \}

" configure vim-pipe
let g:vimpipe_invoke_map="<leader>w"
let g:vimpipe_close_map="<leader>W"

let g:vim_json_syntax_conceal = 0
au FileType json setlocal foldmethod=syntax

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

" open web browser, mostly for vim-fugitive
command! -nargs=1 Browse call OpenURL(<f-args>)

" Autoclose loclist when related buffer is closed  (namely for :ALELint)
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END


"" s:NextNormalWindow() {{{2
"function! s:NextNormalWindow() abort
"    for i in range(1, winnr('$'))
"        let buf = winbufnr(i)
"
"        " skip unlisted buffers
"        if !buflisted(buf)
"            continue
"        endif
"
"        " skip temporary buffers with buftype set
"        if getbufvar(buf, '&buftype') != ''
"            continue
"        endif
"
"        " skip the preview window
"        if getwinvar(i, '&previewwindow')
"            continue
"        endif
"
"        " skip current window
"        if i == winnr()
"            continue
"        endif
"
"        return i
"    endfor
"
"    return -1
"endfunction
"
"" s:QuitIfOnlyWindow() {{{2
"function! s:QuitIfOnlyWindow() abort
"    let l:buftype = getbufvar(winbufnr(winnr()), "&buftype")
"    if l:buftype != "quickfix" && l:buftype != "help"
"        return
"    endif
"
"    " Check if there is more than one window
"    if s:NextNormalWindow() == -1
"        " Check if there is more than one tab page
"        if tabpagenr('$') == 1
"            " Before quitting Vim, delete the special buffer so that
"            " the '0 mark is correctly set to the previous buffer.
"            " Also disable autocmd on this command to avoid unnecessary
"            " autocmd nesting.
"            if winnr('$') == 1
"                if has('autocmd')
"                    noautocmd bdelete
"                endif
"            endif
"            quit
"        else
"            " Note: workaround for the fact that in new tab the buftype is set
"            " too late (and sticks during this WinEntry autocmd to the old -
"            " potentially quickfix/help buftype - that would automatically
"            " close the new tab and open the buffer in copen window instead
"            " New tabpage has previous window set to 0
"            if tabpagewinnr(tabpagenr(), '#') != 0
"                let l:last_window = 0
"                if winnr('$') == 1
"                    let l:last_window = 1
"                endif
"                close
"                if l:last_window == 1
"                    " Note: workaround for the same bug, but w.r.t. Airline
"                    " plugin (it needs to refresh buftype and status line after
"                    " last special window autocmd close on a tab page
"                    if exists(':AirlineRefresh')
"                        execute "AirlineRefresh"
"                    endif
"                endif
"            endif
"        endif
"    endif
"endfunction
"
"" autoclose last open location/quickfix/help windows on a tab
"if has('autocmd')
"    aug AutoCloseAllQF
"        au!
"        autocmd WinEnter * nested call s:QuitIfOnlyWindow()
"    aug END
"endif
