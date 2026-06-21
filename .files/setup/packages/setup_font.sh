setup_font() {
    font_name="$FONTS_DIR/JetBrainsMono"

    # Do not setup font twice.
    test -d "$font_name" && return

    font_zip="$DOWNLOAD_DIR/JetBrainsMono.zip"
    nerd_font_download="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    # Download and install font.
    if wget -O "$font_zip" "$nerd_font_download"; then
        unzip "$font_zip" -d "$font_name"
        rm "$font_zip"
        fc-cache -fv
        echo "JetBrainsMono nerd font installed. May require terminal restart before fonts can render correctly."
    else
        echo "JetBrainsMono nerd font download failed."
    fi
}

