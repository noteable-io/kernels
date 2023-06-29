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

# Configurations for GPU drivers
# CUDA Compatibility matrix: https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#cuda-major-component-versions
# AWS GPU AMI information: https://github.com/awslabs/amazon-eks-ami/blob/master/CHANGELOG.md

ENV CUDNN_VERSION="8.2.4.15-1" \
  CUDA_VERSION="11.4" \
  NVIDIA_LIBCUDNN_VERSION="8.2.4.15" \
  CUDA_DASH="11-4" \
  CONDA_PREFIX="/opt/conda"

WORKDIR /tmp

# download and configure repo locally to install cuda-toolkit and libcnn8
USER root
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
  dpkg -i cuda-keyring_1.0-1_all.deb

COPY gpu.Aptfile .
RUN /usr/bin/apt-install gpu.Aptfile

ENV CONDA_DIR="/opt/conda"
RUN mkdir "${CONDA_DIR}" && \
  chown noteable:noteable "${CONDA_DIR}"

# micromamba because we're tempting fate
USER noteable

# Install Miniconda and Python 3.9
RUN curl -Lo miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && chmod +x miniconda.sh \
  && ./miniconda.sh -b -p "${CONDA_DIR}" \
  && rm miniconda.sh \
  && "${CONDA_DIR}/bin/conda clean" -tipsy \
  && ln -s "${CONDA_DIR}/etc/profile.d/conda.sh" /etc/profile.d/conda.sh \
  && echo ". "${CONDA_DIR}"/etc/profile.d/conda.sh" >> ~/.bashrc \
  && echo "conda activate base" >> ~/.bashrc

# Make RUN commands use the new environment
SHELL ["/bin/bash", "-c"]

# Install Mamba
RUN conda install -c conda-forge mamba

# Define environment variable
ENV PATH "${CONDA_DIR}/bin:${PATH}"

# hadolint ignore=DL3045
COPY environment.txt requirements.txt /tmp/

RUN mamba install -c conda-forge -y --file /tmp/environment.txt

RUN pip install -I --no-cache-dir -r /tmp/requirements.txt

COPY run.sh /usr/local/bin

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
EXPOSE 50001-50005

ENTRYPOINT ["/tini", "-g", "--"]
CMD ["run.sh"]

# Labels
ARG NBL_ARG_REVISION="undefined"
ARG NBL_ARG_PYTHON_VERSION="3.9.6"
ARG NBL_ARG_BUILD_URL="undefined"
ARG NBL_ARG_VERSION="undefined"
LABEL org.opencontainers.image.revision="${NBL_ARG_REVISION}" \
  org.opencontainers.image.title="noteable-python-gpu-${NBL_ARG_PYTHON_VERSION}" \
  org.opencontainers.image.url="${NBL_ARG_BUILD_URL}" \
  org.opencontainers.image.version="${NBL_ARG_VERSION}"
