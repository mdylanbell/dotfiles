if [[ -z $HOMEBREW_PREFIX || ! -x $HOMEBREW_PREFIX/bin/brew ]]; then
  if   [[ -d /opt/homebrew ]]; then HOMEBREW_PREFIX=/opt/homebrew
  elif [[ -d /usr/local/Homebrew ]] || [[ -x /usr/local/bin/brew ]]; then HOMEBREW_PREFIX=/usr/local
  elif [[ -d /home/linuxbrew/.linuxbrew ]]; then HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
  fi
fi

if [[ -n $HOMEBREW_PREFIX && -x $HOMEBREW_PREFIX/bin/brew ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi
