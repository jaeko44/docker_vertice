FROM ubuntu:16.04
MAINTAINER Megam systems  <info@megam.io>

ENV DEB_VERSION 1.5.2
ENV RELEASE testing
ENV DEBIAN_FRONTEND noninteractive

ENV ONE_URL https://get.megam.io/repo/$DEB_VERSION/ubuntu/16.04/$RELEASE xenial $RELEASE

RUN buildDeps=' \
         vertice nsqd  verticegateway\
      ' \
     set -x \
     && apt-get update \
     && apt-get -y install software-properties-common  git nano supervisor apt-transport-https wget  apt-utils  ca-certificates netcat-openbsd \
     && apt-add-repository "deb [arch=amd64] $ONE_URL" \
     && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9B46B611 \
     && apt-get update \
     && apt-get install -y openjdk-8-jre-headless \
     && apt-get -y install $buildDeps

RUN echo "[program:vertice]" >> /etc/supervisor/conf.d/vertice.conf && \
    echo "environment = MEGAM_HOME='/var/lib/megam'" >> /etc/supervisor/conf.d/vertice.conf && \
    echo "command=/usr/share/megam/vertice/bin/vertice -v start" >> /etc/supervisor/conf.d/vertice.conf && \
    echo "[program:nsqd]" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "command=/usr/share/megam/nsqd/bin/nsqd  --lookupd-tcp-address=localhost:4160 -data-path=/var/lib/megam/nsqd" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "[program:nsqadmin]" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "command=/usr/share/megam/nsqd/bin/nsqadmin --lookupd-http-address=localhost:4161" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "[program:nsqlookupd]" >> /etc/supervisor/conf.d/nsq.conf && \
    echo "command=/usr/share/megam/nsqd/bin/nsqlookupd" >> /etc/supervisor/conf.d/nsq.conf \
    echo "[program:gateway]" >> /etc/supervisor/conf.d/gateway.conf && \
    echo "command=/usr/share/megam/verticegateway/bin/verticegateway -Dlogger.file=/var/lib/megam/verticegateway/logger.xml -Dconfig.file=/var/lib/megam/verticegateway/gateway.conf" >> /etc/supervisor/conf.d/gateway.conf

RUN ln -s /etc/supervisor/supervisord.conf /etc/supervisord.conf

EXPOSE 7777 4150 4151 4160 4161  4171
COPY start.sh  /

CMD  ["/start.sh"]
#CMD service supervisor start
