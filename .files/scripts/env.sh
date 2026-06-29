test -f "$SCRIPT_ROOT/.env" || panic "Environment missing at \"$SCRIPT_ROOT/.env\""
# shellcheck disable=SC1091
. "$SCRIPT_ROOT/.env"
