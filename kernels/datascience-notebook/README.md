# Multitenant Python Image

Entrypoint is used to implement signal-based interrupts, since `ipykernel` does not support message-based interupts.

## Building Locally
You'll need to provide a git credential string located at `${HOME}/.git-credentials`:

```shell
echo "${GITHUB_USER_NAME}:${GITHUB_PERSONAL_ACCESS_TOKEN}" > ${HOME}/.git-credentials
```

The [personal access token](https://github.com/settings/tokens) needs to have
the `read:packages, repo` scope (and make sure to enable SSO on it).

```shell
# Optional step to help you auto-load your built docker container into minikube for use with Gate
eval $(minikube docker-env)

DOCKER_BUILDKIT=1 docker build --secret "id=git-credentials,src=${HOME}/.git-credentials" -t local/noteable-python:latest .
```
