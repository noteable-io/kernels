variable "TAG" {
  default = "latest"
}

group "rlang" {
  targets = [
    "rlang_base_4_3"
  ]
}

group "python_base" {
  targets = [
    "python_base_3_9",
    "python_base_3_10",
    "python_base_3_11",
  ]
}

group "python" {
  targets = [
    "python_noteable_3_9",
    "python_noteable_3_10",
#    "python_noteable_3_11",
    "python_datascience_3_9",
    "python_datascience_3_10",
#    "python_datascience_3_11",
  ]
}

group "python_gpu" {
  targets = [
    "python_base_3_9_gpu",
    "python_base_3_10_gpu",
    "python_base_3_11_gpu",
    "python_noteable_3_9_gpu",
#    "python_noteable_3_10_gpu",
#    "python_noteable_3_11_gpu",
    "python_datascience_3_9_gpu",
#    "python_datascience_3_10_gpu",
#    "python_datascience_3_11_gpu",
  ]
}

target "python_base_3_9" {
  context = "python/base/3.9"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-base:${TAG}"
  ]
}

target "python_base_3_10" {
  context = "python/base/3.10"
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-base:${TAG}"
  ]
}

target "python_base_3_11" {
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
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-noteable:${TAG}"
  ]
}

target "python_noteable_3_10" {
  context = "python/noteable/3.10"
  contexts = {
    base = "target:python_datascience_3_10"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-noteable:${TAG}"
  ]
}

target "python_noteable_3_11" {
  context = "python/noteable/3.11"
  contexts = {
    base = "target:python_datascience_3_11"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.11-noteable:${TAG}"
  ]
}

target "python_noteable_3_9_gpu" {
  context = "python/noteable-gpu/3.9"
  contexts = {
    base = "target:python_datascience_3_9_gpu"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-noteable:${TAG}"
  ]
}

#target "python_noteable_3_10_gpu" {
#  context = "python/noteable-gpu/3.10"
#  contexts = {
#    base = "target:python_datascience_3_10_gpu"
#  }
#  tags = [
#    "ghcr.io/noteable-io/kernel-gpu-python-3.10-noteable:${TAG}"
#  ]
#}
#
#target "python_noteable_3_11_gpu" {
#  context = "python/noteable-gpu/3.11"
#  contexts = {
#    base = "target:python_datascience_3_11_gpu"
#  }
#  tags = [
#    "ghcr.io/noteable-io/kernel-gpu-python-3.11-noteable:${TAG}"
#  ]
#}

target "python_datascience_3_9" {
  context = "python/datascience/3.9"
  contexts = {
    base = "target:python_base_3_9"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.9-datascience:${TAG}"
  ]
}

target "python_datascience_3_10" {
  context = "python/datascience/3.10"
  contexts = {
    base = "target:python_base_3_10"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.10-datascience:${TAG}"
  ]
}

target "python_datascience_3_11" {
  context = "python/datascience/3.11"
  contexts = {
    base = "target:python_base_3_11"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-python-3.11-datascience:${TAG}"
  ]
}

target "python_datascience_3_9_gpu" {
  context = "python/datascience-gpu/3.9"
  contexts = {
    base = "target:python_base_3_9_gpu"
  }
  tags = [
    "ghcr.io/noteable-io/kernel-gpu-python-3.9-datascience:${TAG}"
  ]
}
#
#target "python_datascience_3_10_gpu" {
#  context = "python/datascience-gpu/3.10"
#  contexts = {
#    base = "target:python_base_3_10_gpu"
#  }
#  tags = [
#    "ghcr.io/noteable-io/kernel-gpu-python-3.10-datascience:${TAG}"
#  ]
#}
#
#target "python_datascience_3_11_gpu" {
#  context = "python/datascience-gpu/3.11"
#  contexts = {
#    base = "target:python_base_3_11_gpu"
#  }
#  tags = [
#    "ghcr.io/noteable-io/kernel-gpu-python-3.11-datascience:${TAG}"
#  ]
#}

target "rlang_base_4_3" {
  context = "R/base/4.3.0"
}


