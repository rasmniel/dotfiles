setup_tailscale() {
    sudo apt update -y
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo systemctl enable --now tailscaled
    sudo tailscale up
}
