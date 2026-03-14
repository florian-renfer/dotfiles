# Evaluate starship configuration for custom ZSH prompts
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

# Append ~/github.com/florian-renfer/dotfiles/scripts/ to PATH in order to use custom scripts, e.g. tmux-sessionizer or xdg-init
path+=("$HOME/github.com/florian-renfer/dotfiles/scripts")
path+=("${KREW_ROOT:-$HOME/.krew}/bin")
export PATH

# Initialize node version manager
source /usr/share/nvm/init-nvm.sh

# Appended due to running xdg-init
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Always work in a tmux session if Tmux is installed
if which tmux 2>&1 >/dev/null; then
  if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
    tmux attach -t default || tmux new -s default; exit
  fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#compdef lcctl
###-begin-lcctl-completions-###
#
# yargs command completion script
#
# Installation: lcctl completion >> ~/.zshrc
#    or lcctl completion >> ~/.zprofile on OSX.
#
_lcctl_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" lcctl --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _lcctl_yargs_completions lcctl
###-end-lcctl-completions-###

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
