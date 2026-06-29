# Caddy log format: https://slatecave.net/notebook/caddy-log-format/
#
# level: log level, set to info for most requests, sometimes error
# ts: Timestamp of thee request, format is configurable
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


select_status_ok='.status < 400' #ok
select_status_not_ok='.status >= 400' #!ok

select_method_get='.request.method == "GET"' # get
select_method_not_get='.request.method != "GET"' # !get

select_duration_slow='.duration >= 1' # slow
select_duration_fast='.duration < 1' # !slow

time_field='(.ts | strftime("%d-%b-%Y %H:%M:%S"))'

fields_request='['"$time_field"', .duration, .status, .request.method, .request.uri]'
fields_identity='['"$time_field"', .request.client_ip, .request.remote_ip]'

log() {
    service="$1"
    log_file="/var/log/caddy/$service.access.jsonl"

    select="$select_status_ok"
    fields="$fields_request"

    jq_filter="select($select) | $fields | @tsv"

    # TODO: --debug to output filter instead of executing it.
    # echo "jq -r $jq_filter"
    sudo jq -r "$jq_filter" "$log_file" | column -t -s $'\t'
}

