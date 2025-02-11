#!/usr/bin/env bash

# Make script fail as soon as something goes bad
set -euo pipefail

# Use SCRIPT_TRACE=1 to enable "debug mode"
[[ ${SCRIPT_TRACE:-0} -eq 1 ]] && set -x

## Helper functions -----------------------------------------------------------

check_regular_user() {
	if [[ $(id -u) -eq 0 ]]; then
		echo "This script should be run as regular user, do you want to continue? [y/N]"
		read -n1 accept
		[[ "${accept}" == "y" ]] || exit 1
	fi
}

clone_tmux_plugin_manager() {
	git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
}

link_config_files() {
	local script_dir repo_root
	script_dir=$(dirname "$(realpath "$0")")
	repo_root=$(realpath "${script_dir}/../")
	# Some distros (e.g. Fedora) have a default .bash_profile that is OK
	ln -s "${repo_root}/bash_profile" "${HOME}/.bash_profile" || true
	ln -s "${repo_root}/bash_aliases" "${HOME}/.bash_aliases"
	if ! grep '. ~/.bash_aliases' "${HOME}/.bashrc"; then
		echo '[ -f ~/.bash_aliases ] && . ~/.bash_aliases' >>"${HOME}/.bashrc"
	fi
	ln -s "${repo_root}/tmux.conf" "${HOME}/.tmux.conf"
	ln -s "${repo_root}/gitconfig" "${HOME}/.gitconfig"
	ln -s "${repo_root}/gitignore_global" "${HOME}/.gitignore_global"
	ln -s "${repo_root}/vimrc" "${HOME}/.vimrc"
	ln -s "${repo_root}/vim" "${HOME}/.vim"
	mkdir -p "${HOME}/.config"
	ln -s "${repo_root}/nvim" "${HOME}/.config/nvim"
}

# GVM does not have fish integration out of the box, install with bash and then add fish wrapper
setup_gvm() {
	bash < <(curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
}

setup_fish() {
	local fisher_url="https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"
	fish -c "curl -fsSL ${fisher_url} | source && fisher install jorgebucaran/fisher"
	# Prompt manager. Configuration is the output of "tide configure"
	fish -c "fisher install IlanCosman/tide@v6"
	fish -c tide configure --auto --style=Classic --prompt_colors='True color' \
		--classic_prompt_color=Dark --show_time='24-hour format' \
		--classic_prompt_separators=Angled --powerline_prompt_heads=Sharp \
		--powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' \
		--prompt_connection=Disconnected --powerline_right_prompt_frame=No \
		--prompt_spacing=Sparse --icons='Few icons' --transient=No
	# GVM wrapper (fish-gvm depends on bass)
	fish -c "fisher install edc/bass"
	fish -c "fisher install JGAntunes/fish-gvm"
}

## Do-nothing functions -------------------------------------------------------

add_to_docker_group() {
	local user
	user=$(whoami)
	echo "Run 'usermod -aG docker "${user}"' to add yourserlf to docker group"
	echo "Then, logout and login again for the change to take effect"
}

set_fish_as_default_shell() {
	local fish_bin
	fish_bin=$(which fish)
	echo "Run 'chsh --shell "${fish_bin}"' to set fish as your default shell"
}

## Main -----------------------------------------------------------------------

check_regular_user
link_config_files
clone_tmux_plugin_manager
setup_gvm
setup_fish

add_to_docker_group
set_fish_as_default_shell
