setup_nvim() {
    arch="x86_64"
    test "$(uname -m)" = aarch64 && arch="arm64"
    package="nvim-linux-$arch.tar.gz"
    curl -LO "https://github.com/neovim/neovim/releases/download/v0.11.2/$package"
    mkdir -p ~/.nvim
    tar -xzf "$package" --strip-components=1 -C ~/.nvim
    rm "$package"
}

