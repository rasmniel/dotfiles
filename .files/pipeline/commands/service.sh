service_file() {
    local exec
    exec="$(hook service_exec "$FLAVOR" "$SERVICE" "$PORT")"
    test -z "$exec" && panic "Flavor \"$FLAVOR\" provided no ExecStart command."

    local service_file="/etc/systemd/system/$SERVICE.service"
    local service_template="$PIPELINE_ROOT/template.service"

    # Create and move service file.
    test -f "$service_file" && sudo rm "$service_file"
    sudo cp "$service_template" "$service_file"
    sudo sed -i -e "s|@service|$SERVICE|g" "$service_file"
    sudo sed -i -e "s|@exec|$exec|g" "$service_file"
    sudo chmod 644 "$service_file"
    sudo chown root:root "$service_file"

    print_file "Created service file:" "$service_file"
}

