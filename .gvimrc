set lines=50 columns=160
set guifont=MesloLGM\ Nerd\ Font\ Mono:h12
set vb

if filereadable(expand("~/.gvimrc.local"))
    source ~/.gvimrc.local
endif
