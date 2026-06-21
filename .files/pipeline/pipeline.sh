#!/usr/bin/env bash

# Do not warn about dynamically sourced files.
# shellcheck disable=SC1090

set -Eeuo pipefail
trap 'echo "Internal deployment pipeline failure: line $LINENO, cmd \"$BASH_COMMAND\""' ERR

# Source pipeline tools.
DEPLOY_ROOT="$(dirname "$0")"
if [ ! -f "$DEPLOY_ROOT/.env" ]; then
  echo "Deployment environment missing at \"$DEPLOY_ROOT/.env\""
  exit 1
fi

source "$DEPLOY_ROOT/.env"
for c in "$DEPLOY_ROOT/commands/"*; do source "$c"; done
for f in "$DEPLOY_ROOT/flavors/"*; do source "$f"; done
for t in "$DEPLOY_ROOT/tools/"*; do source "$t"; done

command="$1" # provided pipeline command.
project= # name of the project to create as a service.
# TODO: Implement auto flavor.
flavor=node # build flavor, defaults to 'auto' for detection.
#TODO: Implement port-control, so port is always optional.
port=3000 # port should always be passed. 
hard= # hard uninstalls also remove service sources.

case "$command" in
  clone|service|install|publish|uninstall) ;;
  *) panic_usage ;;
esac
shift

while [ $# -gt 0 ]; do
  case "$1" in

    --flavor=*) flavor="${1##*=}" ;;

    --port=*) port="${1##*=}" ;;

    --hard)
      if [ "$command" = uninstall ]; then
        hard=true
      else
        panic "Only uninstall supports --hard flag."
      fi
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

# Execute command
case "$command" in
  clone)
    clone_project "$project"
    ;;

  service)
    service_file "$project" "$flavor"
    ;;

  install)
    install_service "$project" "$flavor"
    service_file "$project" "$flavor"
    ;;

  publish)
    install_service "$project" "$flavor"
    service_file "$project" "$flavor"
    caddy_file "$project" "$port"
    ;;

  uninstall)
    uninstall_service "$project" "$hard"
    ;;

  *) panic_usage ;;
esac

