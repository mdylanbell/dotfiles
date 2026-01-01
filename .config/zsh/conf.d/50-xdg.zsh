# ack
export ACKRC="$XDG_CONFIG_HOME/ack/ackrc"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

# cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# perl - cpanm
export PERL_CPANM_HOME="$XDG_CACHE_HOME"/cpanm
export PERLTIDY="$XDG_CONFIG_HOME"/perltidy/perltidyrc

# psql
export PSQL_HISTORY="$XDG_DATA_HOME"/psql_history

# Ruby / gem
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPECT_CACHE="$XDG_CACHE_HOME"/gem

export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# go
export GOPATH="$XDG_DATA_HOME"/go

# irssi
alias irssi="irssi --config=\"$XDG_CONFIG_HOME\"/irssi/config -- home=\"$XDG_DATA_HOME\"/irssi"

# less -- only needed if verseion < 598
export LESSHISTFILE="$XDG_STATE_HOME"/lesshst

# npm
# export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js
# export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm
# export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm

# nvm
export NVM_DIR="$XDG_DATA_HOME"/nvm

# pyenv
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv

# python - history
#   3.13+ uses PYTHON_HISTORY; 3.12 and earlier use PYTHONHISTFILE via startup/readline.
export PYTHON_HISTORY="$XDG_STATE_HOME"/python_history
export PYTHONHISTFILE="$XDG_STATE_HOME"/python_history
#   3.12 and earlier also need a rc script
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc

# inputrc
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

# rustup
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# wget
alias wget="wget --hsts-file=${XDG_DATA_HOME}/wget-hsts"

# zsh - completion dump to XDG cache
export ZSH_COMPDUMP="$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
