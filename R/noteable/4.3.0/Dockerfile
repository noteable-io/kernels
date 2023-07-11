# syntax = docker/dockerfile:1.4
# Noteable build: adds packages to enable Noteable-specific functionality:
# - DEX support (via .Rprofile)
ARG BASE_IMAGE
# hadolint ignore=DL3006
FROM ${BASE_IMAGE} as base

USER noteable

# Install python to use with Reticulate
RUN micromamba install python=3.9 -y -c conda-forge

# R package dependencies and py_install
COPY requirements.R /tmp/requirements.R
RUN R -e "source('/tmp/requirements.R')"

# similarly, copy any R commands that need to run on startup
COPY .Rprofile /srv/noteable/.Rprofile
