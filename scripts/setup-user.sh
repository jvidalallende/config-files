#!/usr/bin/env bash

# Make script fail as soon as something goes wrong
set -euo pipefail

# Use SCRIPT_TRACE=1 to enable "debug mode"
[[ ${SCRIPT_TRACE:-0} -eq 1 ]] && set -x

# IMPORTANT: this script should be idempotent, so subsequent runs do not fail if
# part of the setup was already done.

## Helper functions -----------------------------------------------------------

# $1: target file
# $2: link name
_link_file() {
	local target=$1
	local link_name=$2
	if [[ -e "${link_name}" ]]; then
		if [[ -L "${link_name}" ]]; then
			echo "Link [${link_name}] already exists, skipping creation"
		else
			echo "WARNING: File [${link_name}] already exists but it's not a link"
		fi
	else
		# Test for existence failed, could be a broken link, so remove it just in case
		rm -f "${link_name}"
		ln -s "${target}" "${link_name}"
	fi
}

## Main functions --------------------------------------------------------------

check_regular_user() {
	if [[ $(id -u) -eq 0 ]]; then
		echo "This script should be run as regular user, do you want to continue? [y/N]"
		read -r -n1 accept
		[[ "${accept}" == "y" ]] || exit 1
	fi
}

clone_tmux_plugin_manager() {
	if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
		echo "TMUX Plugin manager folder already exists, skipping clone"
	else
		git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	fi
}

link_config_files() {
	local script_dir repo_root
	script_dir=$(dirname "$(realpath "$0")")
	repo_root=$(realpath "${script_dir}/../")

	_link_file "${repo_root}/bash_profile" "${HOME}/.bash_profile"
	_link_file "${repo_root}/bash_aliases" "${HOME}/.bash_aliases"
	_link_file "${repo_root}/tmux.conf" "${HOME}/.tmux.conf"
	_link_file "${repo_root}/gitconfig" "${HOME}/.gitconfig"
	_link_file "${repo_root}/gitignore_global" "${HOME}/.gitignore_global"
	_link_file "${repo_root}/vimrc" "${HOME}/.vimrc"
	_link_file "${repo_root}/vim" "${HOME}/.vim"

	mkdir -p "${HOME}/.config/Code/User"
	_link_file "${repo_root}/nvim" "${HOME}/.config/nvim"
	_link_file "${repo_root}/settings.json" "${HOME}/.config/Code/User/settings.json"
	_link_file "${repo_root}/keybindings.json" "${HOME}/.config/Code/User/keybindings.json"

	if ! grep -q '. ~/.bash_aliases' "${HOME}/.bashrc"; then
		echo '[ -f ~/.bash_aliases ] && . ~/.bash_aliases' >>"${HOME}/.bashrc"
	fi
}

# GVM does not have fish integration out of the box, install with bash and then add fish wrapper
setup_gvm() {
	if [[ -d "${HOME}/.gvm" ]]; then
		echo "Go Version Manager (GVM) folder already exists, skipping install"
	else
		bash < <(curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	fi
}

setup_fish() {
	local fisher_url="https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"
	fish -c "curl -fsSL ${fisher_url} | source && fisher install jorgebucaran/fisher"
	# GVM wrapper (fish-gvm depends on bass)
	fish -c "fisher install edc/bass"
	fish -c "fisher install JGAntunes/fish-gvm"
	# Prompt manager. Configuration is the output of "tide configure"
	fish -c "fisher install IlanCosman/tide@v6"
	fish -c "tide configure --auto \
				--style=Classic \
				--prompt_colors='True color' \
				--classic_prompt_color=Dark \
				--show_time='24-hour format' \
				--classic_prompt_separators=Angled \
				--powerline_prompt_heads=Sharp \
				--powerline_prompt_tails=Flat \
				--powerline_prompt_style='Two lines, character' \
				--prompt_connection=Disconnected \
				--powerline_right_prompt_frame=No \
				--prompt_spacing=Sparse \
				--icons='Few icons' \
				--transient=No"
}

## Do-nothing functions -------------------------------------------------------

add_to_docker_group() {
	# Check if the user already belongs to docker group
	if ! id --groups --name | grep -qw 'docker'; then
		local user
		user=$(whoami)
		echo "- Run 'usermod -aG docker "${user}"' to add yourserlf to docker group (requires logout)"
	fi
}

set_fish_as_default_shell() {
	# SHELL is populated from /etc/passwd, which is default's user login shell
	if ! echo "${SHELL}" | grep -q 'fish'; then
		local fish_bin
		fish_bin=$(which fish)
		echo "- Run 'chsh --shell "${fish_bin}"' to set fish as your default shell"
	fi
}

## Main -----------------------------------------------------------------------

check_regular_user
link_config_files
clone_tmux_plugin_manager
setup_gvm
setup_fish

echo -e "\n############################# SETUP FINISHED #############################\n"
add_to_docker_group
set_fish_as_default_shell
