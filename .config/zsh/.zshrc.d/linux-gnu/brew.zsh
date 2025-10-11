# find or set HOMEBREW_PREFIX
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi
fi

# activate brew
if [[ -x "$HOMEBREW_PREFIX"/bin/brew ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# configure getopt if present
if [[ -x "$HOMEBREW_PREFIX"/opt/gnu-getopt/bin/getopt ]]; then
  export FLAGS_GETOPT_CMD="$HOMEBREW_PREFIX/opt/gnu-getopt/bin/getopt"
fi

# configure CC if present
if [[ -x "$HOMEBREW_PREFIX"/bin/gcc-15 ]]; then
  export CC=/home/linuxbrew/.linuxbrew/bin/gcc-15
fi

# configure openssl if present
if [[ -x "$HOMEBREW_PREFIX"/opt/openssl@3/bin/openssl ]]; then
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
fi
