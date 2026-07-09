if [ ! -f "$SCRIPT_ROOT/.env" ]; then
    printf 'Environment missing at "%s/.env"' "$SCRIPT_ROOT"
    exit 1
fi

. "$SCRIPT_ROOT/.env"

