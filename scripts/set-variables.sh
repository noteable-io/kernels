#!/usr/bin/env bash
# Script for generating the tag to be used for resulting Docker builds
# Commits on main - Generate a 'latest' tag
# Releases - Generate a 'vX.X.X' tag
# If building on pull requests, generate a 'pr-XXX' tag

set -o errexit
set -o nounset
set -o pipefail

REF=${1:?'You must provide a ref name'}
EVENT=${2:?'You must provide the github event'}
PR_NUMBER=${3:-0}

TIMESTAMP=$(date)

if [[ "${REF}" == "main" ]]; then
  tag="latest"
elif [[ "${EVENT}" == "pull_request" ]]; then
  tag="pr-${PR_NUMBER}"
else
  tag="${REF}"
fi

echo "TAG=${tag}" >> "${GITHUB_ENV}"
echo "TIMESTAMP=${TIMESTAMP}" >> "${GITHUB_ENV}"
