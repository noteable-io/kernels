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
        python -m ipykernel_launcher -f ${connection_file} --debug
        ;;

    ir)
        echo "Starting R kernel"
        R --slave -e "IRkernel::main()" --args  ${connection_file}
        ;;

    julia | julia-1.6)
        echo "Starting Julia kernel"
        # project path necessary to keep julia form using its defaults
        julia -i --color=yes --project=/etc/noteable/project /opt/julia/packages/IJulia/e8kqU/src/kernel.jl ${connection_file}
        ;;

    *)
        echo "Unrecognized '$kernel_name' kernel, falling back to Python"
        # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
        export PYTHONSTARTUP=~/.pythonrc
        python -m ipykernel_launcher -f ${connection_file} --debug
        ;;
esac
