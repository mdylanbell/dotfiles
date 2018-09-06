" add tab number to tabs
let g:taboo_renamed_tab_format = " %N [%l]%m "
let g:taboo_tab_format = " %N %f%m "

let g:airline_powerline_fonts = 1
let g:airline_symbols = {}

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
  \ 'PrtDeleteWord()':     ['<F2>']
  \ }
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](local|blib|target|node_modules|vendor|bower_components)$'
  \ }
let g:ctrlp_map = '<leader>ff'

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
function! ToggleSyntax()
   if exists("g:syntax_on")
      syntax off
   else
      syntax enable
   endif
endfunction

" ruby settings
"au BufNewFile,BufRead *.rb set sw=2 ts=2 bs=2 et smarttab


" older versions of this file contain helpers for HTML, JSP and Java

" configure taglist.vim
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1

" MBE
"let g:miniBufExplSplitBelow = 0              " MBE on top (or left if vert.)
"let g:miniBufExplorerMoreThanOne = 1         " Always show MBE
"let g:miniBufExplMapWindowNavVim = 1       " control+hjkl to cycle through windows
"let g:miniBufExplMapCTabSwitchBufs = 1     " control+(shift?)+tab cycle through buffers
"let g:miniBufExplForceSyntaxEnable = 1     " Fix vim bug where buffers don't syntax

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
