# syntax = docker/dockerfile:1.2.1
# ---
# Bare minimum Python 3.x.x image with ipykernel installed
# - no Python packages aside from builtins and ipykernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_PYTHON_VERSION=3.10
FROM python:${NBL_PYTHON_VERSION}-slim-bullseye as base

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
  mkdir /etc/ipython && chown noteable:noteable /etc/ipython && \
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
  python=${NBL_PYTHON_VERSION}

SHELL ["micromamba", "run", "-n", "noteable-venv", "/bin/bash", "-c"]

RUN pip install --no-cache-dir ipykernel

COPY secrets_helper.py /tmp/secrets_helper.py
COPY run.sh /usr/local/bin

ENV HOME="/home/noteable" \
  PYTHONPATH="/home/noteable/.local/lib/python${NBL_PYTHON_VERSION}/site-packages:${PYTHONPATH}" \
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
  org.opencontainers.image.title="noteable-python-${NBL_PYTHON_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.vendor="Noteable" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"
