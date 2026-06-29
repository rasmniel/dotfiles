enable_service() {
    local service_file="/etc/systemd/system/$SERVICE.service"

    test -f "$service_file" || panic "No service file found at \"$service_file\". Cannot enable service \"$SERVICE\"."

    # Enable and start systemd service.
    sudo systemctl enable --now "$SERVICE"

    print_service "Enabled service:" "$SERVICE"
}
