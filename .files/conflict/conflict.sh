destination=$1
target=$2

test -d "$destination" || exit 1

find "$destination" -name '*.sync-conflict*' -type f | {
    conflict="$1"
    ((i=1))
    while IFS= read -r conflict; do
        title=${conflict/$destination/...}
        file="${conflict%%.sync-conflict*}.${conflict##*.}"

        if [[ -z "$target" ]]; then
            echo "$i) $title";
        elif [[ "$target" = "$i" ]]; then
            diff -y --width=180 --color=auto "$file" "$conflict"
        fi

        ((i=i+1))
    done

    if [[ "$i" -eq 1 ]]; then
        echo "No conflicts detected in ${destination/$HOME/"~"}"
    fi
}
