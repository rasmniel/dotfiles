hook() {
  local step="$1"
  local flavor="$2"
  local service="$3"
  shift && shift && shift

  local fn="${step}__$flavor"
  if declare -f "$fn" > /dev/null; then
    "$fn" "$service" "$@"
  fi
}

