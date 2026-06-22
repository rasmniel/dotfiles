# Suppress openBinaryFile warning about non-existent file.
# shellcheck disable=SC1091

# TODO: Migrate to `projects` directory instead of alternatives.
# # Setup service directory.
# export PROJECTS_DIR="$HOME/projects"
# mkdir -p "$PROJECTS_DIR"

# Setup service directory.
export SERVICE_DIR="$HOME/services"
mkdir -p "$SERVICE_DIR"

# Setup fonts directory.
export FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Setup download directory.
export DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Source setup aliases.
export PACKAGES="$HOME/.files/setup/packages"
. "$PACKAGES/setup_apt.sh"
. "$PACKAGES/setup_caddy.sh"
. "$PACKAGES/setup_nvim.sh"
. "$PACKAGES/setup_mise.sh"
. "$PACKAGES/setup_font.sh"

echo_usage() {
    echo "Usage: setup [apt|caddy|nvim|mise|node|font]"
}

if [ -z "$1" ]; then
    echo "Available packages:"
    echo
    echo "- apt: Install default apt packages."
    echo "- caddy: Install and configure Caddy from official third-party repository."
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
        nvim) setup_nvim ;;
        mise) setup_mise ;;
        node) setup_node ;;
        font) setup_font ;;
        *) echo "Unsupported package: $1" ;;
    esac
    shift
done

echo
exit 0
