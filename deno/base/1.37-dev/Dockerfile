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
    --home-dir /srv/noteable && \
    chown --recursive noteable:noteable /srv/noteable && \
    mkdir -p /etc/noteable && chown noteable:noteable /etc/noteable

WORKDIR /tmp

COPY apt-install /usr/bin/
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

ENV PATH="/srv/noteable/.cargo/bin:${PATH}"

RUN cargo install --git https://github.com/bartlomieju/deno --branch jupyter2 deno && deno jupyter --install

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="/srv/noteable"

WORKDIR /etc/noteable/project
EXPOSE 50001-50005

RUN cargo init

ENTRYPOINT ["tini", "-g", "--"]
CMD ["run.sh"]
