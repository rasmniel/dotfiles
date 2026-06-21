panic() {
  output_failure "PANIC" "$1" >&2
  printf "\n"
  exit 1
}

panic_usage() {
  panic "Usage: ppl <clone|service|proxy|install|publish|uninstall> [--public|--hard|<--verbose|--silent>] <project>"
}
