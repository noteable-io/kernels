# syntax = docker/dockerfile:1.2.1
# ---
# Bare minimum Python 3.x.x image with ipykernel installed
# - no Python packages aside from builtins and ipykernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_PYTHON_VERSION=3.9
FROM python:${NBL_PYTHON_VERSION}-slim-bullseye as base

#### Configurations for GPU drivers
# CUDA Compatibility matrix: https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#cuda-major-component-versions
# AWS GPU AMI information: https://github.com/awslabs/amazon-eks-ami/blob/master/CHANGELOG.md

ENV CUDNN_VERSION="8.2.4.15-1" \
  CUDA_VERSION="11.4" \
  NVIDIA_LIBCUDNN_VERSION="8.2.4.15" \
  CUDA_DASH="11-4" \
  CONDA_PREFIX="/opt/conda"

USER root

WORKDIR /tmp

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
  sudo dpkg -i cuda-keyring_1.0-1_all.deb

COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

ENV NB_USER="noteable" \
  NB_UID=4004 \
  NB_GID=4004 \
  PATH="/home/noteable/.local/bin:${PATH}" \
  HOME="/home/noteable" \
  XDG_CACHE_HOME="/home/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

RUN chown noteable:noteable "${CONDA_DIR}" && fix-permissions "${CONDA_DIR}"

# Run non-privileged user
USER noteable

# hadolint ignore=DL3045
COPY environment.txt gpu_requirements.txt ./
RUN mamba install -y --file environment.txt
RUN pip install -I --no-cache-dir -r gpu_requirements.txt

# NOTE: At the moment, we're unable to use numba. Numba doesn't have support for forward compatibility,
# which requires that runtime / driver versions match for CUDA. The highest driver version supported by Amazon Linux
# is 11.4, where as the lowest supported version in Ubuntu 22.04 is 11.7

# Install tensorflow
RUN python3 -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.* && \
  mkdir -p $CONDA_PREFIX/lib/nvvm/libdevice && \
  cp $CONDA_PREFIX/lib/libdevice.10.bc $CONDA_PREFIX/lib/nvvm/libdevice/

# Set environment variables for Tensorflow / Cuda
ENV CUDNN_PATH=/opt/conda/lib/python3.9/site-packages/nvidia/cudnn
# ENV doesn't seem to inherit from previous values when ran in same command
# We move to separate lines to ensure CUDNN_PATH is available
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib \
  XLA_FLAGS="--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib/"

# Smoke test to ensure packages were installed properly
# hadolint ignore=SC1008
RUN python -c "import dx, noteable, psutil, tensorflow as tf, cuda, torch"

# Set standard working directory for noteable project
WORKDIR /etc/noteable/project


# hadolint ignore=DL3007
FROM base AS dev

# Copy any local packages into the image for development/testing
#COPY ./dev_packages /dev_packages
#RUN pip install /dev_packages/**/*
#RUN python -c "import dx, noteable, psutil, sidecar_comms"

FROM base
# Labels
ARG NBL_ARG_REVISION="undefined"
ARG NBL_ARG_PYTHON_VERSION="3.9.6"
ARG NBL_ARG_BUILD_URL="undefined"
ARG NBL_ARG_VERSION="undefined"
LABEL org.opencontainers.image.revision="${NBL_ARG_REVISION}" \
  org.opencontainers.image.title="noteable-gpu-${NBL_ARG_PYTHON_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"
