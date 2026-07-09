#!/usr/bin/env bash

# Suppress warning about dynamically sourced files.
# shellcheck disable=SC1091

set -Eeuo pipefail

. "$SCRIPT_ROOT/source.sh"

work_tree_dir="$1"
name="$(basename "$work_tree_dir")"
branch="${2:-main}"
branch_ref="refs/heads/$branch"
log="${3:-}"
remote="git@$DEFAULT_GIT_REMOTE:$DEFAULT_GIT_NAME/$name.git"

git check-ref-format --branch "$branch_ref" > /dev/null

conflicts="$(find "$work_tree_dir" -name '*sync-conflict-*')"
if [ -n "$conflicts" ]; then
    echo "$conflicts"
    panic "Conflicts detected. Revision aborted."
fi

tmp_dir="$(mktemp -d "/tmp/$name.XXXXXX")"
git_dir="$tmp_dir/$name.git"

trap 'rm -rf "$tmp_dir"' EXIT INT TERM

bare_git() {
    git --git-dir="$git_dir" "$@"
}
work_tree() {
    bare_git --work-tree="$work_tree_dir" "$@"
}

# Initialize bare repository and fetch HEAD from remote.
git init --bare "$git_dir" >/dev/null
bare_git remote add origin "$remote"
bare_git fetch origin "$branch" >/dev/null
parent="$(bare_git rev-parse FETCH_HEAD)"

# Write and commit work-tree.
work_tree add --all
tree="$(work_tree write-tree)"
message="$(printf '%s, revision: %s' "$name" "$(date -u "+%Y-%m-%d %H:%M:%S")")"
commit="$(printf '%s\n' "$message" | work_tree commit-tree "$tree" -p "$parent")"

# Push to the remote if the current branch matches the remote HEAD.
bare_git push --force-with-lease="$branch_ref:$parent" origin "$commit:$branch_ref"

# Output log of the revision at the provided destination.
if [ -n "$log" ]; then
    mkdir -p "$(dirname "$log")"
    {
        echo "$message"
        echo "$commit"
        echo ""
    } >> "$log"
fi

