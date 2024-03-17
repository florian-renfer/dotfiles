# @author: Florian Renfer
# @date: 16.03.2024
# @version: 1.0

# Environment variables
export REPOS="$HOME/repos"
export GITUSER="florian-renfer"
export GHREPOS="$REPOS/github.com/$GITUSER"

# Optima GmbH enviornment variables
export OPTIMA="heyoptima"
export OPTIMAREPOS="$REPOS/github.com/$OPTIMA"

# Dotfiles environment variables
export DOTFILES="$GHREPOS/dotfiles"

# Default bash prompt
export PS1='\[\e[35m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\] \[\e[96m\]\W\[\e[0m\] \[\e[32m\]\$\[\e[0m\] '

# Aliases
alias c="clear"
alias e="exit"
alias t="tmux"
alias v="nvim"

alias ..="cd .."
alias ls="ls -la --color=auto"

alias conf='cd $GHREPOS/dotfiles'
alias repo='cd $REPOS'
alias grepo='cd $GHREPOS'

alias ga="git add --all"
alias gf="git fetch --all --prune"
alias gp="git pull"
alias gs="git status"
alias lg="lazygit"

alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias vf='v $(fp)'

# Node version manager setup (NVM)
[ -d "~/.nvm" ] || mkdir ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
