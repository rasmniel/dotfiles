uninstall_service() {
  local service="$1"
  local hard="${2:-}"

  local service_file="/etc/systemd/system/$service.service"
  test -f "$service_file" && sudo rm "$service_file"

  local caddy_file="/etc/caddy/hosts.d/$service.caddy"
  test -f "$caddy_file" && sudo rm "$caddy_file" && sudo systemctl reload caddy

  local service_dest="/srv/$service"
  test -d "$service_dest" && sudo rm -fr "$service_dest"

  if [ ! -z "$hard" ]; then
    local service_source="$SOURCE_ROOT/$service"
    test -d "$service_source" && sudo rm -fr "$service_source"
  fi

  sudo systemctl daemon-reload
  # Always return true, even if the service cannot be stopped.
  sudo systemctl stop "$service" 2>/dev/null || true
}
