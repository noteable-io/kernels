variable "TAG" {
  default = "latest"
}

variable "GITHUB_SHA" {
  default = ""
}

variable "BUILD_URL" {
  default = ""
}

variable "TIMESTAMP" {
  default = ""
}

group "default" {
  targets = [
    "rlang",
    "python",
#    "python_gpu"
  ]
}
group "rlang_4_3_0" {
  targets = [
    "rlang_base_4_3_0",
    "rlang_noteable_4_3_0"
  ]
}

group "python_base" {
  targets = [
    "python_base_3_9",
    "python_base_3_10",
    "python_base_3_11",
  ]
}

group "python_3_9" {
  targets = [
    "python_base_3_9",
    "python_noteable_3_9",
    "python_datascience_3_9",
  ]
}

group "python_3_10" {
  targets = [
    "python_base_3_10",
    "python_noteable_3_10",
    "python_datascience_3_10",
  ]
}

group "python_3_11" {
  targets = [
    "python_base_3_11",
    "python_datascience_3_11",
  ]
}
group "python" {
  targets = [
    "python_base_3_9",
    "python_base_3_10",
    "python_base_3_11",
    "python_noteable_3_9",
    "python_noteable_3_10",
    "python_datascience_3_9",
    "python_datascience_3_10",
    "python_datascience_3_11",
  ]
}

group "python_gpu" {
  targets = [
    "python_base_3_9_gpu",
    "python_base_3_10_gpu",
    "python_base_3_11_gpu",
    "python_noteable_3_9_gpu",
    "python_noteable_3_10_gpu",
    "python_datascience_3_9_gpu",
    "python_datascience_3_10_gpu",
    "python_datascience_3_11_gpu",
  ]
}

target "base" {
  labels = {
    "org.opencontainers.image.created" = ""
    "org.opencontainers.image.source" = "https://github.com/noteable-io/kernels"
    "org.opencontainers.image.revision" = "${GITHUB_SHA}"
    "org.opencontainers.image.vendor" = "Noteable"
    "org.opencontainers.image.version" = "${TAG}"
    "org.opencontainers.image.url" = ""
  }
}

target "python_base_3_9" {
  inherits = ["base"]
  context = "python/base/3.9"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-base:${TAG}"
  ]
}

target "python_base_3_10" {
  inherits = ["base"]
  context = "python/base/3.10"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-base:${TAG}"
  ]
}

target "python_base_3_11" {
  inherits = ["base"]
  context = "python/base/3.11"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.11-base:${TAG}"
  ]
}

target "python_base_3_9_gpu" {
  context = "python/base-gpu/3.9"
  contexts = {
    base = "target:python_base_3_9"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-base:${TAG}"
  ]
}

target "python_base_3_10_gpu" {
  context = "python/base-gpu/3.10"
  contexts = {
    base = "target:python_base_3_10"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.10-base:${TAG}"
  ]
}

target "python_base_3_11_gpu" {
  context = "python/base-gpu/3.11"
  contexts = {
    base = "target:python_base_3_11"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.11-base:${TAG}"
  ]
}

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

target "python_noteable_3_9_gpu" {
  context = "python/noteable-gpu/3.9"
  contexts = {
    base = "target:python_datascience_3_9_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-noteable:${TAG}"
  ]
}

target "python_noteable_3_10_gpu" {
  context = "python/noteable-gpu/3.10"
  contexts = {
    base = "target:python_datascience_3_10_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.10-noteable:${TAG}"
  ]
}

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

target "python_datascience_3_9_gpu" {
  context = "python/datascience-gpu/3.9"
  contexts = {
    base = "target:python_base_3_9_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-datascience:${TAG}"
  ]
}

target "python_datascience_3_10_gpu" {
  context = "python/datascience-gpu/3.10"
  contexts = {
    base = "target:python_base_3_10_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.10-datascience:${TAG}"
  ]
}

target "python_datascience_3_11_gpu" {
  context = "python/datascience-gpu/3.11"
  contexts = {
    base = "target:python_base_3_11_gpu"
  }
  target = "gpu"
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.11-datascience:${TAG}"
  ]
}

target "rlang_base_4_3_0" {
  inherits = ["base"]
  context = "R/base/4.3.0"
  tags = [
    "ghcr.io/noteable-io/kernel-r-4.3.0:${TAG}"
  ]
}

target "rlang_noteable_4_3" {
  context = "R/noteable/4.3.0"
  contexts = {
    base = "target:rlang_base_4_3_0"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-r-4.3.0-noteable:${TAG}"
  ]
}
