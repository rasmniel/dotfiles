git_uri() {
    local actual_remote="$REMOTE"
    test -n "${1:-}" && actual_remote="$1"
    printf "git@%s:%s/%s" "$actual_remote" "$NAMESPACE" "$PROJECT"
}

git_ensure_clean() {
    test -n "$(git status --porcelain)" && panic "Project $PROJECT has uncommitted changes."
    test "$(git rev-list --count "@{u}..HEAD")" -gt 0 && panic "Project $PROJECT has unpushed commits."
    return 0
}

clone_project() {
    mkdir -p "$PROJECT_DIR"
    git clone "$(git_uri "${1:-}")" "$PROJECT_DIR"
}

push_origin() {
    git remote set-url origin "$(git_uri)"
    local main=
    main="$(git remote show origin | grep "HEAD branch:")"
    main="${main#*: }"
    git push -u origin "$main"
}


