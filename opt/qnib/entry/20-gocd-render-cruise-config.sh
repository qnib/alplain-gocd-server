#!/bin/bash

mkdir -p /etc/go/
if [[ -f /opt/qnib/gocd/gocd-config.tar ]];then
  tar xf /opt/qnib/gocd/gocd-config.tar -C /etc/go/
  exit 0
fi
if [[ -f /opt/qnib/gocd/cruise-config.xml ]];then
  rm -f /etc/go/cruise-config.xml
  cp /opt/qnib/gocd/cruise-config.xml /etc/go/cruise-config.xml
  chmod 640 /etc/go/cruise-config.xml
  if [[ "X${ENTRY_USER}" != "X" ]];then
    chown ${ENTRY_USER}: /etc/go/cruise-config.xml
  fi
  exit 0
fi

if [[ ! -f /etc/go/cruise-config.xml ]];then
  cat /opt/qnib/gocd/server/etc/cruise-config.xml \
    |sed -e "s/GOCD_AGENT_AUTOENABLE_KEY/${GOCD_AGENT_AUTOENABLE_KEY}/" \
    > /etc/go/cruise-config.xml
  if [[ "X${ENTRY_USER}" != "X" ]];then
    chown ${ENTRY_USER}: /etc/go/cruise-config.xml
  fi
fi
