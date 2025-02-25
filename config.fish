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

# Default location for custom user binaries
fish_add_path ~/.local/bin
