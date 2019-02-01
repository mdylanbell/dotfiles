if (( $+commands[gdircolors] )); then
  DIRCOLORS=gdircolors
else
  DIRCOLORS=dircolors
fi
eval `$DIRCOLORS -b $HOME/.dircolors`
