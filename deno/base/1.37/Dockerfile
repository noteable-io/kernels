# syntax = docker/dockerfile:1.5
# ---
# Bare minimum Rust 1.72.x image with deno installed
# - no Rust crates/packages aside from builtins and deno
# - no git, secrets, SQL, extensions, etc
# ---
# Deno is installed from a PR that adds Jupyter support
# Rust 1.72 is required
ARG NBL_DENO_VERSION="1.37-dev"
FROM rust:1.72 as base

# User/group setup
USER root

ENV NB_USER="noteable" \
  NB_UID=4004 \
  NB_GID=4004

RUN groupadd --gid 4004 noteable && \
  useradd --uid 4004 \
  --shell /bin/false \
  --create-home \
  --no-log-init \
  --gid noteable noteable \
  --home-dir /var/run/noteable && \
  chown --recursive noteable:noteable /var/run/noteable

# TEMPORARY: symlink to the previous /etc/noteable until all other services are migrated and
# the old /etc/noteable can be removed
RUN ln -s /etc/noteable /var/run/noteable

WORKDIR /tmp

COPY apt-install /usr/bin/
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

# use the deno installer and upgrade to the specified (canary) build
# https://docs.deno.com/runtime/manual/references/contributing/release_schedule
ENV DENO_INSTALL=/srv/noteable
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
# deno installs to `DENO_INSTALL/bin`, so we'll add to PATH for follow-on deno commands
ENV PATH="${DENO_INSTALL}/bin/:${PATH}"
RUN deno upgrade \
  --canary \
  --version=48e695a2c89edad6e4880e7decfdb36d524f8279

# the kernel needs the deno kernelspec discoverable locally before it can start
# hadolint ignore=DL3059
RUN deno --unstable jupyter --install

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="/srv/noteable"

WORKDIR /var/run/noteable/project
EXPOSE 50001-50005

ENTRYPOINT ["tini", "-g", "--"]
CMD ["run.sh"]
