# TODO: Declare rules for node flavor
#   - Must declare package.main
#   - Must declare package.scripts.postinstall to build

pre_install__node() {
    test -f package.json || return 1
    local install="install"
    test -f package-lock.json && install="ci"
    if loading_enabled; then
        npm "$install" > "$OUTPUT" 2>&1 &
        loading "$1"
    else
        npm "$install" > "$OUTPUT" 2>&1
    fi
}

post_install__node() {
    local service_dest="$SERVER_ROOT/$1"
    sudo mkdir -p "$service_dest/bin"
    sudo cp "$(which node)" "$service_dest/bin/node"
}

service_exec__node() {
    local service="$1"
    local port="$2"
    local main
    main="$(jq -r '.main' package.json)"
    test -n "$main" || panic "Node application $service does not declare package.main"
    printf "%s" "/srv/$service/bin/node /srv/$service/$main --port=$port"
}
