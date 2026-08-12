setup_keepass() {
    command -v flatpak > /dev/null || panic "Flatpak not installed."
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub org.keepassxc.KeePassXC
}
