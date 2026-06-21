setup_nvim() {
    curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz
    mkdir -p ~/.nvim
    tar -xzf nvim-linux-x86_64.tar.gz --strip-components=1 -C ~/.nvim
    rm nvim-linux-x86_64.tar.gz
}

echo "- setup_nvim: Install Neovim 0.11 from official repository."

