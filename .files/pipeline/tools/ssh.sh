validate_or_generate_deploy_key() {
    local deploy_key_file="$1"
    if [ ! -f "$deploy_key_file" ]; then
        ssh-keygen -t ed25519 -f "$deploy_key_file" -N "" > /dev/null
        output_file "Generated SSH deploy key file:" "$deploy_key_file"
        echo
        cat "$deploy_key_file.pub"
        echo
        read -r -p "Press Enter when this key has been setup as deploy key." _
    fi
}

get_deploy_key_file() {
    local service="$1"
    local remote="$2"

    # Always use the "main" project for gitlab.com, which supports a single deploy key for all projects.
    local key_file_name="$service"
    test "$remote" = "gitlab.com" && key_file_name="main"

    local key_file_dir="$SSH_KEY_FILE_DIR/$remote"
    mkdir -p "$key_file_dir"
    local deploy_key_file="$key_file_dir/$key_file_name"

    printf "%s" "$deploy_key_file"
}

export_git_ssh_command() {
    local deploy_key_file="$1"
    export GIT_SSH_COMMAND="ssh \
        -i $deploy_key_file \
        -o IdentitiesOnly=yes \
        -o IdentityAgent=none \
        -o ForwardAgent=no \
        -o BatchMode=yes \
        -o ConnectTimeout=10 \
        -o StrictHostKeyChecking=accept-new \
        -F /dev/null"
}
