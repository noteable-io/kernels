# syntax = docker/dockerfile:1.5
# ---
# Bare minimum R 4.3.x image with IRkernel installed
# - no R packages aside from builtins and IRkernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_R_VERSION=4.3.0
FROM r-base:${NBL_R_VERSION} as base

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

# Install tini to manage passing signals to the child kernel process
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Use micromamba and set up a virtual environment so we can install packages without root
COPY apt-install /usr/bin/
# hadolint ignore=DL3045
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba && \
  ./bin/micromamba shell init -s bash -p ~/micromamba

USER noteable
RUN micromamba create --name noteable-venv \
  -c conda-forge \
  -y \
  r="${NBL_R_VERSION}"
# make subsequent RUN commands use the virtualenv:
SHELL ["micromamba", "run", "-n", "noteable-venv", "/bin/bash", "-c"]

# hadolint ignore=SC2239
RUN R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')"

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="/srv/noteable" \
  XDG_CACHE_HOME="/srv/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

WORKDIR /etc/noteable/project
EXPOSE 50001-50005

ENTRYPOINT ["/tini", "-g", "--"]
CMD ["run.sh"]