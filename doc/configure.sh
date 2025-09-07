#!/bin/env bash

# install dotfiles
git clone git@github.com:mdylanbell/dotfiles.git -b personal .dotfiles
$HOME/.dotfiles/bin/dfm install

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# install zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# copy zshrc.local
# TODO: check for mac or linux
cp ~/.dotfiles/doc/osx/configs/.zshrc.local ~/.zshrc.local

# brew install some stuff
brew install fzf tmux git figlet ripgrep python@3 neovim

# install neovim deps
npm i -g npm
npm i -g neovim
pip install --upgrade pip
pip install neovim