setup_apt() {
    sudo apt update
    sudo apt install -y \
        build-essential \
        curl \
        wget \
        git \
        vim \
        unzip \
        xclip \
        ripgrep \
        fd-find
}
