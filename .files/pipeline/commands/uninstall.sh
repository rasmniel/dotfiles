clean_service() {
    local service_dest="/srv/$SERVICE"
    test -d "$service_dest" && sudo rm -fr "$service_dest" || true
}

uninstall_service() {
    local hard="${1:-}"

    local service_file="/etc/systemd/system/$SERVICE.service"
    if [ -f "$service_file" ]; then
        sudo systemctl stop "$SERVICE" 2>/dev/null || true
        sudo rm "$service_file"
        sudo systemctl daemon-reload
    fi

    local caddy_file="/etc/caddy/hosts.d/$SERVICE.caddy"
    test -f "$caddy_file" && sudo rm "$caddy_file" && sudo systemctl reload caddy

    local service_dest="/srv/$SERVICE"
    test -d "$service_dest" && sudo rm -fr "$service_dest"

    if [ "$hard" = true ]; then
        local service_source="$SERVICE_ROOT/$SERVICE"
        test -d "$service_source" && sudo rm -fr "$service_source"
    fi

    if [ "$hard" = true ]; then
        print_service "Deleted service:" "$SERVICE"
    else
        print_service "Uninstalled service:" "$SERVICE"
    fi
}

