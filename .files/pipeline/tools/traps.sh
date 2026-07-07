declare loading_pid=""

# Log general errors.
on_err() {
    printf "\n%s\n -> %s\n" "Internal pipeline failure @ ${BASH_SOURCE[1]}:$LINENO" "$BASH_COMMAND"
}

# Cleanup and exit gracefully after ctrl-c.
on_int() {
    # Avoid ERR trap printing lingering errors.
    trap - ERR
    printf "%s\n" "$(print_failure_prefix "INT" "Pipeline was interrupted")"
    kill "$loading_pid" 2>/dev/null || true
    exit 130
}

# Cleanup any orphaned processed after unexpected exits.
on_exit() {
    code="$?"
    if [ $code -ne 0 ]; then
        kill "$(jobs -p)" 2>/dev/null || true
    fi
    exit $code
}

