# Abort if running non-interactively
case $- in *i*) ;;
    *) return ;;
esac

# Source scripts and aliases
test -f "$HOME/.bash_aliases" && . "$HOME/.bash_aliases"
test -f "$HOME/.config/alacritty/acuitty_source.sh" && . "$HOME/.config/alacritty/acuitty_source.sh"
# Source all terminal .files indiscriminately
for file in "$HOME"/.files/terminal/*.sh; do
    test -f "$file" || continue
    # shellcheck disable=SC1090
    . "$file"
done

# Load default dircolors
eval "$(dircolors -b)"

# History control. See bash(1) for more options
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
if ! shopt -oq posix; then
    test -f /usr/share/bash-completion/bash_completion && . /usr/share/bash-completion/bash_completion
fi

# TODO: Remove $HOME/bin altogether and be explicit about path extensions.
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.nvim/bin:$HOME/.opencode/bin"

# Set default editors
export SUDO_EDITOR="$HOME/.nvim/bin/nvim"
export EDITOR="$HOME/.nvim/bin/nvim"

# Source local bashrc file if one exists.
test -f "$HOME/.bashrc.local" && . "$HOME/.bashrc.local"

# Activate mise, if installed
command -v mise > /dev/null && eval "$(mise activate bash)"

# Enter tmux, if installed and not already in tmux
test -z "$TMUX" && command -v tmux > /dev/null && exec tmux new-session

# Stow-away zone below this point.

