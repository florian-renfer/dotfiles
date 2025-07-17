#!/bin/bash

# Define XDG directories, using defaults if environment variables are not set
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Create the directories if they do not exist
for dir in "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    else
        echo "Directory already exists: $dir"
    fi
done

# Set permissions (optional, but recommended)
chmod 700 "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"

# Append XDG variables to ~/.zshrc if not already present
ZSHRC="$HOME/.zshrc"
for var in XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME; do
    value=$(eval echo \$$var)
    if ! grep -q "^export $var=" "$ZSHRC"; then
        echo "export $var=\"$value\"" >> "$ZSHRC"
        echo "Added $var to $ZSHRC"
    fi
done
