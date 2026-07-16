state_color() {
    state "$1" "$PRINT_COLOR_IDENTITY" "$PRINT_COLOR_FAILURE"
}

state_bullet() {
    state "$1" "*" "-"
}

state() {
    local enabled=false
    local package="$1"

    case "$package" in
        # Heuristically use `jq` as a an indicator for apt installation state.
        apt) command -v jq > /dev/null && enabled=true ;;
        ufw) test "$(grep "^ENABLED=" /etc/ufw/ufw.conf)" = "ENABLED=yes" && enabled=true ;;
        font) test -d "$FONTS_DIR/JetBrainsMono" && enabled=true ;;
        keepass) command -v flatpak > /dev/null && flatpak info org.keepassxc.KeePassXC > /dev/null && enabled=true ;;
        *) command -v "$1" > /dev/null && enabled=true ;;
    esac

    test "$enabled" = true && echo "$2" || echo "$3"
}
