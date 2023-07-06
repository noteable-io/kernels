#!/bin/bash

# This script helps inject Secrets into the Kernel environment.
# The Vault Agent will volume mount files into the Kernel container
# at /vault/secrets.  Noteable Secrets will be in .env suffix files.
# We want to parse all those files and export them as environment variables
# in the bash script that kicks off the Kernel (ipykernel_launcher etc).

secrets_directory=${VAULT_SECRETS_PATH:-/vault/secrets}

shopt -s nullglob

if [ -d "$secrets_directory" ]; then
    for file in "$secrets_directory"/*.env; do
        if [ -f "$file" ]; then
            name=$(basename "$file" .env)
            name=${name^^}  # Convert to uppercase
            if ! declare -p "$name" > /dev/null 2>&1; then  # If variable is not set
                content=$(cat "$file")
                export "$name=$content"
            fi
        fi
    done
fi

shopt -u nullglob