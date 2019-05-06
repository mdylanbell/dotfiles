set mouse=a

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['flow-language-server', '--stdio'],
    \ 'python': ['pyls'],
    \ 'ruby': ['solargraph', 'stdio'],
    \ }

let g:LanguageClient_autoStart = 1

nnoremap <localleader>lh :call LanguageClient_textDocument_hover()<CR>
nnoremap <localleader>ld :call LanguageClient_textDocument_definition()<CR>
nnoremap <localleader>lr :call LanguageClient_textDocument_rename()<CR>
