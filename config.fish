# Commands to run in interactive sessions can go here
if status is-interactive

    # Disable welcome prompt on every appearance of the shell
    set fish_greeting

    # Aliases for fast directory change
    alias ...="cd ../../"
    alias ....="cd ../../../"
    alias .....="cd ../../../../"
    alias ......="cd ../../../../../"

    # Use neovim!
    alias vi=nvim
    alias vim=nvim
    set -gx EDITOR nvim
end

# Load homebrew if present
if test -d /opt/homebrew
    /opt/homebrew/bin/brew shellenv | source
end

# Default location for custom user binaries
fish_add_path ~/.local/bin
