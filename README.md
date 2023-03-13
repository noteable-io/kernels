# Noteable kernels

This project manages the kernels available for the Noteable platform. 

## Project Structure

Any kernels that are built for Noteable, are placed under `/kernels`. Each directory 
coincides with a single Docker context, which is build in Github Actions

## Tagging 

Any built images are tagged with the name of the kernel. i.e. 
- `/kernels/python` gets tagged as `ghcr.io/noteable-io/kernels/python:$tag`

If a kernel supports builds against multiple python versions, they are tagged with 
`${python_version}-${sha}`. Kernels that build against a single Python version are tagged  only with `${sha}`