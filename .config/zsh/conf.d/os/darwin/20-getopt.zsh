# Prefer GNU getopt from Homebrew on macOS when available.
if [[ -n $HOMEBREW_PREFIX && -x $HOMEBREW_PREFIX/opt/gnu-getopt/bin/getopt ]]; then
  export FLAGS_GETOPT_CMD="$HOMEBREW_PREFIX/opt/gnu-getopt/bin/getopt"
fi
