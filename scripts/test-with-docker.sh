#!/usr/bin/env bash

set -euo pipefail
[[ ${SCRIPT_TRACE:-0} -eq 1 ]] && set -x

# Global variables ------------------------------------------------------------

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Helper functions ------------------------------------------------------------

# $1: script dir
# $2: container image to test
run_test() {
	local script_dir="$1"
	local container_image="$2"
	local container_name
	container_name=$(echo "${container_image}" | tr ':' '-')

	# Clean dangling containers from previous executions
	# Prefer this approach over using a TRAP on errors, so that on failures the
	# container is kept running for inspection.
	docker kill "${container_name}" >/dev/null 2>&1 || true
	# Sleep for 1 second for kill to succeed
	sleep 1

	echo "Test image [${container_image}], container name is [${container_name}]"
	# Allocate TTY so that containers stay up&running
	docker run \
		--detach \
		--rm \
		--tty \
		--name="${container_name}" \
		--volume "${script_dir}":/scripts \
		"${container_image}" \
		bash
	docker exec "${container_name}" /scripts/install-tools-root.sh
	docker kill "${container_name}"
}

# Main ------------------------------------------------------------------------

declare -a IMAGES=("ubuntu:24.04" "fedora:41")

for image in "${IMAGES[@]}"; do
	run_test "${SCRIPT_DIR}" "${image}"
	echo "----------------------------------------------------------------"
done
