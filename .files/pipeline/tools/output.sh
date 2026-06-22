__color() {
    local style_code="$1"
    local color_code="$2"
    shift && shift
    printf '\033[%sm%s\033[0m' "$style_code;$color_code" "$*"
}

output() {
    test "$SILENT" = false || return 0
    printf "\n%s\n" "$*"
}

output_service() {
    local n=$1; shift; output "$n $(__color 01 33 "$*")"
}

output_file() {
    local n=$1; shift; output "$n $(__color 03 34 "$*")"
}

output_identity() {
    local n=$1; shift; output "$n $(__color 04 32 "$*")"
}

output_failure() {
    local n=$1; shift; output "$(__color 01 31 "$n") $*"
}

