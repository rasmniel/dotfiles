#!/bin/sh

output() {
    label="$1"
    shift
    printf '%-12s%s\n' "$label" "$@"
}

# Hostname and IP
host="$(hostname)"
ip="$(hostname -I | cut -d' ' -f1)"

# Memory usage
mem="$(free -h | grep Mem: | tr -s ' ')"
mem_total="$(echo "$mem" | cut -d' ' -f2)"
mem_used="$(echo "$mem" | cut -d' ' -f3)"
mem_avail="$(echo "$mem" | cut -d' ' -f7)"

# Disk space
disk="$(df -h | grep -E /$ | tr -s ' ')"
disk_total="$(echo "$disk" | cut -d' ' -f2)"
disk_used="$(echo "$disk" | cut -d' ' -f3)"
disk_avail="$(echo "$disk" | cut -d' ' -f4)"
disk_pct="$(echo "$disk" | cut -d' ' -f5)"

# Output
echo
output Host: "$host@$ip"
output OS: "$(uname -o) $(uname -m)"
output Release: "$(uname -r)"
echo
output Memory: "$mem_used/$mem_total used ($mem_avail free)"
output Storage: "$disk_used/$disk_total = $disk_pct used ($disk_avail free)"
echo
output Uptime: "$(uptime -p)"
output Usage: "$(cut -d ' ' -f1-3 /proc/loadavg)"

# Raspberry Pi specific vcgencmd output
command -v vcgencmd > /dev/null || return
temp="$(vcgencmd measure_temp)"
output Temp: "${temp#temp=*}"
if [ "$(vcgencmd get_throttled)" != 'throttled=0x0' ]; then
    echo
    output WARNING "Power consumption unstable!"
    output Throttle: "$(vcgencmd get_throttled)"
    voltage="$(vcgencmd measure_volts core)"
    output Voltage: "${voltage#volt=*}"
fi

echo
