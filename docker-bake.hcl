# Builds for Noteable kernels are managed by https://docs.docker.com/engine/reference/commandline/buildx_bake/
# For further reference for the configurations in this file
# - https://docs.docker.com/build/bake/reference/

# Environment variable for configuring
# the ":$tag" for build Docker images
variable "TAG" {
  default = "latest"
}

# Github SHA, which is used for the revision label
variable "GITHUB_SHA" {
  default = ""
}

# URL for the github build that created the image
variable "BUILD_URL" {
  default = ""
}

# When the image was created
variable "TIMESTAMP" {
  default = ""
}

# Group of Rust targets
group "rust" {
  targets = [
    "rust_base_1_70",
  ]
}

# Group of R targets
group "rlang_4_3_0" {
  targets = [
    "rlang_base_4_3_0",
    "rlang_noteable_4_3_0",
    "rlang_datascience_4_3_0",
  ]
}

# Grouping of all base python images
group "python_base" {
  targets = [
    "python_base_3_9",
    "python_base_3_10",
    "python_base_3_11",
  ]
}

# Group of all Python 3.9 non-GPU images
group "python_3_9" {
  targets = [
    "python_base_3_9",
    "python_noteable_3_9",
    "python_datascience_3_9",
  ]
}

# Group of all Python 3.10 non-GPU images
group "python_3_10" {
  targets = [
    "python_base_3_10",
    "python_noteable_3_10",
    "python_datascience_3_10",
  ]
}

# Group of all Python 3.11 non-GPU images
group "python_3_11" {
  targets = [
    "python_base_3_11",
    "python_datascience_3_11",
  ]
}

# Gropu to build all non-GPU python images
group "python" {
  targets = [
    "python_3_9",
    "python_3_10",
    "python_3_11",
  ]
}

# Group of all Python 3.9 GPU images
group "python_3_9_gpu" {
  targets = [
    "python_base_3_9_gpu",
    "python_noteable_3_9_gpu",
    "python_datascience_3_9_gpu",
  ]
}

# Group of all Python 3.10 GPU images
group "python_3_10_gpu" {
  targets = [
    "python_base_3_10_gpu",
    "python_noteable_3_10_gpu",
    "python_datascience_3_10_gpu",
  ]
}

# Group of all Python 3.11 GPU images
group "python_3_11_gpu" {
  targets = [
    "python_base_3_11_gpu",
    "python_datascience_3_11_gpu",
  ]
}

# Group of all Python GPU images
group "python_gpu" {
  targets = [
    "python_3_9_gpu",
    "python_3_10_gpu",
    "python_3_11_gpu",
  ]
}

# Base bake template. All child kernels inherit from this.
target "base" {
  # Set standard Noteable labels, applied to all images
  labels = {
    "org.opencontainers.image.created" = "${TIMESTAMP}"
    "org.opencontainers.image.source" = "https://github.com/noteable-io/kernels"
    "org.opencontainers.image.revision" = "${GITHUB_SHA}"
    "org.opencontainers.image.vendor" = "Noteable"
    "org.opencontainers.image.version" = "${TAG}"
    "org.opencontainers.image.url" = "${BUILD_URL}"
  }
}

# Python 3.9 base image
target "python_base_3_9" {
  inherits = ["base"]
  context = "python/base/3.9"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-base:${TAG}"
  ]
}

# Python 3.10 base image
target "python_base_3_10" {
  inherits = ["base"]
  context = "python/base/3.10"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-base:${TAG}"
  ]
}

# Python 3.11 base image
target "python_base_3_11" {
  inherits = ["base"]
  context = "python/base/3.11"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.11-base:${TAG}"
  ]
}

# Python 3.9 GPU image
target "python_base_3_9_gpu" {
  context = "python/base-gpu/3.9"
  contexts = {
    base = "target:python_base_3_9"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-base:${TAG}"
  ]
}

# Python 3.10 GPU image
target "python_base_3_10_gpu" {
  context = "python/base-gpu/3.10"
  contexts = {
    base = "target:python_base_3_10"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.10-base:${TAG}"
  ]
}

# Python 3.11 GPU image
target "python_base_3_11_gpu" {
  context = "python/base-gpu/3.11"
  contexts = {
    base = "target:python_base_3_11"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.11-base:${TAG}"
  ]
}

# Python 3.9 Noteable variant
target "python_noteable_3_9" {
  context = "python/noteable/3.9"
  contexts = {
    base = "target:python_datascience_3_9"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-noteable:${TAG}"
  ]
}

# Python 3.10 Noteable variant
target "python_noteable_3_10" {
  context = "python/noteable/3.10"
  contexts = {
    base = "target:python_datascience_3_10"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-noteable:${TAG}"
  ]
}

# Python 3.9 GPU Noteable variant
target "python_noteable_3_9_gpu" {
  context = "python/noteable/3.9"
  contexts = {
    base = "target:python_datascience_3_9_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-noteable:${TAG}"
  ]
}

# Python 3.10 GPU Noteable variant
target "python_noteable_3_10_gpu" {
  context = "python/noteable/3.10"
  contexts = {
    base = "target:python_datascience_3_10_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.10-noteable:${TAG}"
  ]
}

# Python 3.9 Datascience variant
target "python_datascience_3_9" {
  context = "python/datascience/3.9"
  contexts = {
    base = "target:python_base_3_9"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-datascience:${TAG}"
  ]
}

# Python 3.10 Datascience variant
target "python_datascience_3_10" {
  context = "python/datascience/3.10"
  contexts = {
    base = "target:python_base_3_10"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-datascience:${TAG}"
  ]
}

# Python 3.11 Datascience variant
target "python_datascience_3_11" {
  context = "python/datascience/3.11"
  contexts = {
    base = "target:python_base_3_11"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.11-datascience:${TAG}"
  ]
}

# Python 3.9 GPU Datascience variant
target "python_datascience_3_9_gpu" {
  context = "python/datascience/3.9"
  contexts = {
    base = "target:python_base_3_9_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-datascience:${TAG}"
  ]
}

# Python 3.10 GPU Datascience variant
target "python_datascience_3_10_gpu" {
  context = "python/datascience/3.10"
  contexts = {
    base = "target:python_base_3_10_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.10-datascience:${TAG}"
  ]
}

# Python 3.11 GPU Datascience variant
target "python_datascience_3_11_gpu" {
  context = "python/datascience/3.11"
  contexts = {
    base = "target:python_base_3_11_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.11-datascience:${TAG}"
  ]
}

# Base R 4.3.0 image
target "rlang_base_4_3_0" {
  inherits = ["base"]
  context = "r/base/4.3.0"
  tags = [
    "ghcr.io/noteable-io/kernel-r-4.3.0-base:${TAG}"
  ]
}

# R 4.3.0 Datascience variant
target "rlang_datascience_4_3_0" {
  context = "r/datascience/4.3.0"
  contexts = {
    base = "target:rlang_base_4_3_0"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-r-4.3.0-datascience:${TAG}"
  ]
}

# R 4.3.0 Noteable variant
target "rlang_noteable_4_3_0" {
  context = "r/noteable/4.3.0"
  contexts = {
    base = "target:rlang_datascience_4_3_0"
  }
  target = "main"
  tags = [
    "ghcr.io/noteable-io/kernel-r-4.3.0-noteable:${TAG}"
  ]
}

# Base Rust 1.70 image
target "rust_base_1_70_0" {
  inherits = ["base"]
  context = "rust/base/1.70"
  tags = [
    "ghcr.io/noteable-io/kernel-rust-1.70-base:${TAG}"
  ]
}
