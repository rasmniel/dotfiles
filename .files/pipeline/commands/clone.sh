# TODO: Move these to .env
DEFAULT_GIT_USER="user"
SSH_KEY_FILE_DIR="deploy_key"
DEFAULT_GIT_REMOTE="git.com"

# Assign a script variable to avoid mixing key file path and generated deploy keys into stdout.
deploy_key_file=""

__set_deploy_key_file() {
  local key_file_name="$1"
  local remote="$2"
  local key_file_dir="$HOME/.ssh/$SSH_KEY_FILE_DIR/$remote"
  mkdir -p "$key_file_dir"

  # Set deploy key file.
  deploy_key_file="$key_file_dir/$key_file_name"

  # If the key does not exist, generate it.
  if [ ! -f "$deploy_key_file" ]; then
    ssh-keygen -t ed25519 -f "$deploy_key_file" -N ""
    output_file "Generated SSH deploy key file for $remote:" "$deploy_key_file"
    cat "$deploy_key_file.pub"
    echo
    read -r -p "Press Enter when this key has been setup as deploy key in $remote " _
  fi
}

clone_project() {
  local project="$1"
  local remote="${2}"
  test -z "$remote" && remote="$DEFAULT_GIT_REMOTE"
  # Always use the "main" project for gitlab.com, which supports a single deploy key for all projects.
  test "$remote" = "gitlab.com" && project="main"

  case "$project" in
    *[!A-Za-z0-9._-]*|"") panic "Invalid project name: \"$project\"" ;;
  esac

  cd "$SOURCE_ROOT" || panic "No source root."

  __set_deploy_key_file  "$project" "$remote"
  local user="$DEFAULT_GIT_USER"

  export GIT_SSH_COMMAND="ssh \
    -i $deploy_key_file \
    -o IdentitiesOnly=yes \
    -o IdentityAgent=none \
    -o ForwardAgent=no \
    -o BatchMode=yes \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=accept-new \
    -F /dev/null"

  git clone "git@$remote:$user/$project.git"
}

