# Suppress openBinaryFile warning about non-existent file.
# shellcheck disable=SC1091

# Setup fonts directory.
export FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Setup download directory.
export DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Dotfiles should already exist, so don't create it.
export PACKAGES="$HOME/.files/setup/packages"

# Source and list setup aliases
. "$PACKAGES/setup_apt.sh"
. "$PACKAGES/setup_caddy.sh"
. "$PACKAGES/setup_nvim.sh"
. "$PACKAGES/setup_mise.sh"
. "$PACKAGES/setup_font.sh"

if [ -z "$1" ]; then
    echo "Available packages:"
    echo "- apt: Install default apt packages."
    echo "- caddy: Install and configure Caddy from official third-party repository."
    echo "- nvim: Install Neovim 0.11 from official repository."
    echo "- mise: Install mise with official script @ mise.run and install packages."
    echo "- node: Install latest nodejs version with mise."
    echo "- font: Install JetBrainsMono nerd font."
    return 0
fi

while [ $# -gt 0 ]; do
    case "$1" in
        apt) setup_apt ;;
        caddy) setup_caddy ;;
        nvim) setup_nvim ;;
        mise) setup_mise ;;
        node) setup_node ;;
        font) setup_font ;;
    esac
    shift
done
