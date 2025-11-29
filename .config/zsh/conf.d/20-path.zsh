path=(
  $HOME/bin
  $HOME/.local/bin
  $path
)

# Remove duplicates
typeset -U path PATH
