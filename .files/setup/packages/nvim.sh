setup_nvim() {
    arch="x86_64"
    test "$(uname -m)" = aarch64 && arch="arm64"
    curl -LO "https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-$arch.tar.gz"
    mkdir -p ~/.nvim
    tar -xzf nvim-linux-x86_64.tar.gz --strip-components=1 -C ~/.nvim
    rm nvim-linux-x86_64.tar.gz
}

