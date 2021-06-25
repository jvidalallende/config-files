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

alias upy='sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y'

# Force tmux to use Unicode
alias tmux='tmux -u'
alias battery-check='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time to empty|percentage"'
alias folder-space='du -h --max-depth=1 2>/dev/null'
alias docker-clean-volumes='docker volume ls -qf dangling=true | xargs docker volume rm'

# Bash only checks aliases in the first word, unless the first alias ends with space
alias sudo='sudo '

alias remove-trailing-whitespaces="git grep -I --name-only -z -e '' | xargs -0 sed -i 's/[ \t]\+\(\r\?\)$/\1/'"

# Git branch in prompt
# Since the prompt is being modified, modify it depending on being root or not
#  - For root, end with '# '
#  - For regular users, end with '> '

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

USER_SUFFIX='> '
if [ `id -u` -eq 0 ];
then
    USER_SUFFIX='# '
fi

export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$USER_SUFFIX"


# Useful alias-like functions
gr() {
    if [ $# -ne 1 ]; then
        echo "Invalid number of arguments: $#"
        return 1
    fi
    grep -rnI "$1" .
}

gri() {
    if [ $# -ne 1 ]; then
        echo "Invalid number of arguments: $#"
        return 1
    fi
    grep -rnIi "$1" .
}

fname() {
    if [ $# -ne 1 ]; then
        echo "Invalid number of arguments: $#"
        return 1
    fi
    find . -name "$1"
}

finame() {
    if [ $# -ne 1 ]; then
        echo "Invalid number of arguments: $#"
        return 1
    fi
    find . -iname "$1"
}

# Not aliases, but help with crazy dircolors backgrounds:
# https://stackoverflow.com/questions/40574819/how-to-remove-dir-background-in-ls-color-output/
LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:'; export LS_COLORS


# Source some extra files

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

if [ -f ~/.bash_hidden_aliases ]; then
    . ~/.bash_hidden_aliases
fi
