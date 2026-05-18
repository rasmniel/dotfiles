# vim: set ft=sh

#
## Setup prompt command

__last_exit="$?"
# Exit code must be stored as the very first thing when the prompt is built, or subsequent prompt commands may override it.
function __store_last_exit_code() {
    __last_exit="$?"
}

function __show_git() {
    # Check if cwd is inside a git repository.
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
    # Omit git prompt for home-level repository, i.e. dotfiles.
    test "$(git rev-parse --show-toplevel)" != "$HOME" || return 1
}

# Prompt command executes before the prompt is built and can capture state left by the previous command.
PROMPT_COMMAND='__store_last_exit_code'

#
## Build prompt

function __cwd() {
    printf " %s" "$(__bold_blue "${PWD/#$HOME/"~"}")"
}

function __git_branch() {
    __show_git || return
    printf " (%s)" "$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
}

function __git_status() {
    __show_git || return
    test ! -z "$(git status --porcelain=v1)" || return
    printf " %s" "$(__bold_green "+")"
}

function __exit_code() {
    test "$__last_exit" != 0 || return
    test "$__last_exit" != 130 || return # 130 is SIGINT (ctrl+c)
    printf " %s" "$(__bold_red "$__last_exit")"
}

function __dollar() {
    printf " %s " '$'
}

# The PS1 variable is used to construct the interactive shell prompt.
PS1='\A$(__cwd)$(__git_branch)$(__git_status)$(__exit_code)$(__dollar)'

