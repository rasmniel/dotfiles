clone_service() {
    local service="$1"
    local remote="$2"
    local user="$DEFAULT_GIT_USER"

    case "$service" in
        *[!A-Za-z0-9._-]*|"") panic "Invalid service name: \"$service\"" ;;
    esac

    local repo="git@$remote:$user/$service.git"

    cd "$SOURCE_ROOT" || panic "No source root."
    test -d "./$service" && panic "Service \"$service\" already exists."

    ensure_ssh_deploy_key "$service" "$remote"
    git clone "$repo" > "$OUTPUT" 2>&1 || panic "Cannot clone repository \"$repo\""

    output_service "Cloned $remote repository:" "$service"
}

