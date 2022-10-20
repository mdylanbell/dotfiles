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
Plug 'hashivim/vim-terraform'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Not sure this works, recommendation is `yarn global add diagnostic-languageserver`
" Plug 'iamcco/diagnostic-languageserver', {'do': 'yarn install --frozen-lockfile', 'branch': 'master'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-prettier', {'do': 'yarn install --forzen lockfile'}
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
Plug 'tmhedberg/SimpylFold'
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
" Plug 'w0rp/ale'
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
" let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
"let g:airline_section_z = '%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v [  %{&tabstop}/%{&shiftwidth}]'

let g:airline_solarized_bg='dark'
let g:airline_theme='solarized'
" }}}

" Ale {{{
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_enter = 1
" let g:ale_lint_on_insert_leave = 1
" let g:ale_lint_on_filetype_changed = 1
" let g:ale_lint_on_text_changed = 0
" let g:ale_completion_enabled = 1
" let g:ale_open_list = 1
" let g:ale_set_highlights = 1
" let g:ale_set_signs = 1
" let g:ale_echo_cursor = 1
"}}}

" vim-jsx: don't require jsx extension
" let g:jsx_ext_required = 0

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

" Fancy previews with `bat`
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
"    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline']}), <bang>0)

set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
" }}}

" pymode {{{
let g:pymode_options = 0
let g:pymode_breakpoint = 1
" let g:pymode_folding = 1  " too slow :(
let g:pymode_indent = 1
let g:pymode_motion = 1
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_trim_whitespaces = 1
let g:pymode_doc = 0
let g:pymode_run = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
" let g:pymode_lint_checkers = ['flake8', 'pyflakes', 'pep8', 'pylint']
let g:pymode_rope_complete_on_dot = 0

" This is super slow on large files
" augroup unset_folding_in_insert_mode
"     autocmd!
"     autocmd InsertEnter *.py setlocal foldmethod=marker
"     autocmd InsertLeave *.py setlocal foldmethod=expr
" augroup END
" }}}

" splitjoin {{{
let g:splitjoin_python_brackets_on_separate_lines = 1
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
let g:useVimux = 0
if strlen($TMUX) && g:useVimux == 1
  let test#strategy = "vimux"
elseif has('nvim')
  " let test#strategy = "neovim"
  let test#strategy = "neoterm"

  noremap <Leader>tx :TcloseAll<CR>

  let g:test#preserve_screen = 0
  let g:neoterm_default_mod = "vertical"
  let g:neoterm_size = 100
  let g:neoterm_term_per_tab = 1
  let g:neoterm_autoscroll = 1
  " let g:neoterm_fixedsize = 1
  " let g:test#neovim#start_normal = 1
else
  let test#strategy = "basic"
endif
" let g:test#python#pytest#options = '--verbose'

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
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
" }}}

" coc {{{
" let g:coc_force_debug = 1

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>ca  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>cp  :<C-u>CocListResume<CR>

" coc-snippets {{{
let g:coc_snippet_next = '<tab>'
" }}}
" }}}
