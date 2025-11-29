if [[ -z $HOMEBREW_PREFIX || ! -x $HOMEBREW_PREFIX/bin/brew ]]; then
  if   [[ -d /opt/homebrew ]]; then HOMEBREW_PREFIX=/opt/homebrew
  elif [[ -d /usr/local/Homebrew ]] || [[ -x /usr/local/bin/brew ]]; then HOMEBREW_PREFIX=/usr/local
  elif [[ -d /home/linuxbrew/.linuxbrew ]]; then HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
  fi
fi

if [[ -n $HOMEBREW_PREFIX && -x $HOMEBREW_PREFIX/bin/brew ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  # getopt
  if [[ -x $HOMEBREW_PREFIX/opt/gnu-getopt/bin/getopt ]]; then
    export FLAGS_GETOPT_CMD="$HOMEBREW_PREFIX/opt/gnu-getopt/bin/getopt"
  fi
  # openssl
  if [[ -x "$HOMEBREW_PREFIX"/opt/openssl@3/bin/openssl ]]; then
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
  fi
fi

# configure CC if present (prefer highest gcc-N installed)
for gccver in 15 14 13; do
  if (( $+commands[gcc-$gccver] )); then
    export CC="$(whence -p gcc-$gccver)"
    break
  fi
done
