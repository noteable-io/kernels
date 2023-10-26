# syntax = docker/dockerfile:1.5
# ---
# Bare minimum Rust 1.x.x image with evxcr_jupyter installed
# - no Rust crates/packages aside from builtins and evxcr_jupyter
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_RUST_VERSION="1.70"
FROM rust:${NBL_RUST_VERSION}-slim-bullseye as base

# Application code lives in NBL_HOME_DIR, project data lives in NBL_WORK_DIR
ARG NBL_HOME_DIR=/srv/noteable
ARG NBL_WORK_DIR=/var/run/noteable

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
  --home-dir "${NBL_HOME_DIR}" && \
  chown --recursive noteable:noteable "${NBL_HOME_DIR}" && \
  mkdir -p "${NBL_WORK_DIR}" && chown --recursive noteable:noteable "${NBL_WORK_DIR}"

WORKDIR /tmp

COPY apt-install /usr/bin/
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

ENV PATH="${NBL_HOME_DIR}/.cargo/bin:${PATH}"

RUN cargo install evcxr_jupyter && \
  evcxr_jupyter --install

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="${NBL_HOME_DIR}"

WORKDIR ${NBL_WORK_DIR}/project
EXPOSE 50001-50005

RUN cargo init

ENTRYPOINT ["tini", "-g", "--"]
CMD ["run.sh"]
