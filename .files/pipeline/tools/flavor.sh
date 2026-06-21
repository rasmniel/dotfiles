detect_flavor() {
  local project="$1"
  local service_source="$SOURCE_ROOT/$project"

  test ! -d "$service_source" && panic "Service sources do not exist at \"$service_source\""
  cd "$service_source" || exit 1

  test -f package.json && printf "node" && return

  printf "none"
}
