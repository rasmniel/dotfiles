detect_flavor() {
    local service="$1"
    local service_source="$SOURCE_ROOT/$service"

    test ! -d "$service_source" && panic "Service sources do not exist at \"$service_source\""
    cd "$service_source" || exit 1

    test -f package.json && printf "node" && return

    printf "none"
}
