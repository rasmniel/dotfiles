__create_caddy_file() {
    local template="$1"
    local caddy_file="/etc/caddy/hosts.d/$SERVICE.caddy"

    test -f "$caddy_file" && sudo rm "$caddy_file"
    sudo cp "$template" "$caddy_file"
    sudo sed -i -e "s|@host|$SERVICE.$DOMAIN|g" "$caddy_file"
    sudo sed -i -e "s|@service|$SERVICE|g" "$caddy_file"
    sudo sed -i -e "s|@port|$PORT|g" "$caddy_file"
    sudo chmod 644 "$caddy_file"
    sudo chown caddy:caddy "$caddy_file"

    # Reload caddy to integrate the new file.
    sudo systemctl reload caddy

    printf "%s" "$caddy_file"
}

caddy_file() {
    local caddy_template="$PIPELINE_ROOT/template.caddy"
    caddy_file="$(__create_caddy_file "$caddy_template")"

    print_file "Created reverse proxy file:" "$caddy_file"
}

local_caddy_file() {
    test -z "$PORT" && return 0

    local caddy_template="$PIPELINE_ROOT/template.local.caddy"
    caddy_file="$(__create_caddy_file "$caddy_template")"

    print_file "Created local reverse proxy file:" "$caddy_file"
}

