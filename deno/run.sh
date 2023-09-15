#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

set -x

echo "Local time: $(date)"

set +x
echo "Injecting Secrets into environment, echoing is turned off"
# shellcheck disable=SC1091
source /tmp/secrets_helper.sh
echo "Done injecting Secrets, turning echoing back on"
set -x

echo "Starting Deno kernel"
exec deno --unstable \
    jupyter \
    --conn /etc/noteable/connections/connection_file.json \
    --kernel
