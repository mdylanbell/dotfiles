# Remove duplicates
builtin typeset -gU PATH path

path=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/.local/share/nvim/mason/bin
  $path[@]
)
