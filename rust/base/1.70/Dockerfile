ARG NBL_RUST_VERSION="1.70"
FROM rust:${NBL_RUST_VERSION}-slim-bullseye as base

RUN apt-get update && apt-get install -y tini

RUN groupadd --gid 4004 noteable && \
    useradd --uid 4004 --shell /bin/false --create-home --no-log-init --gid noteable noteable

RUN mkdir -p /etc/noteable/connections && \
    chown -R noteable:noteable /etc/noteable

USER noteable

ENV PATH="/home/noteable/.cargo/bin:${PATH}"

RUN cargo install evcxr_jupyter
RUN evcxr_jupyter --install

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

WORKDIR /srv/noteable

RUN cargo init

# Use tini to manage passing signals to the child kernel process
# -g will ensure signals are passed to the entire child process *group*, 
# not just the immediate child process (bash)
# https://github.com/krallin/tini#process-group-killing
ENTRYPOINT ["tini", "-g", "--"]
CMD ["run.sh"]

ARG NBL_ARG_BUILD_TIMESTAMP="undefined"
ARG NBL_ARG_REVISION="undefined"
ARG NBL_ARG_BUILD_URL="undefined"
ARG NBL_ARG_VERSION="undefined"
LABEL org.opencontainers.image.created="${NBL_ARG_BUILD_TIMESTAMP}" \
  org.opencontainers.image.revision="${NBL_ARG_REVISION}" \
  org.opencontainers.image.source="https://github.com/noteable-io/polymorph" \
  org.opencontainers.image.title="noteable-rust-${NBL_RUST_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.vendor="Noteable" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"