#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

set -x

echo "Local time: $(date)"

connection_file=/tmp/connection_file.json
VAR_RUN_FILE="/var/run/noteable/connections/connection_file.json"
ETC_FILE="/etc/noteable/connections/connection_file.json"

# This is a temporary change while we migrate from /etc/noteable to /var/run/noteable.
# Check if the /var/run file exists, and if it does, copy it to the destination
if [[ -f ${VAR_RUN_FILE} ]]; then
    cp ${VAR_RUN_FILE} ${connection_file}
# If the /var/run file doesn't exist, check for the /etc file and copy it if it exists
elif [[ -f ${ETC_FILE} ]]; then
    cp ${ETC_FILE} ${connection_file}
else
    echo "Error: Neither ${VAR_RUN_FILE} nor ${ETC_FILE} exists."
    exit 1
fi

set +x
echo "Injecting Secrets into environment, echoing is turned off"
# shellcheck disable=SC1091
source /tmp/secrets_helper.sh
echo "Done injecting Secrets, turning echoing back on"
set -x

echo "Starting Deno kernel"
exec deno --unstable \
    jupyter \
    --conn ${connection_file} \
    --kernel
