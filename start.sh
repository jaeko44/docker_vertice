#!/bin/bash

while read Iface Destination Gateway Flags RefCnt Use Metric Mask MTU Window IRTT; do
		[ "$Mask" = "00000000" ] && \
		interface="$Iface" && \
		ipaddr=$(LC_ALL=C /sbin/ip -4 addr list dev "$interface" scope global) && \
		ipaddr=${ipaddr#* inet } && \
		ipaddr=${ipaddr%%/*} && \
		break
done < /proc/net/route

   echo "[program:vertice]" >> /etc/supervisor/conf.d/vertice.conf && \
   echo "environment = MEGAM_HOME='/var/lib/megam'" >> /etc/supervisor/conf.d/vertice.conf && \
   echo "command=/usr/share/megam/vertice/bin/vertice -v start" >> /etc/supervisor/conf.d/vertice.conf && \
   echo "[program:nsqd]" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "command=/usr/share/megam/nsqd/bin/nsqd  --lookupd-tcp-address=$ipaddr:4160 -data-path=/var/lib/megam/nsqd" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "[program:nsqadmin]" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "command=/usr/share/megam/nsqd/bin/nsqadmin --lookupd-http-address=$ipaddr:4161" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "[program:nsqlookupd]" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "command=/usr/share/megam/nsqd/bin/nsqlookupd" >> /etc/supervisor/conf.d/nsq.conf && \
   echo "[program:gateway]" >> /etc/supervisor/conf.d/gateway.conf && \
   echo "command=/usr/share/megam/verticegateway/bin/verticegateway -Dlogger.file=/var/lib/megam/verticegateway/logger.xml -Dconfig.file=/var/lib/megam/verticegateway/gateway.conf" >> /etc/supervisor/conf.d/gateway.conf

ln -s /etc/supervisor/supervisord.conf /etc/supervisord.conf

service supervisor start
while true; do sleep 1d; done
