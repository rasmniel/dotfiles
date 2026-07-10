# Suppress warning about dynamically sourced files.
# shellcheck disable=SC2034

DEFAULT_PRINT_COLOR=38
PRINT_COLOR_FILE=34
PRINT_COLOR_SERVICE=33
PRINT_COLOR_IDENTITY=32
PRINT_COLOR_FAILURE=31

print_color() {
    local style_code="$1"
    local color_code="$2"
    shift && shift
    printf '\033[%sm%s\033[0m' "$style_code;$color_code" "$*"
}

print_file() {
    local n="$1"; shift; printf "%s\n" "$n $(print_color 03 "$PRINT_COLOR_FILE" "$*")"
}

print_service() {
    local n="$1"; shift; printf "%s\n" "$n $(print_color 01 "$PRINT_COLOR_SERVICE" "$*")"
}

print_identity() {
    local n="$1"; shift; printf "%s\n" "$n $(print_color 04 "$PRINT_COLOR_IDENTITY" "$*")"
}

print_failure() {
    local n="$1"; shift; printf "%s\n" "$n $(print_color 01 "$PRINT_COLOR_FAILURE" "$*")"
}

print_failure_prefix() {
    local n="$1"; shift; printf "%s\n" "$(print_color 01 "$PRINT_COLOR_FAILURE" "$n") $*"
}

panic() {
    print_failure_prefix "PANIC" "$1" >&2
    kill -9 -- -$$ 2>&1 /dev/null
    exit 1
}

print_li() {
    local label="$1"
    local text="$2"
    local color="${3:-}"
    test -z "$color" && color="$DEFAULT_PRINT_COLOR"
    local bullet="${4:-}"
    test -z "$bullet" && bullet="-"
    local width="-${5:-12}"
    label="$(printf "%${width}s" "$label")"
    print_output "$bullet $(print_color 01 "$color" "$label") $text"
}

