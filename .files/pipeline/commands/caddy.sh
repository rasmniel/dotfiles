caddy_file() {
  local service="$1"
  local domain="$2"
  local port="$3"

  local host="$service.$domain"
  local caddy_file="/etc/caddy/hosts.d/$service.caddy"
  local caddy_template="$DEPLOY_ROOT/template.caddy"

  test -f "$caddy_file" && sudo rm "$caddy_file"
  sudo cp "$caddy_template" "$caddy_file"
  sudo sed -i -e "s|@host|$host|g" "$caddy_file"
  sudo sed -i -e "s|@port|$port|g" "$caddy_file"
  sudo chmod 644 "$caddy_file"
  sudo chown caddy:caddy "$caddy_file"

  # Reload caddy to integrate the new file.
  sudo systemctl reload caddy

  output_file "Created reverse proxy file:" "$caddy_file"
}
