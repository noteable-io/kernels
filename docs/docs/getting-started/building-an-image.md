---
sidebar_position: 3
title: Build a Kernel
---

After making any required modifications to your kernel, the project uses
```shell
docker buildx bake
```

to build the various Docker images. Each kernel can be targeted specifically,
or if needed, any of the configured groups of images can be built together

## Supported Build Targets
| Bake Target | Language | Version | Notes                 |
|---|---|---|---|
| `python_3_9` | Python | 3.9 | CPU |
| `python_3_10` | Python | 3.10 | CPU |
| `python_3_9_gpu` | Python | 3.9 | GPU |
| `python_3_10_gpu` | Python | 3.10 | GPU |
| `rlang_4_3_0` | R | 4.3.0 | CPU |

## Building a Kernel

Once necessary files have been copied, `bake` can be executed. This will build
the requested target, and any required parent images

#### Python
```
task python:base:copy-files NBL_PYTHON_VERSION=<python_version> IDENTIFIER=base # or base-gpu for GPU images
task python:noteable:copy-files NBL_PYTHON_VERSION=<python_version> IDENTIFIER=base
docker buildx bake ${target}
```

#### R
```
task r:base:copy-files NBL_LANGUAGE_VERSION=<R version>
docker buildx bake ${target}
```
