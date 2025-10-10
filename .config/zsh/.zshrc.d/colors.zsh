if (( $+commands[gdircolors] )); then
  DIRCOLORS=gdircolors
else
  DIRCOLORS=dircolors
fi
eval `$DIRCOLORS "$XDG_CONFIG_HOME"/dircolors`

if (( $+commands[bat] )); then
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi
