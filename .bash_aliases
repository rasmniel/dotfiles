# vim: set ft=sh

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

# TODO: Consider if these are necessary
# Caddy shorthands
alias cf='sudo caddy fmt --overwrite /etc/caddy/Caddyfile'
alias cr='sudo caddy reload --config /etc/caddy/Caddyfile'
alias cs='sudo caddy start --config /etc/caddy/Caddyfile'
alias ce='cf && sudoedit /etc/caddy/Caddyfile'

# cd shorthands
alias www='cd /var/www' # TODO: Remove deprecated alias
alias srv='cd /srv && la'
alias sys='cd /etc/systemd/system'
alias desktop='cd /usr/share/applications/'

# Kill process listening on the given port.
killport() {
    kill -9 "$(lsof -t -i :"$1")"
}

# Quickly create a project directory.
project() {
    mkdir "$1" && cd "$1" && git init
}
alias proj="project"

# Clipboard using xclip
clip() {
    < "$1" xclip -sel clip
}
alias clip='clip'
alias clip_rsa='clip ~/.ssh/id_rsa.pub'
alias clip_ed25519='clip ~/.ssh/id_ed25519.pub'

# Improvements for `ls`
alias ls='ls --color=auto'
alias la='ls -lhaA'
alias lg='la | grep'

# Colors for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias se='sudoedit'

