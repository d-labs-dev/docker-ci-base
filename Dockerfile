FROM gitlab/dind:latest

MAINTAINER Leo Schweizer <leonhard.schweizer@gmail.com>

ENV RANCHER_COMPOSE_VERSION 0.8.1

RUN \
  mkdir -p /srv/rancher && \
  wget -q -O /tmp/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz https://releases.rancher.com/compose/v$RANCHER_COMPOSE_VERSION/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
  tar -zxvf /tmp/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz -C /tmp && \
  rm -f /tmp/rancher-compose-linux-amd64-v$RANCHER_COMPOSE_VERSION.tar.gz && \
  mv /tmp/rancher-compose-v$RANCHER_COMPOSE_VERSION/rancher-compose /srv/rancher/rancher-compose && \
  ln -s /srv/rancher/rancher-compose /usr/bin/rancher-compose

RUN \
  apt-get update && \
  apt-get install -y python2.7 python-pip && \
  pip install awscli
