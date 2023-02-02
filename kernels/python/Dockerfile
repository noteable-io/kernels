# syntax = docker/dockerfile:1.2.1
FROM jupyter/datascience-notebook:python-3.9.6

USER root

# Set up log file for magics
RUN touch /var/log/noteable_magics.log && \
  chown 4004:4004 /var/log/noteable_magics.log

# When image is run, run the code with the environment
# activated:
SHELL ["/bin/bash", "-c"]

WORKDIR /tmp

# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
  apt-get install -y jq procps git g++ \
  && rm -rf /var/lib/apt/lists/*

ENV NB_USER="noteable" \
  NB_UID=4004 \
  NB_GID=4004

# Create the default unprivileged user
RUN groupadd --gid 4004 noteable && \
  useradd --uid 4004 --shell /bin/false --create-home --no-log-init --gid noteable noteable && \
  chown --recursive noteable:noteable /home/noteable

RUN mkdir /etc/ipython && chown noteable:noteable /etc/ipython
RUN mkdir -p /etc/noteable && chown noteable:noteable /etc/noteable

RUN chown noteable:noteable "${JULIA_PKGDIR}" && \
  chown noteable:noteable "${CONDA_DIR}" && \
  fix-permissions "${JULIA_PKGDIR}" && \
  fix-permissions "${CONDA_DIR}"

# Run non-privileged user
USER noteable

ENV PATH="/home/noteable/.local/bin:${PATH}" \
  HOME="/home/noteable" \
  XDG_CACHE_HOME="/home/noteable/.cache/" \
  GOOGLE_APPLICATION_CREDENTIALS="/vault/secrets/gcp-credentials"

# hadolint ignore=DL3045
COPY environment.txt ./

# hadolint ignore=SC2034
RUN conda install --file environment.txt

# hadolint ignore=DL3045
COPY requirements.txt ./
RUN pip install -I --quiet --no-cache-dir -r requirements.txt

# Enable the widgets nbextension
# hadolint ignore=SC1008
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Smoke test to ensure packages were installed properly
# hadolint ignore=SC1008
RUN python -c "import noteable_magics"

RUN git config --global user.name "Noteable Kernel" && \
  git config --global user.email "engineering@noteable.io"

# https://ipython.readthedocs.io/en/stable/config/intro.html#systemwide-configuration
COPY ipython_config.py /etc/ipython

# Set standard working directory for noteable project
WORKDIR /etc/noteable/project

# Add the entrypoint script to the $PATH
COPY entrypoint.sh /usr/local/bin
COPY secrets_helper.py /tmp/secrets_helper.py

EXPOSE 50001-50005

ENTRYPOINT ["entrypoint.sh"]
