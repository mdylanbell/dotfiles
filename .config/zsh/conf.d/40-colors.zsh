if (( $+commands[gdircolors] )); then
  DIRCOLORS=gdircolors
elif (( $+commands[dircolors] )); then
  DIRCOLORS=dircolors
fi

if [[ -n $DIRCOLORS ]]; then
  eval `$DIRCOLORS "$XDG_CONFIG_HOME"/dircolors`
fi

# colorize help messages (-h and --help args) for commands (interactive shells only)
if [[ $- == *i* ]] && (( $+commands[bat] )); then
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi
