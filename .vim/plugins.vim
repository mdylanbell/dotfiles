" add tab number to tabs
let g:taboo_renamed_tab_format = " %N [%l]%m "
let g:taboo_tab_format = " %N %f%m "
let g:taboo_tabline = 0

" airline
let g:airline_powerline_fonts = 1
let g:airline_symbols = {}
" list buffers
let g:airline#extensions#tabline#enabled = 1
" show filename only
let g:airline#extensions#tabline#fnamemod = ':t'

" show current function/module/etc in airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
let g:airline_section_z = '%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v [  %{&tabstop}/%{&shiftwidth}]'
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

" tagbar
let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }

if executable('ripper-tags')
    let g:tagbar_type_ruby = {
          \ 'kinds'      : ['m:modules',
                          \ 'c:classes',
                          \ 'C:constants',
                          \ 'F:singleton methods',
                          \ 'f:methods',
                          \ 'a:aliases'],
          \ 'kind2scope' : { 'c' : 'class',
                           \ 'm' : 'class' },
          \ 'scope2kind' : { 'class' : 'c' },
          \ 'ctagsbin'   : 'ripper-tags',
          \ 'ctagsargs'  : ['-f', '-']
          \ }
endif

" YouCompleteMe and UltiSnips compatibility, with the helper of supertab
" (via http://stackoverflow.com/a/22253548/1626737)
" https://gist.github.com/lencioni/dff45cd3d1f0e5e23fe6
let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0
let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<tab>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'
let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

" use brew's ctags instead of the system one
if filereadable('/usr/local/bin/ctags')
  let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
  let g:autotagCtagsCmd = '/usr/local/bin/ctags'
endif

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

" custom surroundings for confluence editing
" 'l' for literal
let g:surround_108 = "{{\r}}"
" 'n' for noformat
let g:surround_110 = "{noformat}\r{noformat}"

" settings for gist-vim
"let g:gist_browser_command = 'pmb openurl %URL%'
"let g:gist_clip_command = 'pmb openurl'
"let g:gist_open_browser_after_post = 0

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
  \ }
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](local|blib|target|node_modules|vendor|bower_components)$'
  \ }
let g:ctrlp_map = '<leader>ff'

" pymode
let g:pymode_options = 0
let g:pymode_run = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint']
let g:pymode_rope_complete_on_dot = 0

" configure taglist.vim
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1

" MBE
"let g:miniBufExplSplitBelow = 0              " MBE on top (or left if vert.)
"let g:miniBufExplorerMoreThanOne = 1         " Always show MBE
"let g:miniBufExplMapWindowNavVim = 1       " control+hjkl to cycle through windows
"let g:miniBufExplMapCTabSwitchBufs = 1     " control+(shift?)+tab cycle through buffers
"let g:miniBufExplForceSyntaxEnable = 1     " Fix vim bug where buffers don't syntax

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

" configure vim-table-mode
let g:table_mode_realign_map = '<Leader>tR'
au FileType rst let g:table_mode_header_fillchar='='
au FileType rst let g:table_mode_corner_corner='+'
au FileType markdown let g:table_mode_corner='|'
au FileType pandoc let g:table_mode_corner='|'

" vim-test config
if strlen($TMUX)
  let test#strategy = "vimux"
elseif has('nvim')
  let test#strategy = "neovim"
endif
let g:test#python#pytest#options = '--verbose'

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
