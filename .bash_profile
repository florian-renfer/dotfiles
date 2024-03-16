# @author: Florian Renfer
# @date: 16.03.2024
# @version: 1.0

# Setup homebrew properly
if [[ "$OSTYPE" == "darwin"* ]]; then
  # needed for brew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Source .bashrc if it exists
if [ -r ~/.bashrc ]; then
	source ~/.bashrc
fi

# Permanently set the XDG_CONFIG_HOME environment variable
export XDG_CONFIG_HOME="$HOME"/.config
