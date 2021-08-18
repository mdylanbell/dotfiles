" mappings.vim

" Navigate wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Navigate windows
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" scroll up and down the page a little faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" use space bar to open/close folds
nnoremap <space> za

" easy tab navigation
nnoremap <silent> <C-N> :tabnext<CR>
nnoremap <silent> <C-P> :tabprev<CR>

map <F2> :map<CR>
nnoremap <F5> :GundoToggle<CR>
map <F7> :ALEToggle<CR>
map <F8> :set paste!<CR>
map <F10> :diffu<CR>
map <F11> :echo 'Current change: ' . changenr()<CR>
map <F12> :noh<CR>

" Easy searching within a range:
" step 1: Visual highlight the lines to search
" step 2: Type ,/
" step 3: Type the pattern you wish to find and hit enter
" bonus: Visual highlight a new area and just hit 'n' to search again
vmap <leader>/ <Esc>/\%V
" TODO: this one conflicts with mark.vim
"map <leader>/ /\%V

" clear highlight quick
nnoremap <leader><Space> :nohls<CR>

" copy to macOS clipboard
map <leader>cp :%w ! pbcopy<CR>

" for editing files next to the open one
" http://vimcasts.org/episodes/the-edit-command/
noremap <leader>ew :e <C-R>=expand("%:.:h") . "/" <CR>
noremap <leader>es :sp <C-R>=expand("%:.:h") . "/" <CR>
noremap <leader>ev :vsp <C-R>=expand("%:.:h") . "/" <CR>
noremap <leader>et :tabe <C-R>=expand("%:.:h") . "/" <CR>

map <leader>nt :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>

" ALE {{{
" Toggle ALE linting
map <leader>at :ALEToggle<CR>

nmap <silent> [c <Plug>(ale_previous_wrap)
nmap <silent> ]c <Plug>(ale_next_wrap)
" }}}

" Control+o to exit insert mode in terminal
if has('nvim')
  tmap <C-o> <C-\><C-n>
end

" Tagbar Toggle
noremap <leader>tb :TagbarToggle<CR>

" sessionman.vim mappings
" noremap <leader>sa :SessionSaveAs<CR>
" noremap <leader>ss :SessionSave<CR>
" noremap <leader>so :SessionOpen
" noremap <leader>sl :SessionList<CR>
" noremap <leader>sc :SessionClose<CR>

" tabular mappings (http://vimcasts.org/episodes/aligning-text-with-tabular-vim/)
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>

" CtrlP
" noremap <leader>fg :CtrlPRoot<CR>
" noremap <leader>fr :CtrlPMRU<CR>
" noremap <leader>fl :CtrlPMRU<CR>
" noremap <leader>ft :CtrlPTag<CR>
" noremap <leader>fb :CtrlPBuffer<CR>
" noremap <leader>fc :CtrlPClearCache<CR>

" FZF
nnoremap <silent> <Leader>fg :ProjectFiles<CR>
noremap <leader>ff :Files<CR>
noremap <leader>fr :FZFMru<CR>
noremap <leader>fl :FZFMru<CR>
noremap <leader>fb :Buffers<CR>
noremap <leader>ft :BTags<CR>
noremap <leader>fT :Tags<CR>
noremap <leader>fz :FZF<CR>

" Ripgrep
noremap <leader>fx :Rg<CR>

" {{{ Buffers

" {{{ BufferGator
" https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/

" Go to the previous buffer open
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
" Go to the next buffer open
nmap <leader>kk :BuffergatorMruCycleNext<cr>
" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>
" }}}

" {{{ General buffer navigation
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
" nmap <leader>bl :ls<CR> " Use buffergator instead
" }}}

" }}}

" Taglist
"noremap <leader>tl :TlistToggle<CR>

" {{{ vim-test
noremap <leader>tn :TestNearest<CR>
noremap <leader>tf :TestFile<CR>
noremap <leader>ta :TestSuite<CR>
noremap <leader>tl :TestLast<CR>
" }}}

" {{{ sideways.vim
nnoremap <leader>hh :SidewaysLeft<cr>
nnoremap <leader>ll :SidewaysRight<cr>
" }}}

" http://stackoverflow.com/questions/7400743/create-a-mapping-for-vims-command-line-that-escapes-the-contents-of-a-register-b
cnoremap <c-x> <c-r>=<SID>myfuncs#PasteEscaped()<cr>

" {{{ vim-markdown-preview.vim
let vim_markdown_preview_hotkey='<C-m>'
" }}}

" {{{ CoC

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
"
" MDB: Currently conflicts with vim-endwise
"   (https://github.com/tpope/vim-endwise/issues/22)
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}
