detect_flavor() {
    local service_source="$SERVICE_ROOT/$SERVICE"

    test -d "$service_source" || panic "Service sources do not exist at \"$service_source\""
    cd "$service_source" || exit 1

    test -f package.json && printf "node" && return

    printf "none"
}
