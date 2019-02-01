export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"

# python/virtualenv
PYTHON_BIN_DIR=/usr/local/bin
export WORKON_HOME=$HOME/.virtual_envs
export VIRTUALENVWRAPPER_PYTHON=$PYTHON_BIN_DIR/python3
[[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && source /usr/local/bin/virtualenvwrapper.sh

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=$HOME/Library/Caches/heroku/autocomplete/zsh_setup
[[ -s $HEROKU_AC_ZSH_SETUP_PATH ]] && source "$HEROKU_AC_ZSH_SETUP_PATH"
