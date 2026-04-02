# Theme selector: catppuccin (default) or solarized (set
# DOTFILES_COLORSCHEME=solarized)
() {
  emulate -L zsh

  local ls_colors_file="" dircolors_file="" dircolors_cmd=""

  case "${DOTFILES_COLORSCHEME:-catppuccin}" in
    catppuccin)
      ls_colors_file="$XDG_CONFIG_HOME/lscolors/catppuccin-mocha.lscolors"
      # Keep search tools visually aligned with the Catppuccin Mocha anchors
      # already used by bat, starship, and lscolors: flamingo for matches,
      # sapphire for paths, green for line numbers, lavender for offsets, and
      # overlay-toned separators.
      local match_color='38;5;211'
      local path_color='38;5;117'
      local line_color='38;5;150'
      local offset_color='38;5;183'
      local separator_color='38;5;242'

      export GREP_COLORS="ms=01;${match_color}:mc=01;${match_color}:sl=:cx=:fn=${path_color}:ln=${line_color}:bn=${offset_color}:se=${separator_color}"
      export RG_COLORS="match:fg:213:path:fg:117:line:fg:150:column:fg:183:column:style:nobold"
      ;;
    solarized)
      dircolors_file="$XDG_CONFIG_HOME/dircolors.solarized"
      ;;
  esac

  # Prefer an explicit LS_COLORS file when available.
  if [[ -n $ls_colors_file && -f $ls_colors_file ]]; then
    export LS_COLORS=$(<"$ls_colors_file")
  # Otherwise fall back to dircolors if available.
  elif [[ -n $dircolors_file && -f $dircolors_file ]]; then
    if (($+commands[gdircolors])); then
      dircolors_cmd=gdircolors
    elif (($+commands[dircolors])); then
      dircolors_cmd=dircolors
    fi

    if [[ -n $dircolors_cmd ]]; then
      eval "$("$dircolors_cmd" "$dircolors_file")"
    fi
  fi
}

# colorize help messages (-h and --help args) for commands (interactive shells only)
if [[ $- == *i* ]] && (($+commands[bat])); then
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi
