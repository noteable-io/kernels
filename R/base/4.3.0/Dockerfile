# syntax = docker/dockerfile:1.2.1
# ---
# Bare minimum R 4.3.x image with IRkernel installed
# - no R packages aside from builtins and IRkernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_R_VERSION=4.3.0
FROM r-base:${NBL_R_VERSION}

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
  --gid noteable noteable && \
  chown --recursive noteable:noteable /home/noteable && \
  mkdir -p /etc/noteable && chown noteable:noteable /etc/noteable

# Install tini to manage passing signals to the child kernel process
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Use micromamba and set up a virtual environment so we can install packages without root
COPY apt-install /usr/bin/
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

RUN wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba && \
  ./bin/micromamba shell init -s bash -p ~/micromamba

USER noteable
RUN micromamba create --name noteable-venv \
  -c conda-forge \
  -y \
  r=${NBL_R_VERSION}
# make subsequent RUN commands use the virtualenv:
SHELL ["micromamba", "run", "-n", "noteable-venv", "/bin/bash", "-c"]

# --- CORE: KERNEL INSTALLATION ---
RUN R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')"

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="/home/noteable" \
  XDG_CACHE_HOME="/home/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

WORKDIR /etc/noteable/project
EXPOSE 50001-50005

ENTRYPOINT ["/tini", "-g", "--"]
CMD ["run.sh"]

ARG NBL_ARG_BUILD_TIMESTAMP="undefined"
ARG NBL_ARG_REVISION="undefined"
ARG NBL_ARG_BUILD_URL="undefined"
ARG NBL_ARG_VERSION="undefined"
LABEL org.opencontainers.image.created="${NBL_ARG_BUILD_TIMESTAMP}" \
  org.opencontainers.image.revision="${NBL_ARG_REVISION}" \
  org.opencontainers.image.source="https://github.com/noteable-io/polymorph" \
  org.opencontainers.image.title="noteable-R-${NBL_R_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.vendor="Noteable" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"
