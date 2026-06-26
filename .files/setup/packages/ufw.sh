setup_ufw() {
    sudo apt update
    sudo apt install ufw

    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow http
    sudo ufw allow https

    subnet="$(ip route | grep "proto kernel" | head -1 | cut -d' ' -f1)"
    echo "You are about to enable a strict firewall policy."
    echo "Deteced subnet mask $subnet as single-point SSH access."
    read -r -p "Is this correct? [y/N] > " confirm
    if [ "${confirm,,}" != 'y' ]; then
        echo "Subnet not confirmed. Aborted ufw setup. Firewall not enabled."
        return 1
    fi

    sudo ufw allow from "$subnet" to any port ssh
    sudo ufw enable
    sudo ufw status verbose
}
