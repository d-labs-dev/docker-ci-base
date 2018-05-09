FROM docker:18.02

MAINTAINER Leo Schweizer <leonhard.schweizer@gmail.com>

ENV RANCHER_COMPOSE_VERSION 0.12.5
ENV RANCHER_CLI_VERSION 0.6.7
ENV GIT_LFS_VERSION 2.3.4
ENV CF_CLI_VERSION 6.36.1

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

RUN apk add --update --no-cache \
    git \
    python \
    py-pip \
  && pip install awscli \
  && wget -q -O - 'https://cli.run.pivotal.io/stable?release=linux64-binary&version='${CF_CLI_VERSION} \
    | tar -xzf - -C /usr/local/bin

RUN wget -q -O /tmp/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz https://github.com/github/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-amd64-${GIT_LFS_VERSION}.tar.gz && \
    tar -xzf /tmp/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz -C /tmp && \
    mv /tmp/git-lfs-${GIT_LFS_VERSION}/git-lfs /usr/bin/ && \
    git-lfs install && \
    rm -rf /tmp/git-lfs-${GIT_LFS_VERSION}/git-lfs && \
    rm -rf /tmp/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz

ADD aws-ecr-cleanup /usr/bin/aws-ecr-cleanup
