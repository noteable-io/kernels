---
sidebar_position: 2
title: Project Structure
---

### Directories

```
- /
 - /${language} # The language of the kernel (python, R, rust, etc)
    - /${identifier} # Kernel "type" (base, base-gpu, databricks, spark, etc)
        - /$(version) # If applicable, the version of the language being used
 - /docs # Docusaurus site (you're here!)
```

For some of the existing kernels, this looks like
```
- /
  - /R
    - /base
      - /4.3.0
  - /python
    - /base
      - /3.9
      - /3.10
```

If we were to add a new language, such as Rust @ `1.70.0`:
```
- /
  - /rust
    - /base
      - /1.70.0 # Add a new rust/base directory, then seed the initial version
```

To add an additional Python version, such as `3.11`:
```
- /
  - /python
    - /base
      - /3.9
      - /3.10
      - /3.11 # We just add a new subdirectory
```

Note, that when adding kernel directories, `/docker-bake.hcl` will also need to be
configured to build the new targets

### GPU Variants

For kernels that need GPU packages, a `-gpu` sibling is created for each language’s **base** image.
Any further child kernels can inherit from this base image, and simply install any additional packages.
This allows us to share common system level packages for GPU enablement, while also reducing build times
for kernels that inherit from it

### Checklist

To standardize the design of Noteable kernels, the following requirements must be met before the new kernel spec
can be approved:

- All images for a specific language must be built off of that language's base image
- Base images must be able to start and run their entrypoint
- The resulting image must run as the `noteable` user (or `4004:4004`)
- The home directory for the user must be `/home/noteable`
- The entrypoint must be located at `/usr/local/bin/run.sh`
