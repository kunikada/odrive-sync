FROM python:slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN od=/root/.odrive-agent/bin \
  && curl -L https://dl.odrive.com/odrive-py --create-dirs -o $od/odrive.py \
  && curl -L https://dl.odrive.com/odriveagent-lnx-64 | tar -xvzf- -C $od/ \
  && curl -L https://dl.odrive.com/odrivecli-lnx-64 | tar -xvzf- -C $od/

COPY sync.sh .

HEALTHCHECK --interval=10m \
            --timeout=10m \
            --start-period=10m \
            --retries=1 \
  CMD /bin/bash sync.sh || exit 1

ENTRYPOINT /root/.odrive-agent/bin/odriveagent
