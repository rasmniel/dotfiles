#!/usr/bin/env bash

# NOTE: This setup script is aimed towards Ubuntu/Debian distros.
#   Some scripts may work for other distros.

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090
# shellcheck disable=SC1091

set -Eeuo pipefail

trap 'kill "$(jobs -p)"; exit 130;' INT

# Source environment.
. "$SCRIPT_ROOT/source.sh"

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
SETUP_ROOT="$(dirname "$0")"
for package in "$SETUP_ROOT/packages/"*; do . "$package"; done
. "$SETUP_ROOT/state.sh"

if [ -z "${1:-}" ]; then
    echo
    echo "Available packages:"
    echo
    print_li "apt" "Setup default apt packages." "$(state_bullet "apt")" "$(state_color "apt")"
    print_li "nvim" "Setup Neovim 0.11 from official repository." "$(state_bullet "nvim")" "$(state_color "nvim")"
    print_li "opencode" "Setup Opencode with official install script." "$(state_bullet "opencode")" "$(state_color "opencode")"
    print_li "lazy" "Setup lazygit and lazydocker from official install scripts." "$(state_bullet "lazy")" "$(state_color "lazy")"
    print_li "fastfetch" "Setup fastfetch binary from script." "$(state_bullet "fastfetch")" "$(state_color "fastfetch")"
    print_li "font" "Setup JetBrainsMono nerd font." "$(state_bullet "font")" "$(state_color "font")"
    print_li "keepass" "Setup KeePassXC with Flatpak." "$(state_bullet "keepass")" "$(state_color "keepass")"
    print_li "brave" "Setup Brave browser from official third-party repository." "$(state_bullet "brave-browser")" "$(state_color "brave-browser")"
    print_li "caddy" "Setup and launch Caddy from official third-party repository." "$(state_bullet "caddy")" "$(state_color "caddy")"
    print_li "mise" "Setup mise with official script @ mise.run and install packages." "$(state_bullet "mise")" "$(state_color "mise")"
    print_li "ufw" "Setup and enable uncomplicated firewall with strict webhost rules." "$(state_bullet "ufw")" "$(state_color "ufw")"
    print_li "tailscale" "Setup and launch the Tailscale client." "$(state_bullet "tailscale")" "$(state_color "tailscale")"
    print_li "syncthing" "Setup and launch the Syncthing server." "$(state_bullet "syncthing")" "$(state_color "syncthing")"
    echo
    echo "Usage: setup package1 package2 package3 ..."
fi

# TODO: Support removal of installed packages

while [ $# -gt 0 ]; do
    case "$1" in
        apt) setup_apt ;;
        nvim) setup_nvim ;;
        font) setup_nerd_font ;;
        opencode) setup_opencode ;;
        lazy) setup_lazygit && setup_lazydocker ;;
        fastfetch) setup_fastfetch ;;
        keepass) setup_keepass ;;
        brave) setup_brave ;;
        caddy) setup_caddy ;;
        mise) setup_mise ;;
        ufw) setup_ufw ;;
        tailscale) setup_tailscale ;;
        syncthing) setup_syncthing ;;
        *) panic "Unsupported package: $1" ;;
    esac
    shift
done

echo

