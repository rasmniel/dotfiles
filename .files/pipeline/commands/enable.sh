enable_service() {
  local service="$1"
  local service_file="/etc/systemd/system/$service.service"

  test -f "$service_file" || panic "No service file found at \"$service_file\". Cannot enable service \"$service\"."

  # Enable and start systemd service.
  sudo systemctl enable --now "$service"

  output_service "Enabled service:" "$service"
}
