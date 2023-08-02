#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

set -x

echo "Local time: $(date)"

set +x
echo "Injecting Secrets into environment, echoing is turned off"
source /tmp/secrets_helper.sh
echo "Done injecting Secrets, turning echoing back on"
set -x


echo "Starting Rust kernel"

exec evcxr_jupyter --control_file /etc/noteable/connections/connection_file.json
