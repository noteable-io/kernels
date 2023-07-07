# syntax = docker/dockerfile:1.2.1
# Datascience build: adds packages based on the NumFOCUS datascience stack
ARG BASE_IMAGE
# hadolint ignore=DL3006
FROM ${BASE_IMAGE} as base

COPY requirements.txt /tmp/datascience_requirements.txt
RUN pip install --no-cache-dir -r /tmp/datascience_requirements.txt

FROM base as gpu

COPY gpu.requirements.txt /tmp/datascience_gpu_requirements.txt
RUN pip install --no-cache-dir -r /tmp/datascience_gpu_requirements.txt
