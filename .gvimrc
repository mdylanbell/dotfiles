set lines=50 columns=160
set guifont=MesloLGMNerdFontPlusFontAwesomePlusOcticonsPlusPomicons---RegularForPowerline:h14
set vb

if filereadable(expand("~/.gvimrc.local"))
    source ~/.gvimrc.local
endif
