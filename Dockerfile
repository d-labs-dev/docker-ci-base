FROM docker:1.12

MAINTAINER Leo Schweizer <leonhard.schweizer@gmail.com>

ADD aws-ecr-cleanup /usr/bin/aws-ecr-cleanup

ENV RANCHER_COMPOSE_VERSION 0.12.0
ENV RANCHER_CLI_VERSION 0.4.0

RUN \
  mkdir -p /srv/rancher && \
  wget -q -O /tmp/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz https://releases.rancher.com/compose/v$RANCHER_COMPOSE_VERSION/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
  tar -zxvf /tmp/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz -C /tmp && \
  rm -f /tmp/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
  mv /tmp/rancher-compose-v$RANCHER_COMPOSE_VERSION/rancher-compose /srv/rancher/rancher-compose && \
  ln -s /srv/rancher/rancher-compose /usr/bin/rancher-compose

RUN \
  mkdir -p /srv/rancher && \
  wget -q -O /tmp/rancher-cli-linux-amd64-v$RANCHER_CLI_VERSION.gz https://releases.rancher.com/cli/v$RANCHER_CLI_VERSION/binaries/linux-amd64/rancher.gz && \
  gunzip /tmp/rancher-cli-linux-amd64-v$RANCHER_CLI_VERSION.gz && \
  rm -f /tmp/rancher-cli-linux-amd64-v$RANCHER_CLI_VERSION.gz && \
  mv /tmp/rancher-cli-linux-amd64-v$RANCHER_CLI_VERSION /srv/rancher/rancher && \
  chmod +x /srv/rancher/rancher && \
  ln -s /srv/rancher/rancher /usr/bin/rancher

RUN apk add --update \
    python \
    py-pip \
  && pip install awscli \
