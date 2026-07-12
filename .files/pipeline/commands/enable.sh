enable_service() {
    local service_file="/etc/systemd/system/$SERVICE.service"
    test -f "$service_file" || panic "No service file found at \"$service_file\". Cannot enable service \"$SERVICE\"."

    sudo systemctl enable --now "$SERVICE"

    print_service "Enabled service:" "$SERVICE"
}

restart_service() {
    local service_file="/etc/systemd/system/$SERVICE.service"
    if [ ! -f "$service_file" ]; then
        printf 'No service file found at "%s". Cannot restart service "%s"\n' "$service_file" "$SERVICE"
        return
    fi

    sudo systemctl restart "$SERVICE"

    print_service "Restarted service:" "$SERVICE"
}

