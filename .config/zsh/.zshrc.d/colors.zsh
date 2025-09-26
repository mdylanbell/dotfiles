if (( $+commands[gdircolors] )); then
  DIRCOLORS=gdircolors
else
  DIRCOLORS=dircolors
fi
eval `$DIRCOLORS "$XDG_CONFIG_HOME"/dircolors`
