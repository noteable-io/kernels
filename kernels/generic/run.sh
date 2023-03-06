#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

echo "Local time: $(date)"

set -x

connection_file=/tmp/connection_file.json

cp /etc/noteable/connections/connection_file.json ${connection_file}

kernel_name=$(jq -r .kernel_name /tmp/connection_file.json)

# Inject Secrets into environment (see script docstring for more info)
# set +x to avoid echoing the Secrets in plaintext to logs
set +x
echo "Injecting Secrets into environment, echoing is turned off"
eval "$(python /tmp/secrets_helper.py)"
echo "Done injecting Secrets, turning echoing back on"
set -x

case $kernel_name in

    python | python3)
        echo "Starting Python kernel"
        # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
        export PYTHONSTARTUP=~/.pythonrc
        exec python -m ipykernel_launcher -f ${connection_file} --debug
        ;;

    *)
        echo "Unrecognized '$kernel_name' kernel, falling back to Python"
        # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
        export PYTHONSTARTUP=~/.pythonrc
        exec python -m ipykernel_launcher -f ${connection_file} --debug
        ;;
esac
