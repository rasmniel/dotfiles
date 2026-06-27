#! /usr/env/bin bash

set -Eeuo pipefail

panic() {
    printf "%s\n" "$*"
    exit 1
}

DIRNAME="$(dirname "$0")"
test -f "$DIRNAME/.env" || panic "Project management environment missing at \"$DIRNAME/.env\""
. "$DIRNAME/.env"
. "$DIRNAME/git.sh"

test -z "${1:-}" && panic "No command provided."

COMMAND="$1" # command to run.
PROJECT="" # project to manage.
REMOTE="$DEFAULT_GIT_REMOTE" # git remote to clone from.
USER="$DEFAULT_GIT_USER" # git user to clone with.
from="" # remote to migrate from.
really=false # required for uninstalls.

# Ensure command argument.
case "$COMMAND" in
    clone|migrate|remove) ;;
    *) panic "Usage: pm <clone|remove> <project>" ;;
esac
shift

while [ $# -gt 0 ]; do
    case "$1" in
        --remote=*) REMOTE="${1##*=}" ;;
        --user=*) USER="${1##*=}" ;;
        --from=*) from="${1##*=}" ;;
        --really) really=true ;;
        -*) panic "Unknown argument: $1" ;;
        *) test -n "$PROJECT" && panic "Unknown argument: $1" || PROJECT="$1" ;;
    esac
    shift
done

test -z "$PROJECT" && panic "No project provided."

PROJECT_DIR="$PROJECTS_ROOT/$PROJECT"

# Execute command.
case "$COMMAND" in
    clone) clone_project ;;

    migrate)
        test -d "$PROJECT_DIR" || clone_project "$from"
        push_origin
        ;;

    remove)
        test "$really" = true || panic "Run with --really to really remove the project."
        rm -rf "$PROJECT_DIR" ;;
esac


