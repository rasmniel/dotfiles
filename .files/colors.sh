# vim: set ft=sh

# Terminal codes are documented here `man 4 console_codes`

function __color() {
    local style_code="$1"
    local color_code="$2"
    ## Shift twice, removing both codes for style and color.
    shift && shift
    printf '\033[%sm%s\033[0m' "$style_code;$color_code" "$*"
}

declare -A colors
colors[black]=30
colors[red]=31
colors[green]=32
colors[brown]=33
colors[blue]=34
colors[magenta]=35
colors[cyan]=36
colors[white]=37

alias __normal='__color 0'
alias __bold='__color 01'
alias __italic='__color 03'
alias __dim='__color 02'
alias __under='__color 04'
alias __blink='__color 05'
alias __reverse='__color 07'

# shellcheck disable=SC2139
# NOTE: ShellCheck correctly detects unexpected escape order, which is intended for constructing dynamic aliases.
for color in "${!colors[@]}"; do
    alias "__$color=__normal ${colors[$color]}"
    alias "__bold_$color=__bold ${colors[$color]}"
    alias "__italic_$color=__italic ${colors[$color]}"
    alias "__dim_$color=__dim ${colors[$color]}"
    alias "__under_$color=__under ${colors[$color]}"
    alias "__blink_$color=__blink ${colors[$color]}"
    alias "__reverse_$color=__reverse ${colors[$color]}"
done

alias __colors='alias | grep -Ei --color=none "^alias __[a-z_]+=.__[a-z_]+"'
