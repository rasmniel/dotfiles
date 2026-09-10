#!/usr/bin/env bash

set -euo pipefail

ALACRITTY="$HOME/.config/alacritty/alacritty.toml"
ACUITTY="$HOME/.config/alacritty/acuitty.toml"
INIT="$HOME/.config/alacritty/acuitty.toml.init"

# Ensure acuitty.toml exists.
test -f "$ACUITTY" || cp "$INIT" "$ACUITTY"

toggle_field() {
    local field="$1"
    local config
    config="$(grep "$field" "$ACUITTY")"
    test -z "$config" && echo "Missing Acuitty field: $field" && return

    local from_value="$2"
    local to_value="$3"
    local from="$field = $from_value"
    local to="$field = $to_value"

    if [ "$config" == "$from" ]; then
        sed -i -e "s|$from|$to|" "$ACUITTY"
    else
        sed -i -e "s|$to|$from|" "$ACUITTY"
    fi

    touch "$ALACRITTY"
}

toggle_opacity() {
    toggle_field opacity 1 0.9
}

while [ $# -gt 0 ]; do
    case "$1" in
        opacity|o) toggle_opacity ;;
        *) echo "Unknown argument: $1" ;;
    esac
    shift
done
