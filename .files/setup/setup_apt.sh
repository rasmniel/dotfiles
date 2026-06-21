# Install apt packages

setup_apt() {
    sudo apt update

    sudo apt install -y \
        build-essential \
        curl \
        wget \
        git \
        unzip \
        xclip \
        ripgrep \
        fd-find \
        mise
}

echo "- setup_apt: Install default apt packages"
