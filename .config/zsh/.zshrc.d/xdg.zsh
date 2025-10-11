# ack
export ACKRC="$XDG_CONFIG_HOME/ack/ackrc"

# aws
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

# azure
# export AZURE_CONFIG_DIR="$XDG_DATA_HOME"/azure

# cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# perl - cpanm
export PERL_CPANM_HOME="$XDG_CACHE_HOME"/cpanm
export PERLTIDY="$XDG_CONFIG_HOME"/perltidy/perltidyrc

# dircolors
# eval $(dircolors "$XDG_CONFIG_HOME"/dircolors)
#
# docker (cli only) - doesn't work with docker-desktop :: https://github.com/docker/roadmap/issues/408
# export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# dotnet
# export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet

# psql
export PSQL_HISTORY="$XDG_DATA_HOME"/psql_history

# Ruby / gem
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPECT_CACHE="$XDG_CACHE_HOME"/gem

# screen
# export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc

export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# gnupg
# export GNUPGHOME="$XDG_DATA_HOME"/gnupg

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
#   if >= 3.13.0a3 this just works
export PYTHON_HISTORY="$XDG_CACHE_HOME"/python/history
#   else -- also need a rc script
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc

# inputrc
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

# rustup
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# wget
alias wget="wget --hsts-file=${XDG_DATA_HOME}/wget-hsts"
