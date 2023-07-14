# syntax = docker/dockerfile:1.5
# Datascience build: adds packages based on the Jupyter r-notebook dependencies
# (ref: https://github.com/jupyter/docker-stacks/blob/main/r-notebook/Dockerfile)
# hadolint ignore=DL3006
FROM base as main

USER noteable

# R package dependencies and py_install
COPY requirements.R /tmp/requirements.R
COPY install_packages.R /tmp/install_packages.R
RUN R -e "source('/tmp/install_packages.R')"
