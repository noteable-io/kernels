#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

set -x
kernel_pid=0
wait_pid=0

interrupt_ipykernel() {
    if [ "${wait_pid}" -ne 0 ]; then
        kill -15 "${wait_pid}"
    fi

    echo "Caught SIGUSR1"
    if [ "${kernel_pid}" -ne 0 ]; then
        echo "SIGINT'ing ${kernel_pid}"
        kill -2 "${kernel_pid}"
    fi
}

trap interrupt_ipykernel SIGUSR1

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
        if test -f /etc/noteable/project/requirements.txt; then
          pip install -r /etc/noteable/project/requirements.txt
        fi
        python -m ipykernel_launcher -f ${connection_file} &
        ;;

    ir)
        echo "Starting R kernel"
        R --slave -e "IRkernel::main()" --args  ${connection_file} &
        ;;

    julia | julia-1.6)
        echo "Starting Julia kernel"
        # project path necessary to keep julia form using its defaults
        julia -i --color=yes --project=/etc/noteable/project /opt/julia/packages/IJulia/e8kqU/src/kernel.jl ${connection_file} &
        ;;

    *)
        echo "Unrecognized '$kernel_name' kernel, falling back to Python"
        python -m ipykernel_launcher -f ${connection_file} &
        ;;
esac

kernel_pid="$!"

while true
do
    tail -f /dev/null &
    wait_pid="$!"
    wait "${wait_pid}" || true
done
