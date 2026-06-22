pre_install__node() {
    test -f package.json || return 1
    if [ -f package-lock.json ]; then
        npm ci > "$OUTPUT"
    else
        npm install > "$OUTPUT"
    fi
    # TODO: How to declare given build command?
    # npm run build
}

post_install__node() {
    local service_dest="$SERVICE_ROOT/$1"
    sudo mkdir -p "$service_dest/bin"
    sudo cp "$(which node)" "$service_dest/bin/node"
}

service_exec__node() {
    local service="$1"
    local port="$2"
    # TODO: `server.js` not necessarily correct. Read from package.json? Maybe use package.main?
    printf "%s" "/srv/$service/bin/node /srv/$service/server.js --port=$port"
}
