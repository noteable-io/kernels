# syntax = docker/dockerfile:1.2.1
# Noteable build: adds packages to enable Noteable-specific functionality:
# - DEX support (via dx)
# - git integration (via gitpython, nbdime)
# - variable explorer, form cells (via sidecar_comms)
ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

ARG NBL_PYTHON_VERSION=3.9

USER root

# Prerequisites to install msodbcsql18 driver for MS SQL Server connectivity.
# From https://github.com/MicrosoftDocs/sql-docs/issues/8821#issuecomment-1569088666
RUN apt-get update -y && \
    apt-get install gnupg2 lsb-release -y  && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg && \
    echo "deb [arch=amd64,armhf,arm64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/debian/$(lsb_release -rs)/prod bullseye main" > /etc/apt/sources.list.d/mssql-release.list

COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

RUN touch /var/log/noteable_magics.log && \
    chown noteable:noteable /var/log/noteable_magics.log

COPY requirements.txt /tmp/noteable_requirements.txt

RUN pip install --no-cache-dir -r /tmp/noteable_requirements.txt
