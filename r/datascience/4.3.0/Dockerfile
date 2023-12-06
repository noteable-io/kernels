# syntax = docker/dockerfile:1.5
# Datascience build: adds packages based on the Jupyter r-notebook dependencies
# (ref: https://github.com/jupyter/docker-stacks/blob/main/r-notebook/Dockerfile)
# hadolint ignore=DL3006
FROM base as main

USER root

# R package dependencies
# hadolint ignore=DL3045
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

# install R packages
COPY requirements.R /tmp/requirements.R
COPY install_packages.R /tmp/install_packages.R
RUN R -e "source('/tmp/install_packages.R')"

# smoke test to ensure all packages are installed
RUN R -e "packages <- readLines('/tmp/requirements.R'); for(pkg in packages) { library(pkg, character.only = TRUE) }"
