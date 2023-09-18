# syntax = docker/dockerfile:1.5
# Packages build: imports/caches commonly-installed packages to ease load time
# hadolint ignore=DL3006
FROM base as main

USER noteable

# run script that caches packages ahead of time
COPY imports.ts /tmp/imports.ts
RUN deno cache /tmp/imports.ts
