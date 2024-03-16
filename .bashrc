# @author: Florian Renfer
# @date: 16.03.2024
# @version: 1.0

# Environment variables
export REPOS="$HOME/repos"
export GITUSER="florian-renfer"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dotfiles"

# Aliases
alias c="clear"
alias e="exit"
alias t="tmux"
alias v="nvim"

alias ..="cd .."
alias ls="ls -la --color=auto"

alias conf='cd $GHREPOS/dotfiles'
alias repo='cd $REPOS'

alias ga="git add --all"
alias gf="git fetch --all --prune"
alias gp="git pull"
alias gs="git status"
alias lg="lazygit"

alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias vf="v $(fp)"
