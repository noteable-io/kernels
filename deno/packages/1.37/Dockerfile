# syntax = docker/dockerfile:1.5
# Packages build: imports/caches commonly-installed packages to ease load time
# hadolint ignore=DL3006
FROM base as main

USER noteable

# Copy and cache our desired imports
COPY ./deps.ts /tmp/deps.ts
RUN deno cache /tmp/deps.ts
