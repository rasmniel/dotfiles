JETBRAINS_FONT_DIR="$FONTS_DIR/JetBrainsMono"
FONTCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d"
FONTCONFIG_FILE="$FONTCONFIG_DIR/99-nerd-font.conf"

setup_nerd_font() {
    # Do not setup font twice.
    test -d "$JETBRAINS_FONT_DIR" && return

    font_zip="$HOME/Downloads/JetBrainsMono.zip"
    nerd_font_download="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    # Download and install font.
    if wget -O "$font_zip" "$nerd_font_download"; then
        unzip "$font_zip" -d "$JETBRAINS_FONT_DIR"
        rm "$font_zip"

        set_default_monospace "JetBrainsMono Nerd Font"

        fc-cache -fv
        echo "JetBrainsMono nerd font installed. May require terminal restart before fonts can render correctly."
        echo "Monospace font:"
        fc-match monospace
    else
        echo "JetBrainsMono nerd font download failed."
    fi
}

set_default_monospace() {
    local font_name="$1"
    test -z "$font_name" && return 0

    mkdir -p "$FONTCONFIG_DIR"

    cat > "$FONTCONFIG_FILE" << EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
    <alias>
        <family>monospace</family>
        <prefer>
            <family>$font_name</family>
        </prefer>
    </alias>
</fontconfig>
EOF
}

remove_nerd_font() {
    test -d "$JETBRAINS_FONT_DIR" || panic "JetBrainsMono not installed."
    rm -rf "$JETBRAINS_FONT_DIR"
    rm "$FONTCONFIG_FILE"
    fc-cache -fv
    echo "JetBrainsMono font removed. May require terminal restart to take effect."
}
