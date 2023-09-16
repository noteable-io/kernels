# syntax = docker/dockerfile:1.5
# ---
# Bare minimum Deno 1.36 image with a canary upgrade to 1.37-dev
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_DENO_VERSION="1.37-dev"
FROM denoland/deno:1.36.4 as base

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

RUN deno upgrade --canary --version=430b63c2c4d6567a77e77980058ef13b45a9f30e

USER noteable

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="/srv/noteable"

WORKDIR /etc/noteable/project
EXPOSE 50001-50005

ENTRYPOINT ["tini", "-g", "--"]
CMD ["run.sh"]
