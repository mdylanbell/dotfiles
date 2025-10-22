if [[ -z $HOMEBREW_PREFIX ]]; then
  if [[ -d /opt/homebrew ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  elif [[ -x /usr/local/bin/brew ]]; then
    HOMEBREW_PREFIX="/usr/local"
  fi
fi

if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"
fi

# configure CC if present
if [[ -x "$HOMEBREW_PREFIX"/bin/gcc-15 ]]; then
  export CC="$HOMEBREW_PREFIX"/bin/gcc-15
fi

# configure openssl if present
if [[ -x "$HOMEBREW_PREFIX"/opt/openssl@3/bin/openssl ]]; then
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
fi

