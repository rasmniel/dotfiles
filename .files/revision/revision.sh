#!/usr/bin/env bash

set -Eeuo pipefail

. "$SCRIPT_ROOT/source.sh"

work_tree_dir="$1"
name="$(basename "$work_tree_dir")"
branch="${2:-main}"
branch_ref="refs/heads/$branch"
log="$3"
remote="git@$DEFAULT_GIT_REMOTE:$DEFAULT_GIT_NAME/$name.git"

git check-ref-format --branch "$branch_ref" > /dev/null

conflicts="$(find "$work_tree_dir" -name '*sync-conflict-*')"
if [ -n "$conflicts" ]; then
    echo "$conflicts"
    panic "Conflicts detected. Revision aborted."
fi

tmp_dir="$(mktemp -d "/tmp/$name.XXXXXX")"

trap 'rm -rf "$tmp_dir"' EXIT INT TERM

git_dir="$tmp_dir/$name.git"

bare_git() {
    git --git-dir="$git_dir" "$@"
}

work_tree() {
    bare_git --work-tree="$work_tree_dir" "$@"
}

git init --bare "$git_dir" >/dev/null
bare_git remote add origin "$remote"
bare_git fetch origin "$branch" >/dev/null
work_tree add --all

tree="$(work_tree write-tree)"
parent="$(bare_git rev-parse FETCH_HEAD)"
message="$(printf '%s, revision: %s' "$name" "$(date -u "+%Y-%m-%d %H:%M:%S")")"
commit="$(printf '%s\n' "$message" | work_tree commit-tree "$tree" -p "$parent")"

bare_git push --force-with-lease="$branch_ref:$parent" origin "$commit:$branch_ref"

if [ -n "$log" ]; then
    test -f "$log" || touch "$log"
    echo "$message" >> "$log"
    echo "$commit" >> "$log"
fi

