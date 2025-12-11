# Theme selector: catppuccin (default) or solarized (set DOTFILES_COLORSCHEME=solarized)
LS_COLORS_FILE=""
DIRCOLORS_FILE=""

case "${DOTFILES_COLORSCHEME:-catppuccin}" in
  catppuccin)
    LS_COLORS_FILE="$XDG_CONFIG_HOME/lscolors/catppuccin-mocha.lscolors"
    ;;
  solarized)
    DIRCOLORS_FILE="$XDG_CONFIG_HOME/dircolors.solarized"
    ;;
esac

# Prefer LS_COLORS file when provided
if [[ -n $LS_COLORS_FILE && -f $LS_COLORS_FILE ]]; then
  export LS_COLORS=$(<"$LS_COLORS_FILE")
# Otherwise fall back to dircolors if available
elif [[ -n $DIRCOLORS_FILE && -f $DIRCOLORS_FILE ]]; then
  if (( $+commands[gdircolors] )); then
    DIRCOLORS_CMD=gdircolors
  elif (( $+commands[dircolors] )); then
    DIRCOLORS_CMD=dircolors
  fi
  if [[ -n $DIRCOLORS_CMD ]]; then
    eval `$DIRCOLORS_CMD "$DIRCOLORS_FILE"`
  fi
fi

# colorize help messages (-h and --help args) for commands (interactive shells only)
if [[ $- == *i* ]] && (( $+commands[bat] )); then
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi
