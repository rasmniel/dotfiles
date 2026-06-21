install_service() {
  local service="$1"
  local flavor="${2:-}"
  local service_source="$SOURCE_ROOT/$service"
  local service_dest="$SERVICE_ROOT/$service"

  # Update local sources.
  test ! -d "$service_source" && panic "Service sources do not exist at \"$service_source\""
  test -d "$service_dest" && panic "Service already live at \"$service_dest\""
  cd "$service_source" || exit 1
  git diff --quiet && git diff --cached --quiet || panic "Detected dirty git repository at \"$service_dest\""
  git pull > "$OUTPUT"

  # Flavor specific pre-install
  hook pre_install "$flavor" "$service"

  # Install source files at service destination.
  sudo rm -rf "$service_dest"
  sudo cp -rf "$service_source" "$service_dest"

  # Flavor specific post-install
  hook post_install "$flavor" "$service"

  # Ensuring correct service owner and permissions.
  sudo chmod -R u=rwX,go=rX "$service_dest"
  sudo chown -R root:root "$service_dest"

  # If the project contains a .env file, disable read permissions for group and other.
  test -f "$service_dest/.env" && sudo chmod 600 "$service_dest/.env"
  # If the project contains a .git directory, delete it.
  test -f "$service_dest/.git" && rm -rf "$service_dest/.git" || true

  output_file "Installed service:" "$service_dest"
}
