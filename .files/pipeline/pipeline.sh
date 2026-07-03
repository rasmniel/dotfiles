#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090
# shellcheck disable=SC1091
#
# Do not complain about unused, unexported variables.
# shellcheck disable=SC2034

set -Eeuo pipefail

# Debugging config.
VERBOSE=false
SILENT=false
OUTPUT=/dev/null

# Source environment.
. "$SCRIPT_ROOT/source.sh"

panic_usage() {
    panic "Usage: ppl <clone|service|proxy|install|publish|uninstall> [--public|--remote|--hard|<--verbose|--silent>] <service>"
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

# Safely test that a command is passed at all.
test -z "${1:-}" && panic_usage

command="$1" # provided pipeline command.
SERVICE="" # name of the service in question.
EXEC_START="" # override service ExecStart.
REMOTE="$DEFAULT_GIT_REMOTE" # the remote service where the repository lives.
NAMESPACE="$DEFAULT_GIT_NAMESPACE" # the git namespace to use for git operations.
DOMAIN="$PRIVATE_DOMAIN" # domain for the host.
FLAVOR=auto # build flavor, defaults to 'auto' for detection.
PORT=auto # service port, defaults to 'auto' for port-control.
public=false # flag for deploying public sites to the internet.
hard=false # hard uninstalls also remove service sources.

# TODO: Consider adding more top level derivatives such as $SERVICE_FILE and $CADDY_FILE

# Ensure command argument.
case "$command" in
    clone|service|proxy|local|install|publish|uninstall) ;;
    *) panic_usage ;;
esac
shift

# Parse remaining arguments.
while [ $# -gt 0 ]; do
    case "$1" in
        --flavor=*) FLAVOR="${1#*=}" ;;
        --port=*) PORT="${1#*=}" ;;
        --remote=*) REMOTE="${1#*=}" ;;
        --exec=*) EXEC_START="${1#*=}" ;;

        --public)
            public=true
            DOMAIN="$PUBLIC_DOMAIN"
            ;;

        --hard) hard=true ;;

        --verbose|-v)
            test "$SILENT" = true && panic_usage
            VERBOSE=true
            OUTPUT=/dev/stdout
            ;;

        --silent|-s)
            test "$VERBOSE" = true && panic_usage
            SILENT=true
            OUTPUT=/dev/null
            ;;

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
    case "$command" in service|proxy|install|publish)
        if [ "$public" = true ]; then
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
        FLAVOR="$(detect_flavor "$SERVICE")"
        test -z "$FLAVOR" && panic "No build flavor detected or provided for service: $SERVICE"
        print_service "Flavor detected:" "$FLAVOR"
    esac
fi

# Execute command.
case "$command" in
    clone) clone_service ;;

    service) service_file ;;

    proxy) caddy_file ;;

    local)
        local_service_file
        local_caddy_file
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

    # TODO: state output checking if caddy file exists, service file exists, etc. and outputs a colored list of data.
esac

