# python/virtualenv
PYTHON_BIN_DIR=/usr/bin
export WORKON_HOME=$HOME/.virtual_envs
export VIRTUALENVWRAPPER_PYTHON=$PYTHON_BIN_DIR/python3
[[ -s "$HOME/.local/bin/virtualenvwrapper.sh" ]] && source $HOME/.local/bin/virtualenvwrapper.sh

