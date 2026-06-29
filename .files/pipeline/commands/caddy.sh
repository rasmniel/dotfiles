caddy_file() {
  local host="$SERVICE.$DOMAIN"
  local caddy_file="/etc/caddy/hosts.d/$SERVICE.caddy"
  local caddy_template="$PIPELINE_ROOT/template.caddy"

  test -f "$caddy_file" && sudo rm "$caddy_file"
  sudo cp "$caddy_template" "$caddy_file"
  sudo sed -i -e "s|@host|$host|g" "$caddy_file"
  sudo sed -i -e "s|@service|$SERVICE|g" "$caddy_file"
  sudo sed -i -e "s|@port|$PORT|g" "$caddy_file"
  sudo chmod 644 "$caddy_file"
  sudo chown caddy:caddy "$caddy_file"

  # Reload caddy to integrate the new file.
  sudo systemctl reload caddy

  print_file "Created reverse proxy file:" "$caddy_file"
}
