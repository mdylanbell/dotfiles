" mappings.vim

" Easy searching within a range:
" step 1: Visual highlight the lines to search
" step 2: Type ,/
" step 3: Type the pattern you wish to find and hit enter
" bonus: Visual highlight a new area and just hit 'n' to search again
vmap <leader>/ <Esc>/\%V
" TODO: this one conflicts with mark.vim
"map <leader>/ /\%V

" Navigate wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

map ,cp :%w ! pbcopy<CR>

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

" sessionman.vim mappings
noremap <leader>sa :SessionSaveAs<CR>
noremap <leader>ss :SessionSave<CR>
noremap <leader>so :SessionOpen
noremap <leader>sl :SessionList<CR>
noremap <leader>sc :SessionClose<CR>

" tabular mappings (http://vimcasts.org/episodes/aligning-text-with-tabular-vim/)
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>

" make searches the most magical
"nnoremap / /\v
"vnoremap / /\v
"noremap :s :s/\v

" use space bar to open/close folds
nnoremap <space> za

" clear highlight quick
nnoremap <leader><Space> :nohls<CR>

" easy tab navigation
nnoremap <silent> <C-N> :tabnext<CR>
nnoremap <silent> <C-P> :tabprev<CR>

" CtrlP
noremap <leader>fg :CtrlPRoot<CR>
noremap <leader>fr :CtrlPMRU<CR>
noremap <leader>fl :CtrlPMRU<CR>
noremap <leader>ft :CtrlPTag<CR>
noremap <leader>fb :CtrlPBuffer<CR>
noremap <leader>fc :CtrlPClearCache<CR>

" Taglist
noremap <leader>tl :TlistToggle<CR>

" vim-test
noremap <leader>tn :TestNearest<CR>
noremap <leader>tf :TestFile<CR>
noremap <leader>ta :TestSuite<CR>
noremap <leader>tl :TestLast<CR>

" sideways.vim
nnoremap <leader>h :SidewaysLeft<cr>
nnoremap <leader>l :SidewaysRight<cr>
