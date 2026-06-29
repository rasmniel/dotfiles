JETBRAINS_FONT_DIR="$FONTS_DIR/JetBrainsMono"

setup_nerd_font() {
    # Do not setup font twice.
    test -d "$JETBRAINS_FONT_DIR" && return

    font_zip="$HOME/Downloads/JetBrainsMono.zip"
    nerd_font_download="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    # Download and install font.
    if wget -O "$font_zip" "$nerd_font_download"; then
        unzip "$font_zip" -d "$JETBRAINS_FONT_DIR"
        rm "$font_zip"
        fc-cache -fv
        echo "JetBrainsMono nerd font installed. May require terminal restart before fonts can render correctly."
    else
        echo "JetBrainsMono nerd font download failed."
    fi
}

remove_nerd_font() {
    test -d "$JETBRAINS_FONT_DIR" || panic "JetBrainsMono not installed."
    rm -rf "$JETBRAINS_FONT_DIR"
    fc-cache -fv
    echo "JetBrainsMono font removed. May require terminal restart to take effect."
}
