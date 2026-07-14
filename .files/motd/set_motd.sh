#!/usr/bin/env bash

if [ ! -f ./motd.sh ]; then
    echo 'Run set_motd.sh directly from its location.'
    exit 1
fi

if [ ! -f /etc/motd ]; then
    echo 'No message of the day detected. Setup "/etc/motd" manually.'
    exit 1
fi

sudo truncate -s 0 /etc/motd || exit 1
motd=/etc/update-motd.d/10-motd
test -f "$motd" || sudo rm "$motd"
cp ./motd.sh "$motd"
chmod +x "$motd"

