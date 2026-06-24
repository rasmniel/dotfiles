install_service() {
    local service="$1"
    local remote="$2"
    local flavor="${3:-}"
    local service_source="$SOURCE_ROOT/$service"
    local service_dest="$SERVICE_ROOT/$service"

    # Update local sources.
    test -d "$service_source" || panic "Service sources do not exist at \"$service_source\""
    test -d "$service_dest" && panic "Service already live at \"$service_dest\""
    cd "$service_source" || exit 1
    test -n "$(git status --porcelain)" && panic "Detected dirty git repository at \"$service_dest\""

    # Pull with git.
    ensure_ssh_deploy_key "$service" "$remote"
    git pull --ff-only > "$OUTPUT" 2>&1 || panic "Cannot pull git repository for service $service"

    # Flavor specific pre-install.
    hook pre_install "$flavor" "$service"

    # Install source files at service destination.
    sudo rm -rf "$service_dest"
    sudo cp -rf "$service_source" "$service_dest"

    # Flavor specific post-install.
    hook post_install "$flavor" "$service"

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

    output_file "Installed service:" "$service_dest"
}

