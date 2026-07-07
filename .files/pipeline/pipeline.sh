#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090
# shellcheck disable=SC1091
#
# Do not complain about unused, unexported variables.
# shellcheck disable=SC2034

set -Eeuo pipefail

# Source environment.
. "$SCRIPT_ROOT/source.sh"

panic_usage() {
    panic "Usage: ppl <clone|service|expose|local|install|publish|uninstall|status> [--remote|--hard] <service>"
}

# Source pipeline tools.
PIPELINE_ROOT="$(dirname "$0")"
for c in "$PIPELINE_ROOT/commands/"*.sh; do . "$c"; done
for h in "$PIPELINE_ROOT/hooks/"*.sh; do . "$h"; done
for t in "$PIPELINE_ROOT/tools/"*.sh; do . "$t"; done

# Traps to clean up and exit gracefully.
trap 'on_err' ERR
trap 'on_int' INT
trap 'on_exit' EXIT

command="$1"
# Safely test that a supported command is passed.
case "${1:-}" in
    clone|service|expose|local|install|publish|uninstall|status) command="$1" ;;
    *) panic_usage ;;
esac
shift

SERVICE="" # name of the service in question.
REMOTE="$DEFAULT_GIT_REMOTE" # the remote service where the repository lives.
NAMESPACE="$DEFAULT_GIT_NAME" # the git namespace to use for git operations.
EXEC_START="" # override service ExecStart.
PUBLIC_DOMAIN="" # set to deploy public site to the internet.
FLAVOR=auto # build flavor, defaults to 'auto' for detection.
PORT=auto # service port, defaults to 'auto' for port-control.
hard=false # hard uninstalls also remove service sources.

# Parse remaining arguments.
while [ $# -gt 0 ]; do
    case "$1" in
        --flavor=*) FLAVOR="${1#*=}" ;;
        --port=*) PORT="${1#*=}" ;;
        --remote=*) REMOTE="${1#*=}" ;;
        --namespace=*) NAMESPACE="${1#*=}" ;;
        --exec=*) EXEC_START="${1#*=}" ;;
        --public-domain=*) PUBLIC_DOMAIN="${1#*=}" ;;
        --hard) hard=true ;;
        -*) panic "Unknown argument: $1" ;;
        # The first arbitrary argument is the service name.
        *) test -n "$SERVICE" && panic_usage || SERVICE="$1" ;;
    esac
    shift
done

# Ensure service is set.
test -z "$SERVICE" && panic_usage

# Detect port.
if [ "$PORT" = auto ]; then
    case "$command" in service|expose|install|publish)
        if [ -n "$PUBLIC_DOMAIN" ]; then
            PORT=$(next_public_port)
        else
            PORT=$(next_private_port)
        fi
        test -z "$PORT" && panic "No port detected or provided for service: $SERVICE"
        print_service "Port detected:" "$PORT"
    esac
fi

# Detect flavor.
if [ "$FLAVOR" = auto ]; then
    case "$command" in service|install|publish)
        FLAVOR="$(detect_flavor)"
        test -z "$FLAVOR" && panic "No build flavor detected or provided for service: $SERVICE"
        print_service "Flavor detected:" "$FLAVOR"
    esac
fi

# Execute command.
case "$command" in
    clone) clone_service ;;

    service)
        service_file
        enable_service
        ;;

    expose) caddy_file ;;

    local)
        service_file
        caddy_file
        enable_service
        ;;

    install)
        install_service
        service_file
        enable_service
        ;;

    publish)
        install_service
        service_file
        caddy_file
        enable_service
        ;;

    uninstall) uninstall_service "$hard" ;;

    status) ;; # Status will always print.

esac

service_status
