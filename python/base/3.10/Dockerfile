# syntax = docker/dockerfile:1.4
# ---
# Bare minimum Python 3.x.x image with ipykernel installed
# - no Python packages aside from builtins and ipykernel
# - no git, secrets, SQL, extensions, etc
# ---
ARG NBL_PYTHON_VERSION=3.10
FROM python:${NBL_PYTHON_VERSION}-slim-bullseye as base

# User/group setup
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
  --home-dir /srv/noteable && \
  chown --recursive noteable:noteable /srv/noteable && \
  mkdir /opt/venv && chown noteable:noteable /opt/venv && \
  mkdir /etc/ipython && chown noteable:noteable /etc/ipython && \
  mkdir -p /etc/noteable && chown noteable:noteable /etc/noteable

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

ENV HOME="/srv/noteable" \
  PYTHONPATH="/srv/noteable/.local/lib/python${NBL_PYTHON_VERSION}/site-packages:${PYTHONPATH}" \
  XDG_CACHE_HOME="/srv/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

WORKDIR /etc/noteable/project
EXPOSE 50001-50005

ENTRYPOINT ["/tini", "-g", "--"]
CMD ["run.sh"]
