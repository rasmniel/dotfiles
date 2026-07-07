__exec_start() {
    local exec="$EXEC_START"
    test -z "$exec" && exec="$(hook service_exec "$FLAVOR" "$SERVICE" "$PORT")"
    test -z "$exec" && panic "Flavor \"$FLAVOR\" provided no ExecStart command."

    printf "%s" "$exec"
}

__create_service_file() {
    local template="$1"

    local service_file="/etc/systemd/system/$SERVICE.service"
    test -f "$service_file" && sudo rm "$service_file"
    sudo cp "$template" "$service_file"
    sudo sed -i -e "s|@service|$SERVICE|g" "$service_file"
    sudo sed -i -e "s|@user|$USER|g" "$service_file"
    sudo sed -i -e "s|@exec|$(__exec_start)|g" "$service_file"
    sudo chmod 644 "$service_file"
    sudo chown root:root "$service_file"

    printf "%s" "$service_file"
}

__public_service_file() {
    local service_template="$PIPELINE_ROOT/templates/template.service"
    service_file="$(__create_service_file "$service_template")"

    print_file "Created service file:" "$service_file"
}

__private_service_file() {
    local service_template="$PIPELINE_ROOT/templates/template.local.service"
    service_file="$(__create_service_file "$service_template")"

    print_file "Created local service file:" "$service_file"
}

service_file() {
    if [ -n "$PUBLIC_DOMAIN" ]; then
        __public_service_file
    else
        __private_service_file
    fi
}
