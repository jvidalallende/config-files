# Directory listings
alias ll='ls -alF'
alias lh='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Fast directory change
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

# Docker
alias docker-clean-volumes='docker volume ls -qf dangling=true | xargs docker volume rm'
alias dkps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dkpsi='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'

# Kubectl
alias k=kubectl

# Bash only checks aliases in the first word, unless the first alias ends with space
alias sudo='sudo '

# Misc aliases
alias remove-trailing-whitespaces="git grep -I --name-only -z -e '' | xargs -0 sed -i 's/[ \t]\+\(\r\?\)$/\1/'"
alias battery-check='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|time to empty|percentage"'
alias folder-space='du -h --max-depth=1 2>/dev/null'

# Git branch in prompt
# Since the prompt is being modified, modify it depending on being root or not
#  - For root, end with '# '
#  - For regular users, end with '> '

parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

USER_SUFFIX='> '
[[ $(id -u) -eq 0 ]] && USER_SUFFIX='# '

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

# Not aliases, but help with crazy dircolors backgrounds:
# https://stackoverflow.com/questions/40574819/how-to-remove-dir-background-in-ls-color-output/
LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:'
export LS_COLORS

alias vim=nvim
alias tf=terraform

# Source some extra files

[[ -f ~/.git-completion.bash ]] && source ~/.git-completion.bash
[[ -f ~/.bash_hidden_aliases ]] && source ~/.bash_hidden_aliases
