# vim: set ft=sh

# Abort if running non-interactively
case $- in *i*) ;;
    *) return ;;
esac

# Source aliases
test -f "$HOME/.bash_aliases" && . "$HOME/.bash_aliases"
# Source all .files indiscriminately
for file in "$HOME"/.files/*.sh; do
    test -f "$file" || continue
    # shellcheck disable=SC1090
    . "$file"
done

# Disable capslock.
# setxkbmap -option caps:none

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

# PATH exports
# TODO: Remove $HOME/bin altogether.
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.nvim/bin:$HOME/.opencode/bin"

# Set default editors
export SUDO_EDITOR="$HOME/.nvim/bin/nvim"
export EDITOR="$HOME/.nvim/bin/nvim"

test -f "$HOME/.bashrc.local" && . "$HOME/.bashrc.local"

# Activate mise, if installed
command -v mise > /dev/null && eval "$(mise activate bash)"

# Stow-away zone below this point.

