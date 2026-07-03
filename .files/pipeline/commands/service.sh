__create_service_file() {
    local template="$1"
    local exec="$2"

    local service_file="/etc/systemd/system/$SERVICE.service"
    test -f "$service_file" && sudo rm "$service_file"
    sudo cp "$template" "$service_file"
    sudo sed -i -e "s|@service|$SERVICE|g" "$service_file"
    sudo sed -i -e "s|@user|$USER|g" "$service_file"
    sudo sed -i -e "s|@exec|$exec|g" "$service_file"
    sudo chmod 644 "$service_file"
    sudo chown root:root "$service_file"

    printf "%s" "$service_file"
}

service_file() {
    local exec="$EXEC_START"
    test -z "$exec" && exec="$(hook service_exec "$FLAVOR" "$SERVICE" "$PORT")"
    test -z "$exec" && panic "Flavor \"$FLAVOR\" provided no ExecStart command."

    local service_template="$PIPELINE_ROOT/template.service"
    service_file="$(__create_service_file "$service_template" "$exec")"

    print_file "Created service file:" "$service_file"
}

local_service_file() {
    test -z "$EXEC_START" && return 0

    local service_template="$PIPELINE_ROOT/template.local.service"
    service_file="$(__create_service_file "$service_template" "$EXEC_START")"

    print_file "Created local service file:" "$service_file"
}

