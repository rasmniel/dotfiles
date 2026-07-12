# Top level script arguments, captured as soon as possible.
SCRIPT_ARGS=("$@")

declare -A SUPPORTED_COMMANDS=(
    ["clone"]="Clone a service to the service directory
                --remote - the remote to clone from
                --namespace - the remote namespace clone from
    "
    ["service"]="Create a service file for a service
                --public-domain - if set, will result in a public service host
                --port - port for the service to listen at
                --flavor - runtime flavor of the service
                --exec - service file ExecStart override
    "
    ["caddy"]="Create a caddy file for a service
                --public-domain - public domain to point at, including logging if set
                --port - port to reverse proxy to
    "
    ["local"]="Enable an existing service with service file and caddy file
                (service, caddy)
    "
    ["install"]="Install a fresh service from the service directory with a service file
                (service)
                --remote - remote to authenticate with and pull from
                --flavor - build flavor of the service
    "
    ["publish"]="Install and publish a fresh service from the service directory with a service file and a caddy file.
                (service, caddy, install)
    "
    ["update"]="Update an existing service installation
                (install)
    "
    ["uninstall"]="Uninstall all aspects of an installed service
                --hard - also uninstall service sources
    "
    ["list"]="List all services with any installed aspect
                (no service argument required)
    "
    ["status"]="Just print the status of a service
    "
)

declare -a COMMAND_ORDER=(
    "clone"
    "service"
    "caddy"
    "local"
    "install"
    "publish"
    "update"
    "uninstall"
    "list"
    "status"
)

declare -A FLAVOR_USAGE=(
    ["auto"]="Detect runtime flavor
    "
    ["node"]="Node js runtime. Requires:
                package.main
                support --port
    "
)

declare -a FLAVOR_ORDER=("auto" "node")

echo_header() {
    echo
    echo "$@"
    echo
}

panic_usage() {
    local script_command="${SCRIPT_ARGS[0]:-}"
    echo
    print_li "Usage:" "ppl <command> <service> [--args]" "*"
    echo_header "Both command and service are required"
    for command in "${COMMAND_ORDER[@]}"; do
        test "$script_command" == "$command" && color="$PRINT_COLOR_FAILURE" || color=
        print_li "$command" "${SUPPORTED_COMMANDS["$command"]}" " " "$color"
    done
    case "$script_command" in service|install|publish|update)
        echo_header "Flavor usage:"
        for flavor in "${FLAVOR_ORDER[@]}"; do
            test "${FLAVOR:-}" == "$flavor" && [ "$flavor" != auto ] && color="$PRINT_COLOR_FAILURE" || color=
            print_li "$flavor" "${FLAVOR_USAGE["$flavor"]}" " " "$color"
        done
    esac

    test "${#SCRIPT_ARGS[@]}" -eq 0 || panic "Incorrect usage 'ppl ${SCRIPT_ARGS[*]}'" && exit 1
}
