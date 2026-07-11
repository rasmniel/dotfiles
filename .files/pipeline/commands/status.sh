__not_detected() {
    printf "%s not detected\n" "$1"
}

__detect_port() {
    local port=

    local pid=
    local sock=
    pid="$(systemctl show -p MainPID --value "$SERVICE")"
    if [ -n "$pid" ]; then
        sock="$(ss -ltnup | grep "$pid" || true)"
        if [ -n "$sock" ]; then
            port="$(echo "$sock" | tr -s ' ' | cut -d ' ' -f5)"
            port="${port#*:*}"
        fi
    fi

    # Attempt to derive the port from the service's caddy file.
    if [ -z "$port" ]; then
        local caddy_file="/etc/caddy/hosts.d/$SERVICE.caddy"
        if [ -f "$caddy_file" ]; then
            local proxy=
            proxy="$(cat "$caddy_file" | grep reverse_proxy)"
            port="${proxy#*:*}"
        fi
    fi

    # Fallback to non-auto global port.
    # If service was just created, it may not be immediately ready.
    # shellcheck disable=SC2153
    if [ -z "$port" ] && [ "$PORT" != auto ]; then
        port="$PORT"
    fi

    test -n "$port" && printf "%s" "$port"
}

service_status() {
    local service_source="$SERVICE_ROOT/$SERVICE"
    local service_dest="$SERVER_ROOT/$SERVICE"

    if [ ! -d "$service_source" ]; then
        print_failure "Not a known service:" "$SERVICE"
    elif [ ! -d "$service_dest" ]; then
        print_failure "Not installed by pipeline:" "$SERVICE"
    else
        print_identity "Service is installed:" "$SERVICE"
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
        port="$(__detect_port || true)"
        if [ -n "$port" ]; then
            print_service "Listening on port" "$port"
        else
            __not_detected "Service port"
        fi

        print_identity "Service is" "active"
    elif [ -d "$service_dest" ]; then
        echo "Service is inactive"
    fi
}

list_services() {
    declare -A services

    # Idenify local services.
    for server in /srv/*; do
        local service=
        service="$(basename "$server")"
        services["$service"]="server"
    done

    # Identify caddy files.
    for caddy_file in /etc/caddy/hosts.d/*.caddy; do
        test -e "$caddy_file" || continue
        local service=
        service="$(basename "$caddy_file")"
        service="${service%*.caddy}"
        if [ -z "${services["$service"]:-}" ]; then
            services["$service"]="proxy"
        else
            services["$service"]+=", proxy"
        fi
    done

    for service in "${!services[@]}"; do
        print_service "$service:" "${services[$service]}"
    done
}
