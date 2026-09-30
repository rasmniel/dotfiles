bootstrap() {
    mkdir -p "$PROJECT_DIR"
    git clone "$BOOTSTRAP_PROJECT" "$PROJECT_DIR"
    rm -rf "$PROJECT_DIR/.git"
    cd "$PROJECT_DIR" && npm install
}

