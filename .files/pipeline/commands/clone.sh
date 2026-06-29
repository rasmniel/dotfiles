clone_service() {
    case "$SERVICE" in
        *[!A-Za-z0-9._-]*|"") panic "Invalid service name: \"$SERVICE\"" ;;
    esac

    local repo="git@$REMOTE:$NAMESPACE/$SERVICE.git"

    cd "$SERVICE_ROOT" || panic "No service root."
    test -d "./$SERVICE" && panic "Service \"$SERVICE\" already exists."

    ensure_ssh_deploy_key "$SERVICE" "$REMOTE"
    git clone "$repo" > "$OUTPUT" 2>&1 || panic "Cannot clone repository \"$repo\""

    print_service "Cloned $REMOTE repository:" "$SERVICE"
}

