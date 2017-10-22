FROM ubuntu:16.04
MAINTAINER DET-IO PTy. Ltd. <hello@virtengine.com>

ENV DEB_VERSION 1.5.2
ENV RELEASE stable
ENV DEBIAN_FRONTEND noninteractive
ENV REPO_URL https://get.virtengine.com/repo/$DEB_VERSION/ubuntu/16.04/$RELEASE xenial $RELEASE

RUN buildDeps=' \
         virtengine nsqd virtenginegateway virtenginenilavu\
      ' \
     set -x \
     && apt-get update \
     && apt-get -y install software-properties-common  git nano supervisor apt-transport-https wget  apt-utils  ca-certificates netcat-openbsd \
     && apt-add-repository "deb [arch=amd64] $REPO_URL" \
     && apt-get update \
     && apt-get install -y openjdk-8-jre-headless \
     && apt-get -y --allow-unauthenticated install $buildDeps

EXPOSE 80 8080 7777 4150 4151 4160 4161 4171 9000

COPY start.sh  /
CMD  ["/start.sh"]
