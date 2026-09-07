setup_apt() {
    sudo apt update
    sudo apt install -y \
        build-essential \
        bash-completion \
        curl \
        wget \
        git \
        vim \
        alacritty \
        tmux \
        unzip \
        xclip \
        jq \
        ripgrep
}
