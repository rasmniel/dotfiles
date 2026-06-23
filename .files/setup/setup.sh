#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090

# Setup service directory.
export PROJECTS_DIR="$HOME/projects"
mkdir -p "$PROJECTS_DIR"

# Setup service directory.
export SERVICE_DIR="$HOME/services"
mkdir -p "$SERVICE_DIR"

# Setup fonts directory.
export FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Source package aliases.
for p in "$HOME/.files/setup/packages/"*; do . "$p"; done

echo_usage() {
    echo "Usage: setup package1 package2 package3 ..."
}

if [ -z "$1" ]; then
    echo
    echo "Available packages:"
    echo
    echo "- apt         Setup default apt packages."
    echo "- nvim        Setup Neovim 0.11 from official repository."
    echo "- font        Setup JetBrainsMono nerd font."
    echo "- caddy       Setup and launch Caddy from official third-party repository."
    echo "- mise        Setup mise with official script @ mise.run and install packages."
    echo "- node        Setup latest nodejs version with mise."
    echo "- tailscale   Setup and launch the Tailscale server."
    echo "- syncthing   Setup and launch the Syncthing server."
    echo
    echo_usage
fi

while [ $# -gt 0 ]; do
    case "$1" in
        apt) setup_apt ;;
        nvim) setup_nvim ;;
        font) setup_nerd_font ;;
        caddy) setup_caddy ;;
        mise) setup_mise ;;
        node) setup_node ;;
        tailscale) setup_tailscale ;;
        syncthing) setup_syncthing ;;
        *) echo "Unsupported package: $1" ;;
    esac
    shift
done

echo
