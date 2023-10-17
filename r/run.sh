#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

set -x
echo "Local time: $(date)"

connection_file=/tmp/connection_file.json
cp /var/run/noteable/connections/connection_file.json ${connection_file}

# Inject Secrets into environment (see script docstring for more info)
# set +x to avoid echoing the Secrets in plaintext to logs
set +x
echo "Injecting Secrets into environment, echoing is turned off"
# shellcheck disable=SC1091
source /tmp/secrets_helper.sh
echo "Done injecting Secrets, turning echoing back on"
set -x

echo "Starting R kernel"
exec R --slave -e "IRkernel::main()" --args  ${connection_file}
