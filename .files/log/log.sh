#! /usr/env/bin bash

set -Eeuo pipefail

. "$SCRIPT_ROOT/source.sh"

# Caddy log format: https://slatecave.net/notebook/caddy-log-format/
#
# level: log level, set to info for most requests, sometimes error
# ts: Timestamp of the request, format is configurable
# logger: An identifier for the logger inside caddy that produced the line
# msg: Always set to handled request
# request:
#     remote_ip: IP that the request came from
#     remote_port: Port number that the request came from (as string)
#     client_ip: IP that caddy believes is the actual client
#     proto: HTTP protocol i.e. HTTP/1.1, HTTP/2.0, HTTP/3.0, …
#     method: The http method used for the request i.e. GET, OPTIONS, POST, PUT, DELETE, …
#     host: The host the request was targeted at (i.e. example.org)
#     uri: Absolue path and query of the URI that was requested i.e. /, /icon.png, /search/?q=foo, …
#     headers: An object describing the request headers
#     tls:
#         resumed: nullable boolean, weather a previous tls connection was resumed
#         version: nullable integer, the legacy version field of the TLS-record (substract 768 to get the minor version)
#         cipher_suite: nullable integer, somehow encodes the used TLS cipher suite
#         proto: nullable string, empty, null or http/1.1 for HTTP/1.*, h2 for HTTP/2.0 and h3 for HTTP/3.0
#         server_name nullable string, the name given via SNI
# bytes_read: integer, How many request body bytes were read
# user_id: string, usually empty
# duration: float, How long the request took in seconds
# size: integer: Reply size in bytes
# status: integer: HTTP status code, status code 0 means that the connection was closed before a reply could be sent
# resp_headers: Object describing the response headers


time_field='(.ts | strftime("%d-%b-%Y %H:%M:%S"))'
fields_request='['"$time_field"', .request.remote_ip, .duration, .status, .request.proto, .request.method, .request.uri]'
fields_identity='['"$time_field"', .request.client_ip, .request.remote_ip]'

test -z "${1:-}" && panic "No service argument provided."

SERVICE="$1"; shift
SELECT=""
follow=false

append_select() {
    test "${2:-}" = "not" && not=" | not" || not=
    test -n "$SELECT" && and=" and " || and=
    SELECT="$SELECT$(printf '%s((%s)%s)' "$and" "$1" "$not")"
}

while [ $# -gt 0 ]; do
    case "$1" in
        +ok|ok) append_select '.status < 400';;
        -ok) append_select '.status >= 400';;

        +get|get) append_select '.request.method == "GET"';;
        -get) append_select '.request.method != "GET"';;

        +slow|slow) append_select '.duration >= 1';;
        -slow) append_select '.duration < 1';;

        +ip=*|ip=*) append_select "$(printf '.request.remote_ip == "%s"' "${1#*=}")" ;;
        -ip=*) append_select "$(printf '.request.remote_ip != "%s"' "${1#*=}")" ;;

        -known|known|+known)
            test "${1:0:1}" = "-" && not="not" || not=
            append_select ".request.remote_ip | IN($KNOWN_IPS)" "$not"
            ;;

        --follow|-f) follow=true ;;

        +*|-*) panic "Unknown argument: $1" ;;

        *) test -n "$SERVICE" && panic "Unknown argument: $1" || SERVICE="$1" ;;
    esac
    shift
done

# TODO: Support setting field request type.
fields="$fields_request"
jq_filter="select($SELECT) | $fields | @tsv"
log_file="/var/log/caddy/$SERVICE.access.jsonl"

if [ "$follow" = true ]; then
    sudo tail -n 100 -f "$log_file" | jq --unbuffered -r "$jq_filter"
else
    # TODO: Reconsider `column`
    sudo tail -n 100 "$log_file" | jq -r "$jq_filter" # | column -t -s $'\t'
fi

