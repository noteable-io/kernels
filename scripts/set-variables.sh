#!/usr/bin/env bash
# Script for generating the tag to be used for resulting Docker builds
# Commits on main - Generate a 'latest' tag
# Releases - Generate a 'vX.X.X' tag
# If building on pull requests, generate a 'pr-XXX' tag

set -o errexit
set -o nounset
set -o pipefail

REF=${1:?'You must provide a ref'}
EVENT=${2:?'You must provide the github event'}
PR_NUMBER=${3:-0}

TIMESTAMP=$(date)

# If 'main' or 'PR', we add a handle ('latest', 'pr-XXX') to the image
# We don't provide a handle for releases
if [[ "${REF}" == "refs/heads/main" ]]; then
  echo "HANDLE=latest" >> "${GITHUB_ENV}"
elif [[ "${EVENT}" == "pull_request" ]]; then
  echo "HANDLE=pr-${PR_NUMBER}" >> "${GITHUB_ENV}"
fi

# If a release, we use the tag, otherwise we use the commit SHA
if [[ "${EVENT}" == "release" ]]; then
  echo "TAG=${REF}" >> "${GITHUB_ENV}"
else
  echo "TAG=${GITHUB_SHA}" >> "${GITHUB_ENV}"
fi

# Always output the timestamp for builds
echo "TIMESTAMP=${TIMESTAMP}" >> "${GITHUB_ENV}"
