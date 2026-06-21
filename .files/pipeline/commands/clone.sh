clone_project() {
  local service="$1"

  cd "$SOURCE_ROOT" || exit 1

  # TODO: Better git url abstraction
  # Try both remotes and use the one the works.
  # Consider prefering one over the other between github and gitlab
  git clone "git@github.com:rasmniel/$service.git"
}

