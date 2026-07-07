# Global process ID for storing the process that is currently loading.
LOADING_PID=""
# Kill the loading process ID, if this process exits unexpectedly.
trap 'test -n "$LOADING_PID" && kill "$LOADING_PID" 2>/dev/null' EXIT INT TERM

declare symbols=('$' '#' '*' '@' '&')

__random_symbol() {
    local n="${#symbols[@]}"
    local random=$((RANDOM % n))
    printf "%s" "${symbols[$random]}"
}

__frame() {
    local i="$1"
    local s=$((i + 1))
    local c="$2"
    local l="        "
    local n="${#l}"
    local state="${l:0:i}$c${l:s:n}"
    printf "\r[%s]" "$state" >&2; sleep 0.08
}

loading() {
    # Store global pid for loading state in order to kill lingering loading states on ctrl-c.
    LOADING_PID=$!
    local label="$1"
    # Lead with a new-line.
    local i=0
    local n="${#label}"
    local c
    test -z "$label" && c=$(__random_symbol)
    while kill -0 "$LOADING_PID" 2>/dev/null; do
        test -n "$label" && c="${label:i:1}"
        __frame 0 "$c"
        __frame 1 "$c"
        __frame 2 "$c"
        __frame 3 "$c"
        __frame 4 "$c"
        __frame 5 "$c"
        __frame 6 "$c"
        i=$(((i + 1) % n))
        test -n "$label" && c="${label:i:1}"
        __frame 7 "$c"
        __frame 6 "$c"
        __frame 5 "$c"
        __frame 4 "$c"
        __frame 3 "$c"
        __frame 2 "$c"
        __frame 1 "$c"
        i=$(((i + 1) % n))
    done
    printf "\r          \r" >&2
    # Propagate exit code.
    wait "$LOADING_PID" || panic "Background process failed."
}

