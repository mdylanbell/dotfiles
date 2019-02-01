" mappings.vim

" Navigate wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

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

" Toggle ALE linting
map <leader>at :ALEToggle<CR>

" Control+o to exit insert mode in terminal
if has('nvim')
  tmap <C-o> <C-\><C-n>
end

" Tagbar Toggle
noremap <leader>tb :TagbarToggle<CR>

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

" CtrlP
noremap <leader>fg :CtrlPRoot<CR>
noremap <leader>fr :CtrlPMRU<CR>
noremap <leader>fl :CtrlPMRU<CR>
noremap <leader>ft :CtrlPTag<CR>
noremap <leader>fb :CtrlPBuffer<CR>
noremap <leader>fc :CtrlPClearCache<CR>

" BufferGator https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
" Go to the previous buffer open
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
" Go to the next buffer open
nmap <leader>kk :BuffergatorMruCycleNext<cr>
" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>

" --- General buffer navigation ---
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
" nmap <leader>bl :ls<CR> " Use buffergator instead

" Taglist
"noremap <leader>tl :TlistToggle<CR>

" vim-test
noremap <leader>tn :TestNearest<CR>
noremap <leader>tf :TestFile<CR>
noremap <leader>ta :TestSuite<CR>
noremap <leader>tl :TestLast<CR>

" sideways.vim
nnoremap <leader>hh :SidewaysLeft<cr>
nnoremap <leader>ll :SidewaysRight<cr>

" http://stackoverflow.com/questions/7400743/create-a-mapping-for-vims-command-line-that-escapes-the-contents-of-a-register-b
cnoremap <c-x> <c-r>=<SID>myfuncs#PasteEscaped()<cr>
