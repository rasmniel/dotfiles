panic() {
    output_failure "PANIC" "$1" >&2
    exit 1
}

panic_usage() {
    panic "Usage: ppl <clone|service|proxy|install|publish|uninstall> [--public|--remote|--hard|<--verbose|--silent>] <service>"
}
