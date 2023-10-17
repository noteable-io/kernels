# syntax = docker/dockerfile:1.5
# Noteable build: adds packages to enable Noteable-specific functionality:
# - DEX support (via .Rprofile)
# hadolint ignore=DL3006
FROM base as main

USER root

# install python for reticulate support
# hadolint ignore=DL3045
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

# R package dependencies and py_install
COPY requirements.R /tmp/requirements.R
RUN R -e "source('/tmp/requirements.R')"

# similarly, copy any R commands that need to run on startup
COPY .Rprofile /var/run/noteable/.Rprofile
