#!/bin/bash

# This script creates symlinks to all dotfiles contained in this directory.
# @author: Florian Renfer
# @date: 16.03.2024
# @version: 1.0

# Setup the XDG_CONFIG_HOME environment variable
export XDG_CONFIG_HOME=$HOME/.config

# Create symlinks

# Install brew/homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install alacritty as terminal emulator
brew install --cask alacritty

# Install required tooling
brew install fzf git lazygit neovim ripgrep tmux
