#!/bin/bash

# This script creates symlinks to all dotfiles contained in this directory.
# @author: Florian Renfer
# @date: 16.03.2024
# @version: 1.0

# Setup the XDG_CONFIG_HOME environment variable
export XDG_CONFIG_HOME=$HOME/.config

# Create symlinks
ln -sf $PWD/.bash_profile $XDG_CONFIG_HOME/.bash_profile
ln -sf $PWD/.bashrc $XDG_CONFIG_HOME/.bashrc
ln -sf $PWD/.tmux.conf $XDG_CONFIG_HOME/.tmux.conf
ln -sf $PWD/alacritty.toml $XDG_CONFIG_HOME/alacritty.toml
ln -sf $PWD/nvim $XDG_CONFIG_HOME/nvim

# Install brew/homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$OSTYPE" == "darwin"* ]]; then
	# needed for brew
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Re-source/reload .bash_profile
source ~/.bash_profile

# Install alacritty as terminal emulator
brew install --cask alacritty

# Install required tooling
brew install bat fzf git lazygit neovim nvm ripgrep tmux

# Install required Hack Font/Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Install and use Node.js LTS
mkdir ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

nvm install --lts
nvm use --lts
