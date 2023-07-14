# syntax = docker/dockerfile:1.2.1
# Datascience build: adds packages based on the Jupyter r-notebook dependencies
# hadolint ignore=DL3006
FROM base as main

USER noteable

# R package dependencies and py_install
COPY requirements.R /tmp/requirements.R
RUN R -e "source('/tmp/requirements.R')"

