# syntax = docker/dockerfile:1.2.1
# ---
# Bare minimum Python 3.x.x image with ipykernel installed and bare minimum GPU drivers and packages
# - no Python packages aside from builtins and ipykernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_PYTHON_VERSION=3.9
FROM python:${NBL_PYTHON_VERSION}-slim-bullseye as base

# User/group setup
USER root

ENV NB_USER="noteable" \
  NB_UID=4004 \
  NB_GID=4004

RUN groupadd --gid 4004 noteable && \
  useradd --uid 4004 \
  --shell /bin/false \
  --create-home \
  --no-log-init \
  --gid noteable noteable && \
  chown --recursive noteable:noteable /home/noteable && \
  mkdir /opt/venv && chown noteable:noteable /opt/venv && \
  mkdir /etc/ipython && chown noteable:noteable /etc/ipython && \
  mkdir -p /etc/noteable && chown noteable:noteable /etc/noteable

# Install tini to manage passing signals to the child kernel process
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY apt-install /usr/bin/
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

# micromamba because we're tempting fate
RUN wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba && \
  ./bin/micromamba shell init -s bash -p ~/micromamba

USER noteable
RUN micromamba create --name noteable-venv \
  -c conda-forge \
  -y \
  python=${NBL_PYTHON_VERSION}

SHELL ["micromamba", "run", "-n", "noteable-venv", "/bin/bash", "-c"]

# Configurations for GPU drivers
# CUDA Compatibility matrix: https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#cuda-major-component-versions
# AWS GPU AMI information: https://github.com/awslabs/amazon-eks-ami/blob/master/CHANGELOG.md

ENV CUDNN_VERSION="8.2.4.15-1" \
  CUDA_VERSION="11.4" \
  NVIDIA_LIBCUDNN_VERSION="8.2.4.15" \
  CUDA_DASH="11-4" \
  CONDA_PREFIX="/opt/conda"

WORKDIR /tmp

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
  sudo dpkg -i cuda-keyring_1.0-1_all.deb

RUN chown noteable:noteable "${CONDA_DIR}" && fix-permissions "${CONDA_DIR}"

USER noteable

# hadolint ignore=DL3045
COPY environment.txt requirements.txt /tmp/
RUN micromamba install -c conda-forge -y --file /tmp/environment.txt
RUN pip install -I --no-cache-dir -r /tmp/requirements.txt

# NOTE: At the moment, we're unable to use numba. Numba doesn't have support for forward compatibility,
# which requires that runtime / driver versions match for CUDA. The highest driver version supported by Amazon Linux
# is 11.4, where as the lowest supported version in Ubuntu 22.04 is 11.7

# Install tensorflow
RUN mkdir -p $CONDA_PREFIX/lib/nvvm/libdevice && \
  cp $CONDA_PREFIX/lib/libdevice.10.bc $CONDA_PREFIX/lib/nvvm/libdevice/

# Set environment variables for Tensorflow / Cuda
ENV CUDNN_PATH=/opt/conda/lib/python3.9/site-packages/nvidia/cudnn
# ENV doesn't seem to inherit from previous values when ran in same command
# We move to separate lines to ensure CUDNN_PATH is available
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib \
  XLA_FLAGS="--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib/"

# Set standard working directory for noteable project
WORKDIR /etc/noteable/project

# Labels
ARG NBL_ARG_REVISION="undefined"
ARG NBL_ARG_PYTHON_VERSION="3.9.6"
ARG NBL_ARG_BUILD_URL="undefined"
ARG NBL_ARG_VERSION="undefined"
LABEL org.opencontainers.image.revision="${NBL_ARG_REVISION}" \
  org.opencontainers.image.title="noteable-python-gpu-${NBL_ARG_PYTHON_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"
