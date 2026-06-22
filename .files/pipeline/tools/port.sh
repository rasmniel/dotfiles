__next_port() {
    local type="$1"
    local ports="$DEPLOY_ROOT/.ports"
    test -f "$ports" || panic "The .ports file is missing. Cannot derive next port."

    local port_type
    port_type="$(cat "$ports" | grep "$type")"

    local current=${port_type##*=}
    [[ "$current" =~ ^[0-9]+$ ]] || panic "Invalid $type port found: $current"
    local next="$((current + 1))"
    sed -i -e "s|$type=$current|$type=$next|" "$ports"

    printf "%s" "$current"
}

next_public_port() {
    __next_port public
}

next_private_port() {
    __next_port private
}
