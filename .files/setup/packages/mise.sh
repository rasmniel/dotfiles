setup_mise() {
    curl https://mise.run | sh
    eval "$(mise activate bash)"
    mise install
}

