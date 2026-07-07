__create_caddy_file() {
    local template="$1"
    local caddy_file="/etc/caddy/hosts.d/$SERVICE.caddy"
    # localhost is typically already mapped and doesn't need a manual host entry.
    local domain_name="localhost"
    test -n "$PUBLIC_DOMAIN" && domain_name="$PUBLIC_DOMAIN"

    test -f "$caddy_file" && sudo rm "$caddy_file"
    sudo cp "$template" "$caddy_file"
    sudo sed -i -e "s|@host|$SERVICE.$domain_name|g" "$caddy_file"
    sudo sed -i -e "s|@service|$SERVICE|g" "$caddy_file"
    sudo sed -i -e "s|@port|$PORT|g" "$caddy_file"
    sudo chmod 644 "$caddy_file"
    sudo chown caddy:caddy "$caddy_file"

    # Reload caddy to integrate the new file.
    sudo systemctl reload caddy

    printf "%s" "$caddy_file"
}

__public_caddy_file() {
    local caddy_template="$PIPELINE_ROOT/templates/template.caddy"
    caddy_file="$(__create_caddy_file "$caddy_template")"

    print_file "Created reverse proxy file:" "$caddy_file"
}

__private_caddy_file() {
    local caddy_template="$PIPELINE_ROOT/templates/template.local.caddy"
    caddy_file="$(__create_caddy_file "$caddy_template")"

    print_file "Created local reverse proxy file:" "$caddy_file"
}

caddy_file() {
    if [ -n "$PUBLIC_DOMAIN" ]; then
        __public_caddy_file
    else
        __private_caddy_file
    fi
}
