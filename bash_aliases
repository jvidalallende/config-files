# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# fast directory change
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

alias upy='sudo apt-get update && sudo apt-get dist-upgrade -y'

if [ -f ~/.bash_hidden_aliases ]; then
    . ~/.bash_hidden_aliases
fi
