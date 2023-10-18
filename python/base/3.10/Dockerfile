# syntax = docker/dockerfile:1.5
# ---
# Bare minimum Python 3.x.x image with ipykernel installed
# - no Python packages aside from builtins and ipykernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_PYTHON_VERSION=3.10
FROM python:${NBL_PYTHON_VERSION}-slim-bullseye as base

# User/group setup
ARG NBL_HOME_DIR=/var/run/noteable

USER root

ENV NB_USER="noteable" \
  NB_UID=4004 \
  NB_GID=4004

RUN groupadd --gid 4004 noteable && \
  useradd --uid 4004 \
  --shell /bin/false \
  --create-home \
  --no-log-init \
  --gid noteable noteable \
  --home-dir "${NBL_HOME_DIR}" && \
  chown --recursive noteable:noteable "${NBL_HOME_DIR}" && \
  mkdir /opt/venv && chown noteable:noteable /opt/venv && \
  mkdir /etc/ipython && chown noteable:noteable /etc/ipython

# TEMPORARY: symlink the previous /etc/noteable to the new NBL_HOME_DIR (/var/run/noteable) dir
# until all other services are migrated and the old /etc/noteable can be removed
RUN ln -s "${NBL_HOME_DIR}" /etc/noteable

WORKDIR /tmp

# Install tini to manage passing signals to the child kernel process
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY apt-install /usr/bin/
COPY Aptfile .
RUN /usr/bin/apt-install Aptfile

USER noteable

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp/base_requirements.txt
RUN pip install --no-cache-dir -r /tmp/base_requirements.txt

COPY secrets_helper.sh /tmp/secrets_helper.sh
COPY run.sh /usr/local/bin

ENV HOME="${NBL_HOME_DIR}" \
  PYTHONPATH="${NBL_HOME_DIR}/.local/lib/python${NBL_PYTHON_VERSION}/site-packages:${PYTHONPATH}" \
  XDG_CACHE_HOME="${NBL_HOME_DIR}/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

WORKDIR ${NBL_HOME_DIR}/project
EXPOSE 50001-50005

ENTRYPOINT ["/tini", "-g", "--"]
CMD ["run.sh"]
