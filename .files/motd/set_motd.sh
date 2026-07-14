#!/usr/env/bin bash

# Run this script directly from its location.
test -f ./motd.sh

test -f /etc/motd
sudo truncate -s 0 /etc/motd

motd=/etc/update-motd.d/10-motd
test -f "$motd" || sudo rm "$motd"

cp ./motd.sh "$motd"
chmod +x "$motd"

