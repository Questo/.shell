#!/bin/bash

# --- Determine the correct home directory for the non-root user.
if [ -n "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

# --- Add custom PPAs ---
sudo add-apt-repository ppa:maveonair/helix-editor
sudo add-apt-repository ppa:dotnet/backports

# --- Update and Upgrade system ---
echo "Updating package lists..."
sudo apt update -y

echo "Upgrading installed packages..."
sudo apt upgrade -y

# --- Essential packages ---
echo "Installing essential packages..."
sudo apt install -y build-essential git helix vim htop tig dotnet-sdk-9.0

# --- Clean up unnecessary files ---
sudo apt autoremove -y

# --- Setup editor and shell ---
cp -r helix/. "$USER_HOME/.config/helix"
cp bash_aliases "$USER_HOME/.bash_aliases"
source "$USER_HOME/.bashrc"

# --- Final message ---
echo "System setup is complete!"
