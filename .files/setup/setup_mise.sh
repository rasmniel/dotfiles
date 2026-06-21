setup_mise() {
    curl https://mise.run | sh
    eval "$(mise activate bash)"
    mise install
}

setup_node() {
    mise use -g node@latest
}

echo "- setup_mise: Install mise with official script @ mise.run and install packages."
echo "- setup_node: Install latest nodejs version with mise."
