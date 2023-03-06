# Multitenant Python Image

Entrypoint is used to implement signal-based interrupts, since `ipykernel` does not support message-based interupts.

## Building Locally

```shell
# Optional step to help you auto-load your built docker container into minikube for use with Gate
eval $(minikube docker-env)

DOCKER_BUILDKIT=1 docker build -t local/python3-generic:latest .
```
