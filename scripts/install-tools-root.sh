#!/usr/bin/env bash

# Make script fail as soon as something goes bad
set -euo pipefail

# Use SCRIPT_TRACE=1 to enable "debug mode"
[[ ${SCRIPT_TRACE:-0} -eq 1 ]] && set -x

# Validate that the script is run with elevated privileges
if [[ $(id -u) -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

## Global variables -----------------------------------------------------------

BASE_PACKAGES="bat bison git jq fish lua5.1 luarocks neovim ripgrep shfmt shellcheck tmux tree-sitter-cli"
DOCKER_PACKAGES="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

## Helper functions -----------------------------------------------------------

apt_setup_docker_repo() {
	# Install docker setup prerequisites
	apt-get update
	apt-get -y install ca-certificates curl
	# Add docker's GPG key
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc
	# Add docker's APT repository
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
		>/etc/apt/sources.list.d/docker.list
}

dnf_setup_docker_repo() {
	dnf -y install dnf-plugins-core
	dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	rpm --import https://download.docker.com/linux/fedora/gpg
}

apt_install() {
	apt_setup_docker_repo
	apt-get update
	apt-get -y install ${BASE_PACKAGES} ${DOCKER_PACKAGES}
}

dnf_install() {
	dnf_setup_docker_repo
	dnf -y install ${BASE_PACKAGES} ${DOCKER_PACKAGES}
}

post_install() {
	# Only start the service if systemd is running as PID 1
	if [[ $(ps -p1 -o comm=) == "systemd" ]]; then
		systemctl enable --now docker
	fi
}

## Main -----------------------------------------------------------------------

# $1: OS identifier as indicated by /etc/os-release
main() {
	local os=$1
	case "${os}" in
	fedora)
		dnf_install
		;;
	ubuntu | debian)
		apt_install
		;;
	*)
		echo "Unsupported OS"
		exit 1
		;;
	esac
	post_install
}

# os-release populates several variables, ID among them
source /etc/os-release
main "${ID}"
