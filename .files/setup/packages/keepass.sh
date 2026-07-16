setup_keepass() {
    command -v flatpak > /dev/null || panic "Flatpak not installed."
    flatpak remote-add -y --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y --user flathub org.keepassxc.KeePassXC
}
