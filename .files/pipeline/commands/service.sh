service_file() {
    local service="$1"
    local port="$2"
    local flavor="${3:-}"

    local exec
    exec="$(hook service_exec "$flavor" "$service" "$port")"
    test -z "$exec" && panic "Flavor \"$flavor\" provided no ExecStart command."

    local service_file="/etc/systemd/system/$service.service"
    local service_template="$DEPLOY_ROOT/template.service"

    # Create and move service file.
    test -f "$service_file" && sudo rm "$service_file"
    sudo cp "$service_template" "$service_file"
    sudo sed -i -e "s|@service|$service|g" "$service_file"
    sudo sed -i -e "s|@exec|$exec|g" "$service_file"
    sudo chmod 644 "$service_file"
    sudo chown root:root "$service_file"

    output_file "Created service file:" "$service_file"
}

