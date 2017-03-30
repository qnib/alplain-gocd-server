#!/bin/bash

mkdir -p /opt/go-server/config/
if [[ ! -f /opt/go-server/config/cruise-config.xml ]];then
  cat /opt/qnib/gocd/server/etc/cruise-config.xml \
    |sed -e "s/GOCD_AGENT_AUTOENABLE_KEY/${GOCD_AGENT_AUTOENABLE_KEY}/" \
    > /opt/go-server/config/cruise-config.xml
fi
