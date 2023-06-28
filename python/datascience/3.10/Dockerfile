# syntax = docker/dockerfile:1.2.1
# Datascience build: adds packages based on the NumFOCUS datascience stack
ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

ARG NBL_PYTHON_VERSION=3.10

COPY requirements.txt /tmp/datascience_requirements.txt

RUN pip install --no-cache-dir -r /tmp/datascience_requirements.txt
