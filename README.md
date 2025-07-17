# Dotfiles

This repository contains personal configuration files for tools that I use on
a daily basis.

## Installation

To setup the dotfiles contained in this repo, run:

```bash
./install.sh
```

The script will create symlinks from the current directory to `~/` and `~/.config`.
This is required to actually use the dotfiles while maintaining them in a version
controlled directory.

> Make sure the current user is permitted to execute `install.sh`. Otherwise
> run `chmod +x install.sh` to permit the current user.

## Uninstalling

To uninstall the dotfiles contained in this repo, run:

```bash
./uninstall.sh
```

This script destroys all symlinks created by `install.sh`.

> Make sure the current user is permitted to execute `uninstall.sh`. Otherwise
> run `chmod +x uninstall.sh` to permit the current user.

## Roadmap

- [ ] Extract utility and helper functions used by `install.sh` and `uninstall.sh`
- [x] Add configuration files for `neovim`
- [ ] Add `tmux plugin manager`
- [ ] Add `homebrew` casks and formulaes
- [ ] Install utilities `fzf, ripgrep, fd, luarocks, wget, teamviewer, luarocks` via homebrew
- [ ] Install `node version manager`
- [ ] Install `sdkman`
