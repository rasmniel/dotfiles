__not_detected() {
    printf "%s not detected\n" "$1"
}

__detect_port() {
    local pid=
    pid="$(systemctl show -p MainPID --value "$SERVICE")"
    test -z "$pid" && return

    local sock=
    sock="$(ss -ltnup | grep "$pid" || true)"
    test -z "$sock" && return

    local port=
    port="$(echo "$sock" | tr -s ' ' | cut -d ' ' -f5)"
    test -z "$port" && return

    printf "%s" "$port"
}

service_status() {
    local service_source="$SERVICE_ROOT/$SERVICE"
    local service_dest="$SERVER_ROOT/$SERVICE"

    if [ ! -d "$service_source" ]; then
        print_failure "Not a known service:" "$SERVICE"
    elif [ ! -d "$service_dest" ]; then
        print_failure "Not installed by pipeline:" "$SERVICE"
    else
        print_identity "Status for service:" "$SERVICE"
    fi

    if [ -d "$service_source" ]; then
        local flavor=
        flavor="$(detect_flavor)"
        if [ "$flavor" != none ]; then
            print_service "Flavor:" "$flavor"
        else
            __not_detected "Flavor"
        fi

        print_file "Source location:" "$service_source"
        test -d "$service_dest" && print_file "Service location:" "$service_dest"
    fi

    local service_file="/etc/systemd/system/$SERVICE.service"
    if [ -f "$service_file" ]; then
        print_file "Service file:" "$service_file"
    else
        __not_detected "Service file"
    fi

    local caddy_file="/etc/caddy/hosts.d/$SERVICE.caddy"
    if [ -f "$caddy_file" ]; then
        print_file "Caddy file:" "$caddy_file"
    else
        __not_detected "Caddy file"
    fi

    if systemctl is-active --quiet "$SERVICE"; then
        local port=
        port="$(__detect_port)"
        # Fallback to global port.
        # If service was just created, it may not be immediately ready.
        # shellcheck disable=SC2153
        test -z "$port" && port="$PORT"
        if [ -n "$port" ]; then
            print_service "Listening on port" "${port#*:*}"
        else
            __not_detected "Service port"
        fi

        print_identity "Service is" "active"
    else
        echo "Service is inactive"
    fi
}

