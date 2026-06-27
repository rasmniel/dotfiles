alias g='git'
# Clone dotfiles with `git clone --bare git@github.com:rasmniel/dotfiles.git ~/.dotfiles`
# Then `d checkout` to pull changes when ready.
alias d='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Edit and source .bashrc using nvim.
alias rc='nvim ~/.bashrc'
alias src='source ~/.bashrc'

# Systemd shorthands
alias sc='sudo systemctl'
alias scr='sudo systemctl daemon-reload'

# journalctl
alias jc='sudo journalctl -u'
alias jcf='sudo journalctl -o cat -f -u'

# System tooling
alias setup='bash "$HOME/.files/setup/setup.sh"'
alias ppl='bash "$HOME/.files/pipeline/pipeline.sh"'
alias pm='bash "$HOME/.files/projects/manager.sh"'

# cd shorthands
alias srv='cd /srv && la'
alias sys='cd /etc/systemd/system'
alias desktop='cd /usr/share/applications/'

# Improvements for `ls`
alias ls='ls --color=auto'
alias la='ls -lhaA'
alias lg='la | grep'

# Colors for grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias se='sudoedit'

# Kill process listening on the given port.
killport() {
    kill -9 "$(lsof -t -i :"$1")"
}

# Clipboard using xclip
clip() {
    < "$1" xclip -sel clip
}
alias clip='clip'
alias clip_rsa='clip ~/.ssh/id_rsa.pub'
alias clip_ed25519='clip ~/.ssh/id_ed25519.pub'

