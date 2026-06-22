#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090

# TODO: Migrate to `projects` directory instead of alternatives.
# # Setup service directory.
# export PROJECTS_DIR="$HOME/Projects"
# mkdir -p "$PROJECTS_DIR"

# Setup service directory.
export SERVICE_DIR="$HOME/Services"
mkdir -p "$SERVICE_DIR"

# Setup fonts directory.
export FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Setup download directory.
export DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Source package aliases.
for p in "$HOME/.files/setup/packages/"*; do source "$p"; done

echo_usage() {
    echo "Usage: setup [apt|caddy|tailscale|nvim|mise|node|font]"
}

if [ -z "$1" ]; then
    echo "Available packages:"
    echo
    echo "- apt: Install default apt packages."
    echo "- caddy:Install and configure Caddy from official third-party repository."
    echo "- tailscale: Install and start the Tailscale server."
    echo "- nvim: Install Neovim 0.11 from official repository."
    echo "- mise: Install mise with official script @ mise.run and install packages."
    echo "- node: Install latest nodejs version with mise."
    echo "- font: Install JetBrainsMono nerd font."
    echo
    echo_usage
fi

while [ $# -gt 0 ]; do
    case "$1" in
        apt) setup_apt ;;
        caddy) setup_caddy ;;
        tailscale) setup_tailscale ;;
        nvim) setup_nvim ;;
        mise) setup_mise ;;
        node) setup_node ;;
        font) setup_nerd_font ;;
        *) echo "Unsupported package: $1" ;;
    esac
    shift
done

echo
exit 0
