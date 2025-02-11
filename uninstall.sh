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

# Actual uninstallation process
printf "\n"
info "======================"
info "Destroying symlinks..."
info "======================"
printf "\n"

# Ghostty
rm -rf $HOME/.config/ghostty/config

# Aerospace
rm -rf $HOME/.config/aerospace/aerospace.toml

# TMUX
rm -rf $HOME/.config/tmux/tmux.conf
rm -rf $HOME/.config/tmux/theme.conf

# Neovim
rm -rf $HOME/.config/nvim

printf "\n"
info "======================"
info "Uninstalling scripts..."
info "======================"
printf "\n"

rm -rf $HOME/.local/scripts
