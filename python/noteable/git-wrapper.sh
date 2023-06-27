#!/usr/bin/env bash
# This script wraps git to only allow certain commands to be run.
# We mainly want to prevent users from getting into unknown states by checking out other branches, etc.

# Allowed command list
allowed_commands=( "commit" "pull" "push" "status" "diff" "add" "fetch" "log" "version" )

# Check if the command is allowed
# shellcheck disable=SC2076
if [[ ! " ${allowed_commands[*]} " =~ " ${1} " ]]; then
    echo "That git command is not allowed, contact support@noteable.io if you think this is a mistake."
    exit 1
fi

# Otherwise pass through to git at /usr/bin/git
exec /usr/bin/git "$@"
