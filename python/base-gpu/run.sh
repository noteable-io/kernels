#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

echo "Local time: $(date)"

set -x

connection_file=/tmp/connection_file.json
cp /etc/noteable/connections/connection_file.json ${connection_file}

# Inject Secrets into environment (see script docstring for more info)
# set +x to avoid echoing the Secrets in plaintext to logs
set +x
echo "Injecting Secrets into environment, echoing is turned off"
# hadolint ignore=SC1091
source /tmp/secrets_helper.sh
echo "Done injecting Secrets, turning echoing back on"
set -x

echo "Starting Python kernel"
# https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
export PYTHONSTARTUP=~/.pythonrc

mamba run python -m ipykernel_launcher -f ${connection_file} --debug