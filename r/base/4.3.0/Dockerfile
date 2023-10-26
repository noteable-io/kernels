# syntax = docker/dockerfile:1.5
# ---
# Bare minimum R 4.3.x image with IRkernel installed
# - no R packages aside from builtins and IRkernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_R_VERSION=4.3.0
FROM r-base:${NBL_R_VERSION} as base

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
  mkdir -p "${NBL_WORK_DIR}" && chown --recursive noteable:noteable "${NBL_WORK_DIR}" && \
  chown --recursive noteable:noteable /usr/local/lib/R/site-library

# Install tini to manage passing signals to the child kernel process
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Use micromamba and set up a virtual environment so we can install packages without root
COPY apt-install /usr/bin/
# hadolint ignore=DL3045
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

# hadolint ignore=SC2239
RUN R -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')"

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="${NBL_HOME_DIR}" \
  XDG_CACHE_HOME="${NBL_HOME_DIR}/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

WORKDIR ${NBL_WORK_DIR}/project
EXPOSE 50001-50005

ENTRYPOINT ["/tini", "-g", "--"]
CMD ["run.sh"]
