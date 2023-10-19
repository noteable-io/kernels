# syntax = docker/dockerfile:1.5
# Noteable build: adds packages to enable Noteable-specific functionality:
# - DEX support (via dx)
# - git integration (via gitpython, nbdime)
# - variable explorer, form cells (via sidecar_comms)
# hadolint ignore=DL3006
FROM base as main

ARG NBL_HOME_DIR=/srv/noteable
ARG NBL_PYTHON_VERSION=3.9

USER root

# Prerequisites to install msodbcsql18 driver for MS SQL Server connectivity.
# From https://github.com/MicrosoftDocs/sql-docs/issues/8821#issuecomment-1569088666
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update -y && \
    apt-get install gnupg2 lsb-release -y  && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg && \
    echo "deb [arch=amd64,armhf,arm64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/debian/$(lsb_release -rs)/prod bullseye main" > /etc/apt/sources.list.d/mssql-release.list

# hadolint ignore=DL3045
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

COPY requirements.txt /tmp/noteable_requirements.txt
RUN pip install --no-cache-dir -r /tmp/noteable_requirements.txt

# Smoke test to ensure packages were installed properly
# hadolint ignore=DL3059
RUN python -c "import dx, noteable, psutil, sidecar_comms"

COPY .pythonrc "${NBL_HOME_DIR}/."
COPY ipython_config.py /etc/ipython
COPY git_credential_helper.py /git_credential_helper.py
COPY git-wrapper.sh /usr/local/bin/git

# hadolint ignore=DL3007
FROM main AS dev

# Copy any local packages into the image for development/testing
COPY ./dev_packages /dev_packages
RUN if [ "$(ls /dev_packages)" ]; then \
    pip install --no-cache-dir /dev_packages/* && \
    python -c "import dx, noteable, psutil, sidecar_comms"; \
    else \
    echo "No dev_packages to install"; \
    fi

# hadolint ignore=DL3006
FROM main as gpu

COPY gpu.requirements.txt /tmp/noteable_gpu_requirements.txt
RUN pip install --no-cache-dir -r /tmp/noteable_gpu_requirements.txt

# hadolint ignore=DL3007
FROM gpu AS gpu-dev

# Copy any local packages into the image for development/testing
COPY ./gpu_dev_packages /gpu_dev_packages
RUN if [ "$(ls /gpu_dev_packages)" ]; then \
    pip install --no-cache-dir /gpu_dev_packages/* && \
    python -c "import dx, noteable, psutil, sidecar_comms"; \
    else \
    echo "No gpu_dev_packages to install"; \
    fi
