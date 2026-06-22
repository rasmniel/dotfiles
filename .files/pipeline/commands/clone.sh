clone_service() {
  local service="$1"
  local remote="$2"
  local user="$DEFAULT_GIT_USER"

  case "$service" in
    *[!A-Za-z0-9._-]*|"") panic "Invalid service name: \"$service\"" ;;
  esac

  cd "$SOURCE_ROOT" || panic "No source root."

  test -d "./$service" && panic "Service \"$service\" already exists."

  # Setup deploy key to authenticate with remote.
  deploy_key_file="$(get_deploy_key_file "$service" "$remote")"
  validate_or_generate_deploy_key "$deploy_key_file"
  export_git_ssh_command "$deploy_key_file"

  local repo="git@$remote:$user/$service.git"
  git clone "$repo" > "$OUTPUT" 2>&1 || panic "Cannot clone repository \"$repo\""

  output_service "Cloned $remote repository:" "$service"
}

