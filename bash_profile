# Source .bashrc in interactive login shells (e.g. opened by tmux)
# https://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-file

if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
