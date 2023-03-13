# Noteable kernels

This project manages the kernels available for the Noteable platform. 

## Project Structure

Any kernels that are built for Noteable, are placed under `/kernels`. Each directory 
coincides with a single Docker context, which is build in Github Actions

## Tagging 

Any built images are tagged with the name of the kernel. i.e. 
- `/kernels/python` gets tagged as `ghcr.io/noteable-io/kernels/python:$tag`

All built kernels, should be tagged with the following
- `${python_version}-${{ github.sha }}` for all builds 
- `${python_version}-latest` for the most recent sha on main
