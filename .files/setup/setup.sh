# Setup home binary path.
export HOME_BIN="$HOME/bin"
mkdir -p "$HOME_BIN"

# Setup fonts directory.
export FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Setup download directory.
export DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Dotfiles should already exist, so don't create it.
export SETUP="$HOME/.files/setup"

# Source and list setup aliases
echo "Setup aliases enabled:"
. "$SETUP/setup_apt.sh"
. "$SETUP/setup_caddy.sh"
. "$SETUP/setup_nvim.sh"
. "$SETUP/setup_mise.sh"
. "$SETUP/setup_font.sh"

