install_service() {
    local service_source="$SERVICE_ROOT/$SERVICE"
    local service_dest="$SERVER_ROOT/$SERVICE"

    # Update local sources.
    test -d "$service_source" || panic "Service sources do not exist at \"$service_source\""
    test -d "$service_dest" && panic "Service already live at \"$service_dest\""
    cd "$service_source" || exit 1
    test -n "$(git status --porcelain)" && panic "Detected dirty git repository at \"$service_dest\""

    # Pull with git.
    ensure_ssh_deploy_key "$SERVICE" "$REMOTE"
    git pull --ff-only > "$OUTPUT" 2>&1 || panic "Cannot pull git repository for service $SERVICE"

    # Flavor specific pre-install.
    hook pre_install "$FLAVOR" "$SERVICE"

    # Install source files at service destination.
    sudo rm -rf "$service_dest"
    sudo cp -rf "$service_source" "$service_dest"

    # Flavor specific post-install.
    hook post_install "$FLAVOR" "$SERVICE"

    # Ensuring correct service owner and permissions.
    sudo chmod -R u=rwX,go=rX "$service_dest"
    sudo chown -R root:root "$service_dest"

    # If the directory contains a .env file, disable read permissions for group and other.
    if [ -f "$service_dest/.env" ]; then
        sudo chmod 600 "$service_dest/.env"
    fi
    # If the directory contains a .git directory, delete it.
    if [ -f "$service_dest/.git" ]; then
        rm -rf "$service_dest/.git"
    fi

    print_file "Installed service:" "$service_dest"
}

