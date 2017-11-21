FROM docker:17.10

MAINTAINER Leo Schweizer <leonhard.schweizer@gmail.com>

ENV GCLOUD_SDK_VERSION=180.0.1
ENV GIT_LFS_VERSION 1.5.5

RUN apk add --update \
    git \
    python \
    py-pip \
    curl \
    openssl \
  && pip install awscli

RUN \
  mkdir /opt && cd /opt && \
  wget -q -O - https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz |tar zxf - && \
  CLOUDSDK_CORE_DISABLE_PROMPTS=1 /opt/google-cloud-sdk/install.sh && \
  ln -s  /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud && \
  gcloud components install kubectl && \
  rm -rf /opt/google-cloud-sdk/.install/.backup

RUN wget -q -O /tmp/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz https://github.com/github/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-amd64-${GIT_LFS_VERSION}.tar.gz && \
    tar -xzf /tmp/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz -C /tmp && \
    mv /tmp/git-lfs-${GIT_LFS_VERSION}/git-lfs /usr/bin/ && \
    git-lfs install && \
    rm -rf /tmp/git-lfs-${GIT_LFS_VERSION}/git-lfs && \
    rm -rf /tmp/git-lfs-linux-amd64-v${GIT_LFS_VERSION}.tar.gz

ADD aws-ecr-cleanup /usr/bin/aws-ecr-cleanup
