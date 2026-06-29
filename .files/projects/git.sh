git_uri() {
    local actual_remote="$REMOTE"
    test -n "${1:-}" && actual_remote="$1"
    printf "git@%s:%s/%s" "$actual_remote" "$NAMESPACE" "$PROJECT"
}

clone_project() {
    mkdir -p "$PROJECT_DIR"
    git clone "$(git_uri "${1:-}")" "$PROJECT_DIR"
}

push_origin() {
    cd "$PROJECT_DIR" || panic "Project $PROJECT does not exist"
    git remote set-url origin "$(git_uri)"

    local main=
    main="$(git remote show origin | grep "HEAD branch:")"
    main="${main##*: }"
    git push -u origin "$main"
}


