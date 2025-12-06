# Remove duplicates
builtin typeset -gU PATH path

path=(
  $HOME/bin
  $HOME/.local/bin
  $path[@]
)
