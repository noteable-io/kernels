# syntax = docker/dockerfile:1.5
# hadolint ignore=DL3006
FROM base AS main

ARG NBL_PYTHON_VERSION=3.9

USER root

#### Configurations for GPU drivers
# CUDA Compatibility matrix: https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#cuda-major-component-versions
# AWS GPU AMI information: https://github.com/awslabs/amazon-eks-ami/blob/master/CHANGELOG.md
ENV CUDNN_VERSION="8.2.4.15-1" \
  CUDA_VERSION="11.4" \
  NVIDIA_LIBCUDNN_VERSION="8.2.4.15" \
  CUDA_DASH="11-4" \
  CONDA_DIR="/opt/conda"

# install micromamba
COPY --chown=noteable-noteable initial-condarc "${CONDA_DIR}/.condarc"
WORKDIR /tmp
RUN set -x && \
  arch=$(uname -m) && \
  if [ "${arch}" = "x86_64" ]; then \
  # Should be simpler, see <https://github.com/mamba-org/mamba/issues/1437>
  arch="64"; \
  fi && \
  wget --progress=dot:giga -O /tmp/micromamba.tar.bz2 \
  "https://micromamba.snakepit.net/api/micromamba/linux-${arch}/latest" && \
  tar -xvjf /tmp/micromamba.tar.bz2 --strip-components=1 bin/micromamba && \
  rm /tmp/micromamba.tar.bz2 && \
  # Install the packages
  ./micromamba install \
  --root-prefix="${CONDA_DIR}" \
  --prefix="${CONDA_DIR}" \
  --yes \
  python=$NBL_PYTHON_VERSION \
  'mamba' && \
  rm micromamba

ENV PATH="${CONDA_DIR}/bin:${PATH}"

# Pin major.minor version of python
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mamba list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned" && \
  mamba clean --all -f -y

RUN wget --progress=dot:giga https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
  dpkg -i cuda-keyring_1.0-1_all.deb

COPY Aptfile .
RUN /usr/bin/apt-install Aptfile
COPY gpu.Aptfile .
RUN /usr/bin/apt-install gpu.Aptfile

ENV PATH="/srv/noteable/.local/bin:${PATH}" \
  HOME="/srv/noteable" \
  XDG_CACHE_HOME="/srv/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

RUN chown -R noteable:noteable "${CONDA_DIR}"

# Run non-privileged user
USER noteable

COPY environment.txt /tmp/environment.txt
COPY requirements.txt /tmp/requirements.txt
RUN mamba env update -n base --file /tmp/environment.txt && \
  pip install -I --no-cache-dir -r /tmp/requirements.txt

RUN mkdir -p $CONDA_DIR/lib/nvvm/libdevice && \
  cp $CONDA_DIR/lib/libdevice.10.bc $CONDA_DIR/lib/nvvm/libdevice/

# Set environment variables for Tensorflow / Cuda
ENV CUDNN_PATH=/opt/conda/lib/python3.9/site-packages/nvidia/cudnn
# ENV doesn't seem to inherit from previous values when ran in same command
# We move to separate lines to ensure CUDNN_PATH is available
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_DIR/lib/:$CUDNN_PATH/lib \
  XLA_FLAGS="--xla_gpu_cuda_data_dir=$CONDA_DIR/lib/"

# Overwrite the base run.sh to include `mamba` usage
COPY run.sh /usr/local/bin

WORKDIR /etc/noteable/project
