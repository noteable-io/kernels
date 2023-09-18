# syntax = docker/dockerfile:1.5
# Packages build: imports/caches commonly-installed packages to ease load time
# hadolint ignore=DL3006
FROM base as main

USER noteable

COPY deno.lock /srv/noteable/deno.lock

# use an altered run.sh to use the deno.lock file
COPY run.sh /usr/local/bin
