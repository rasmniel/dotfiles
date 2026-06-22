__install_caddy() {
    # Install Caddy per official instructions.
    sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
    sudo chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    sudo chmod o+r /etc/apt/sources.list.d/caddy-stable.list
    sudo apt update
    sudo apt install -y caddy
}

setup_caddy() {
    local caddyfile="/etc/caddy/Caddyfile"
    local hosts_dir="/etc/caddy/hosts.d"
    local log_dir="/var/log/caddy"

    command -v caddy &> /dev/null || __install_caddy

    # Trust local Caddy certificates.
    sudo caddy trust

    # Create Caddyfile if it does not exist.
    if [ -f "$caddyfile" ]; then
        echo "Caddyfile already existing at \"$caddyfile\" will be used as-is."
    else
        echo "import $hosts_dir/*.caddy" | sudo tee "$caddyfile" > /dev/null
        sudo chmod 644 "$caddyfile"
    fi

    # Create directories.
    sudo mkdir -pm 755 "$hosts_dir" "$log_dir"
    sudo chown caddy:caddy "$hosts_dir" "$log_dir"
}

