#!/bin/bash
set -euo pipefail

# -- Ensure required utilities exist
command -v wget >/dev/null 2>&1 || { echo "wget is required but not installed. Aborting."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is required but not installed. Aborting."; exit 1; }

add_ppa() {
  local identifier=$1
  if ! grep -R "$identifier" /etc/apt/sources.list /etc/apt/sources.list.d/* > /dev/null 2>&1; then
    echo "Adding PPA: $identifier"
    sudo add-apt-repository "ppa:$identifier"
  else
    echo "PPA $identifier already exists. Skipping..."
  fi
}

# --- Add custom PPAs ---
add_ppa "maveonair/helix-editor"
add_ppa "dotnet/backports"

# --- Update and Upgrade system ---
echo "Updating package lists..."
sudo apt update -y

echo "Upgrading installed packages..."
sudo apt upgrade -y

# --- Essential packages ---
echo "Installing essential packages..."
sudo apt install -y build-essential git helix vim htop tig dotnet-sdk-8.0 dotnet-sdk-9.0

# --- Clean up unnecessary files ---
sudo apt autoremove -y

# --- Install Node version manager (NVM) if not already installed ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  echo "NVM already installed. Skipping..."
fi

# --- Install oh-my-bash if not already installed ---
if [ ! -d "$HOME/.oh-my-bash" ]; then
  echo "Installing oh-my-bash..."
  wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O - | bash
else
  echo "oh-my-bash already installed. Skipping..."
fi

# -- Install Rust via rustup if not already installed --
if ! command -v rustup >/dev/null 2>&1; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "Rust is already installed. Skipping..."
fi

# --- Setup editor and shell ---
echo "Setting up Helix editor configuration..."
mkdir -p "$HOME/.config/helix"
cp -r helix/. "$HOME/.config/helix"

echo "Copying bash aliases..."
cp bash_aliases "$HOME/.bash_aliases"

echo "System setup is complete!"
exec bash

