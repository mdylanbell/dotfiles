# Prefer Homebrew OpenSSL headers/libs on macOS when available.
if [[ -n $HOMEBREW_PREFIX && -x "$HOMEBREW_PREFIX"/opt/openssl@3/bin/openssl ]]; then
  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
fi
