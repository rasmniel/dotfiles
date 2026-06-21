enable_service() {
  local service="$1"
  local service_file="/etc/systemd/system/$service.service"

  test -f "$service_file" || panic "No service file found at \"$service_file\". Cannot enable service \"$service\"."

  # Start and enable systemd service.
  sudo systemctl enable "$service"
  sudo systemctl start "$service"

  output_service "Enabled service:" "$service"
}
