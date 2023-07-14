# syntax = docker/dockerfile:1.5
# Datascience build: adds packages based on the NumFOCUS datascience stack
# hadolint ignore=DL3006
FROM base as main

COPY requirements.txt /tmp/datascience_requirements.txt
RUN pip install --no-cache-dir -r /tmp/datascience_requirements.txt

# hadolint ignore=DL3006
FROM main as gpu

COPY gpu.requirements.txt /tmp/datascience_gpu_requirements.txt
RUN pip install --no-cache-dir -r /tmp/datascience_gpu_requirements.txt
