# Evaluate starship configuration for custom ZSH prompts
eval "$(starship init zsh)"

# Append ~/github.com/florian-renfer/dotfiles/scripts/ to PATH in order to use custom scripts, e.g. tmux-sessionizer or xdg-init
path+=("$HOME/github.com/florian-renfer/dotfiles/scripts")
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


