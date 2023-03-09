# syntax = docker/dockerfile:1.4.3
ARG BASE_IMAGE=jupyter/datascience-notebook
ARG PYTHON_VERSION=3.9.13
# hadolint ignore=DL3006
FROM ${BASE_IMAGE}:python-${PYTHON_VERSION}

USER root

# datascience-notebook:python-3.9.13 includes psutil 5.9.2 with cooked C lib, but
# later pip installs end up installing 5.9.4, but for some
# reason 'import psutil' will end up getting the python 5.9.4 but the
# C lib from 5.9.2, and, unlike Smeagol, it hateses the precious.
RUN pip uninstall -y psutil

# Set up log file for magics
RUN touch /var/log/noteable_magics.log && \
  chown 4004:4004 /var/log/noteable_magics.log

# When image is run, run the code with the environment
# activated:
SHELL ["/bin/bash", "-c"]

WORKDIR /tmp

# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
  apt-get install -y jq procps git unixodbc-dev g++ \
  && rm -rf /var/lib/apt/lists/*

ENV NB_USER="noteable" \
  NB_UID=4004 \
  NB_GID=4004

# Create the default unprivileged user
RUN groupadd --gid 4004 noteable && \
  useradd --uid 4004 --shell /bin/false --create-home --no-log-init --gid noteable noteable && \
  chown --recursive noteable:noteable /home/noteable

RUN mkdir /etc/ipython && chown noteable:noteable /etc/ipython
RUN mkdir -p /etc/noteable && chown noteable:noteable /etc/noteable

RUN chown noteable:noteable "${CONDA_DIR}" && \
  fix-permissions "${CONDA_DIR}"

# `rust` is required for install of some packages under arm (and future x86 packages)
# hadolint ignore=SC1091
RUN wget -O rustup.sh -q https://sh.rustup.rs && \
    sh rustup.sh -y && \
    rm rustup.sh && \
    source "$HOME/.cargo/env"

# Run non-privileged user
USER noteable

ENV PATH="/home/noteable/.local/bin:${PATH}" \
  HOME="/home/noteable" \
  XDG_CACHE_HOME="/home/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

# hadolint ignore=DL3045
COPY environment-${PYTHON_VERSION}.txt  ./environment.txt

# hadolint ignore=SC2034
RUN mamba install --file environment.txt

# hadolint ignore=DL3045
COPY requirements-${PYTHON_VERSION}.txt ./requirements.txt

# hadolint ignore=SC1008,SC2155,DL3042,SC2102
RUN pip install -I --no-cache-dir -r requirements.txt

# Copy over any python commands that need to run on startup
# that aren't covered by IPython extensions
COPY .pythonrc /home/noteable/.pythonrc

# Enable the widgets nbextension
# hadolint ignore=SC1008
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Smoke test to ensure packages were installed properly
# hadolint ignore=SC1008
RUN python -c "import noteable_magics"

RUN git config --global user.name "Noteable Kernel" && \
  git config --global user.email "engineering@noteable.io" && \
  git config --global safe.directory /etc/noteable/project && \
  git config --global credential.helper /git_credential_helper.py && \
  git config --global credential.useHttpPath true

# https://ipython.readthedocs.io/en/stable/config/intro.html#systemwide-configuration
COPY ipython_config.py /etc/ipython

# Set standard working directory for noteable project
WORKDIR /etc/noteable/project

# Add the entrypoint script to the $PATH
COPY run.sh /usr/local/bin
COPY secrets_helper.py /tmp/secrets_helper.py
COPY git_credential_helper.py /git_credential_helper.py
COPY git-wrapper.sh /usr/local/bin/git

EXPOSE 50001-50005

# Use tini to manage passing signals to the child kernel process
# -g will ensure signals are passed to the entire child process *group*, 
# not just the immediate child process (bash)
# https://github.com/krallin/tini#process-group-killing
ENTRYPOINT ["tini", "-g", "--"]
CMD ["run.sh"]

# Labels
ARG NBL_ARG_BUILD_TIMESTAMP="undefined"
ARG NBL_ARG_REVISION="undefined"
ARG NBL_ARG_PYTHON_VERSION="3.9.6"
ARG NBL_ARG_BUILD_URL="undefined"
ARG NBL_ARG_VERSION="undefined"
LABEL org.opencontainers.image.created="${NBL_ARG_BUILD_TIMESTAMP}" \
  org.opencontainers.image.revision="${NBL_ARG_REVISION}" \
  org.opencontainers.image.source="https://github.com/noteable-io/polymorph" \
  org.opencontainers.image.title="noteable-python-${NBL_ARG_PYTHON_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.vendor="Noteable" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"
