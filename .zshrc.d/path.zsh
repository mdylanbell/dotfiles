path=(
  $HOME/bin
  /usr/local/bin
  /usr/local/sbin
  $path
)

# Remove duplicates
typeset -U PATH
