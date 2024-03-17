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

# Bits GmbH environment variables
export BITS="bits"
export BITSREPOS="$REPOS/github.com/$BITS"

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
alias orepo='cd $OPTIMAREPOS'
alias brepo='cd $BITSREPOS'

alias abbi='cd $BITSREPOS/abbi/MNAbbiDeveloper'
alias abbi_ui='cd $BITSREPOS/abbi/MNAbbiDeveloper/abbi-application/src/main/webapp/frontend/abbi-app'

alias ga="git add --all"
alias gf="git fetch --all --prune"
alias gp="git pull"
alias gs="git status"
alias lg="lazygit"

alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias vf='v $(fp)'

# SDK Man setup (Java)
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Node version manager setup (NVM)
if [ ! -d "~/.nvm" ]; then
	mkdir -p ~/.nvm
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
