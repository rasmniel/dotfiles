#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090

set -Eeuo pipefail

# Debugging config.
export VERBOSE=false
export SILENT=false
export OUTPUT=/dev/null

# Source pipeline tools and environment.
DEPLOY_ROOT="$(dirname "$0")"
for c in "$DEPLOY_ROOT/commands/"*; do . "$c"; done
for h in "$DEPLOY_ROOT/hooks/"*; do . "$h"; done
for t in "$DEPLOY_ROOT/tools/"*; do . "$t"; done
test -f "$DEPLOY_ROOT/.env" || panic "Deployment environment missing at \"$DEPLOY_ROOT/.env\""
. "$DEPLOY_ROOT/.env"

# Traps to clean up and exit gracefully.
trap 'on_err' ERR
trap 'on_int' INT
trap 'on_exit' EXIT

# Safely test that a command is passed at all.
test -z "${1:-}" && panic_usage

command="$1" # provided pipeline command.
service="" # name of the service in question.
remote="" # the remote service where the repository lives.
domain="$PRIVATE_DOMAIN" # domain for the host.
flavor=auto # build flavor, defaults to 'auto' for detection.
port=auto # service port, defaults to 'auto' for port-control.
public=false # flag for deploying public sites to the internet.
hard=false # hard uninstalls also remove service sources.

# Ensure command argument.
case "$command" in
    clone|service|proxy|install|publish|uninstall) ;;
    *) panic_usage "$@" ;;
esac
shift

# Parse remaining arguments.
while [ $# -gt 0 ]; do
    case "$1" in

        # Override build flavor.
        --flavor=*) flavor="${1##*=}" ;;

        # Override host port.
        --port=*) port="${1##*=}" ;;

        # Set git remote.
        --remote=*) remote="${1##*=}" ;;

        # For hosting on public domain.
        --public) public=true ;;

        # For hard uninstalls.
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
        *)
            if [ -z "$service" ]; then
                service="$1"
            else
                panic_usage
            fi
            ;;

    esac
    shift
done

# Ensure service is set.
test -z "$service" && panic_usage

# Ensure domain is set for caddy.
case "$command" in proxy)
    test "$public" = true && domain="$PUBLIC_DOMAIN"
esac

# Set correct remote for git operations.
case "$command" in clone|install|publish)
    test -z "$remote" && remote="$DEFAULT_GIT_REMOTE"
esac

# Detect port.
if [ "$port" = auto ]; then
    case "$command" in service|proxy|install|publish)
        if [ "$public" = true ]; then
            port=$(next_public_port)
        else
            port=$(next_private_port)
        fi
        test -z "$port" && panic "No port detected or provided for service: $service"
        output_service "Port detected:" "$port"
    esac
fi

# Detect flavor.
if [ "$flavor" = auto ]; then
    case "$command" in service|install|publish)
        flavor="$(detect_flavor "$service")"
        test -z "$flavor" && panic "No build flavor detected or provided for service: $service"
        output_service "Flavor detected:" "$flavor"
    esac
fi

# Execute command.
case "$command" in
    clone)
        clone_service "$service" "$remote"
        ;;

    service)
        service_file "$service" "$port" "$flavor"
        ;;

    proxy)
        caddy_file "$service" "$domain" "$port"
        ;;

    install)
        install_service "$service" "$remote" "$flavor"
        service_file "$service" "$port" "$flavor"
        enable_service "$service"
        ;;

    publish)
        install_service "$service" "$remote" "$flavor"
        service_file "$service" "$port" "$flavor"
        caddy_file "$service" "$domain" "$port"
        enable_service "$service"
        ;;

    uninstall)
        uninstall_service "$service" "$hard"
        ;;

    *) panic_usage ;;
esac

# If the script finishes, exit 0 to ensure no lingering errors.
exit 0
