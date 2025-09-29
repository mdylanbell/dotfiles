path=(
  $HOME/bin
  $HOME/.local/bin
  /usr/local/opt/python/libexec/bin
  $HOME/perl5/bin
  /usr/local/bin
  /usr/local/sbin
  $path
)

# Remove duplicates
typeset -U PATH
