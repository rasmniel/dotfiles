setup_fastfetch() {
    arch="$(uname -m)"
    case "$arch" in
      x86_64) arch=amd64 ;;
      aarch64|arm64) arch=aarch64 ;;
      armv7l) arch=armv7l ;;
      i686) arch=i686 ;;
      *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
    esac

    file="fastfetch-linux-${arch}.deb"
    url="https://github.com/fastfetch-cli/fastfetch/releases/latest/download/${file}"

    curl -fL -o "$file" "$url" || return 1
    sudo apt install "./$file"
    rm -f "$file"
}
