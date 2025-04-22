#!/bin/bash

CONFIG="$HOME/.config/helix/config.toml"
HOUR=$(date +%H)

# Time ranges for when to swap helix themes
if [ "$HOUR" -lt 6 ] || [ "$HOUR" -ge 20 ]; then
  THEME="dracula"
else
  THEME="github_light"
fi

# Use sed to replace the theme line in config.toml
# Assumes there's a line like: theme = "something"
sed -i "s/^theme = \".*\"/theme = \"$THEME\"/" "$CONFIG"
