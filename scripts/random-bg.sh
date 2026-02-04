#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"

# Get the currently set wallpaper for the main monitor (adjust as needed)
CURRENT_WALL=$(hyprctl hyprpaper list | grep '^wallpaper' | awk -F' ' '{print $3}' | head -n1)

# Find a random wallpaper that is not the current one
if [[ -n "$CURRENT_WALL" ]]; then
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)
else
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
fi

# If no wallpaper found, exit
if [[ -z "$WALLPAPER" ]]; then
  echo "No wallpaper found."
  exit 1
fi

# Set the wallpaper for all monitors (adjust as needed)
for MON in $(hyprctl monitors -j | jq -r '.[].name'); do
  hyprctl hyprpaper wallpaper "$MON,$WALLPAPER"
done

# Generate colorscheme based on the wallpaper
wallust -I background -I foreground -I cursor -q run "$WALLPAPER"
