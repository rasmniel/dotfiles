#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1090

set -Eeuo pipefail
trap 'printf "\n%s\n -> %s\n" "Internal pipeline failure @ $BASH_SOURCE:$LINENO" "$BASH_COMMAND"' ERR
trap 'printf "\n%s\n" "Pipeline was interrupted."; exit 1' INT

# Source pipeline tools.
DEPLOY_ROOT="$(dirname "$0")"
if [ ! -f "$DEPLOY_ROOT/.env" ]; then
  echo "Deployment environment missing at \"$DEPLOY_ROOT/.env\""
  exit 1
fi
source "$DEPLOY_ROOT/.env"
for c in "$DEPLOY_ROOT/commands/"*; do source "$c"; done
for h in "$DEPLOY_ROOT/hooks/"*; do source "$h"; done
for t in "$DEPLOY_ROOT/tools/"*; do source "$t"; done

# Debugging config.
export VERBOSE=
export SILENT=
export OUTPUT=/dev/null

command="$1" # provided pipeline command.
project= # name of the project in question.
domain="$PRIVATE_DOMAIN" # domain for the host.
flavor=auto # build flavor, defaults to 'auto' for detection.
port=auto # service port, defaults to 'auto' for port-control.
public=
hard= # hard uninstalls also remove service sources.

# Ensure command argument.
case "$command" in
  clone|service|proxy|install|publish|uninstall) ;;
  *) panic_usage "$@" ;;
esac
shift

# Parse remaining arguments.
while [ $# -gt 0 ]; do
  case "$1" in

    --flavor=*) flavor="${1##*=}" ;;

    --port=*) port="${1##*=}" ;;

    --public) public=true ;;

    --hard)
      if [ "$command" = uninstall ]; then
        hard=true
      else
        panic "Only uninstall supports --hard flag."
      fi
      ;;

    --verbose|-v)
      [ "$SILENT" ] && panic_usage
      VERBOSE=true
      OUTPUT=/dev/stdout
      ;;

    --silent|-s)
      [ "$VERBOSE" ] && panic_usage
      SILENT=true
      OUTPUT=/dev/null
      ;;

    -*) panic "Unknown argument: $1" ;;

    *)
      # Treat the first arbitrary argument as the project name.
      if [ -z "$project" ]; then
        project="$1"
      else
        panic_usage
      fi
      ;;

  esac
  shift
done

# Ensure runtime variables.
test -z "$project" && panic_usage

[ "$public" ] && domain="$PUBLIC_DOMAIN"

# Detect port.
if [ "$port" = "auto" ]; then
  case "$command" in
    service|proxy|install|publish)
      if [ "$public" ]; then
        port=$(next_public_port)
      else
        port=$(next_private_port)
      fi
      test -z "$port" && panic "No port detected or provided for project: $project"
      output_service "Port detected:" "$port"
  esac
fi

# Detect flavor.
if [ "$flavor" = "auto" ]; then
  case "$command" in
    service|install|publish)
      flavor="$(detect_flavor "$project")"
      test -z "$flavor" && panic "No build flavor detected or provided for project: $project"
      output_service "Flavor detected:" "$flavor"
  esac
fi

# Execute command.
case "$command" in
  clone)
    clone_project "$project"
    ;;

  service)
    service_file "$project" "$port" "$flavor"
    ;;

  proxy)
    caddy_file "$project" "$domain" "$port"
    ;;

  install)
    install_service "$project" "$flavor"
    service_file "$project" "$port" "$flavor"
    enable_service "$project"
    ;;

  publish)
    install_service "$project" "$flavor"
    service_file "$project" "$port" "$flavor"
    caddy_file "$project" "$domain" "$port"
    enable_service "$project"
    ;;

  uninstall)
    uninstall_service "$project" "$hard"
    ;;

  *) panic_usage ;;
esac

printf "\n"

