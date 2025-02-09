#!/bin/bash

# Helpers
default_color=$(tput sgr 0)
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"

info() {
    printf "%s==> %s%s\n" "$blue" "$1" "$default_color"
}

success() {
    printf "%s==> %s%s\n" "$green" "$1" "$default_color"
}

error() {
    printf "%s==> %s%s\n" "$red" "$1" "$default_color"
}

warning() {
    printf "%s==> %s%s\n" "$yellow" "$1" "$default_color"
}

# Actual installation process
printf "\n"
info "======================"
info "Creating symlinks..."
info "======================"
printf "\n"

# Aerospace
ln -s $(pwd)/aerospace/aerospace.toml $HOME/.config/aerospace/aerospace.toml

# TMUX
ln -s $(pwd)/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
ln -s $(pwd)/tmux/theme.conf $HOME/.config/tmux/theme.conf

# Neovim
ln -s $(pwd)/nvim $HOME/.config/nvim
