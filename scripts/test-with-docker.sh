#!/usr/bin/env bash

set -euo pipefail
[[ ${SCRIPT_TRACE:-0} -eq 1 ]] && set -x

# $1: absolute path to dockerfile
# $2: image name
run_test() {
	local script_dir="$1"
	local dockerfile="$2"
	local image_name="$3"

	# Clean dangling images from previous executions
	# Prefer this approach over using a TRAP on errors, so that on failures the
	# container is kept running for inspection.
	echo "Attempting deletion of image=[${image_name}], in case it is present..."
	docker rmi "${image_name}" >/dev/null 2>&1 || true

	echo "Test dockerfile=[${dockerfile}], image name is [${image_name}]"
	docker buildx build \
		--tag "${image_name}" \
		--file "${script_dir}/${dockerfile}" \
		"${script_dir}"

	echo "----------------------------------------------------------------"
	echo "BUILD WITH DOCKERFILE=[${dockerfile}] WAS SUCCESSFUL!!"
	echo "----------------------------------------------------------------"
}

# Main ------------------------------------------------------------------------

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
TEST_IMAGE_NAME="test-with-docker"
declare -a DOCKERFILES=("Dockerfile.fedora" "Dockerfile.ubuntu")

echo "################################################################"
for dockerfile in "${DOCKERFILES[@]}"; do
	IMAGE_NAME="test-with-docker:${dockerfile}"
	run_test "${SCRIPT_DIR}" "${dockerfile}" "${IMAGE_NAME}"
	echo "################################################################"
done
