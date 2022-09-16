path=(
  $HOME/bin
  /usr/local/opt/python/libexec/bin
  /usr/local/bin
  /usr/local/sbin
  $path
)

# Remove duplicates
typeset -U PATH
