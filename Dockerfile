FROM python:slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG userid=1000
RUN useradd -u $userid -m odrive
USER odrive

WORKDIR /home/odrive

RUN od=.odrive-agent/bin \
  && curl -L https://dl.odrive.com/odrive-py --create-dirs -o $od/odrive.py \
  && curl -L https://dl.odrive.com/odriveagent-lnx-64 | tar -xvzf- -C $od/ \
  && curl -L https://dl.odrive.com/odrivecli-lnx-64 | tar -xvzf- -C $od/

COPY --chown=odrive:odrive sync.sh .
RUN chmod +x sync.sh

HEALTHCHECK --interval=10m \
            --timeout=10m \
            --start-period=10m \
            --retries=1 \
  CMD /bin/bash sync.sh || exit 1

ENTRYPOINT .odrive-agent/bin/odriveagent
