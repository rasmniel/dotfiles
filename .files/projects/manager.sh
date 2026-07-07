#! /usr/env/bin bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1091

set -Eeuo pipefail

. "$SCRIPT_ROOT/source.sh"
. "$(dirname "$0")/git.sh"

test -z "${1:-}" && panic "No command provided."

COMMAND="$1" # command to run.
PROJECT="" # project to manage.
REMOTE="$DEFAULT_GIT_REMOTE" # git remote to clone from.
NAMESPACE="$DEFAULT_GIT_NAMESPACE" # git user to clone with.
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
        --remote=*) REMOTE="${1#*=}" ;;
        --user=*) NAMESPACE="${1#*=}" ;;
        --from=*) from="${1#*=}" ;;
        --really) really=true ;;
        -*) panic "Unknown argument: $1" ;;
        *) test -n "$PROJECT" && panic "Unknown argument: $1" || PROJECT="$1" ;;
    esac
    shift
done

test -z "$PROJECT" && panic "No project provided."

PROJECT_DIR="$PROJECT_ROOT/$PROJECT"

cd_project() {
    cd "$PROJECT_DIR" || panic "Project $PROJECT does not exist"
}

ensure_intent() {
    test "$really" = true || panic 'Run with "--really" if you really mean it.'
}

# Execute command.
case "$COMMAND" in

    clone)
        clone_project
        cd_project
        ;;

    migrate)
        test -d "$PROJECT_DIR" || clone_project "$from"
        cd_project
        push_origin
        ;;

    remove)
        cd_project
        git_ensure_clean
        ensure_intent
        rm -rf "$PROJECT_DIR" ;;
esac

