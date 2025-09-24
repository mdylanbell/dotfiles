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
cp ~/.dotfiles/doc/macos/configs/.zshrc.local ~/.zshrc.local

# brew install some stuff
brew install tmux git neovim
# brew install Lazyvim deps
brew install ast-grep curl fd fzf ripgrep gh imagemagick lazygit luarocks lynx prettier sqlfluff tree-sitter yaml-language-server

# install neovim deps
npm i -g npm neovim
npm i -g neovim
pip install --upgrade pip
pip install neovim

