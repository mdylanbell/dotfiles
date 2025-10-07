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
