#!/bin/bash
: ${GOCD_ENV_KEY:=generic}
set -e


mkdir -p /etc/go/
if [[ -f /opt/qnib/gocd/gocd-config.tar ]];then
  echo ">> tar xf /opt/qnib/gocd/gocd-config.tar -C /etc/go/"
  tar xf /opt/qnib/gocd/gocd-config.tar -C /etc/go/
elif [[ -f /opt/qnib/gocd/cruise-config.xml ]];then
  echo ">> Found /opt/qnib/gocd/cruise-config.xml, will replace /etc/go/cruise-config.xml"
  rm -f /etc/go/cruise-config.xml
  cp /opt/qnib/gocd/cruise-config.xml /etc/go/cruise-config.xml
  chmod 640 /etc/go/cruise-config.xml
elif [[ -f /opt/qnib/gocd/server/etc/cruise-config.xml ]];then
  echo ">> Found template '/opt/qnib/gocd/server/etc/cruise-config.xml', will render /etc/go/cruise-config.xml"
  cat /opt/qnib/gocd/server/etc/cruise-config.xml \
    |sed -e "s/GOCD_AGENT_AUTOENABLE_KEY/${GOCD_AGENT_AUTOENABLE_KEY}/" \
    > /etc/go/cruise-config.xml
fi

## Adjust config
if [[ "X${DOCKER_REG}" != "X" ]];then
  xmlstarlet ed -u \
      "/cruise/environments/environment[@name='${GOCD_ENV_KEY}']/environmentvariables/variable[@name='DOCKER_REG']/value" \
      -v ${DOCKER_REG} /etc/go/cruise-config.xml |sponge /etc/go/cruise-config.xml
fi
if [[ "X${DOCKER_REGISTRY}" != "X" ]];then
  xmlstarlet ed -u \
      "/cruise/environments/environment[@name='${GOCD_ENV_KEY}']/environmentvariables/variable[@name='DOCKER_REGISTRY']/value" \
      -v ${DOCKER_REGISTRY} /etc/go/cruise-config.xml |sponge /etc/go/cruise-config.xml
fi
if [[ "X${UCP_USER}" != "X" ]];then
  xmlstarlet ed -u \
      "/cruise/environments/environment[@name='${GOCD_ENV_KEY}']/environmentvariables/variable[@name='UCP_USER']/value" \
      -v ${UCP_USER} /etc/go/cruise-config.xml |sponge /etc/go/cruise-config.xml
fi
if [[ "X${FROM_IMG_REGISTRY}" != "X" ]];then
  xmlstarlet ed -u \
      "/cruise/environments/environment[@name='${GOCD_ENV_KEY}']/environmentvariables/variable[@name='FROM_IMG_REGISTRY']/value" \
      -v ${FROM_IMG_REGISTRY} /etc/go/cruise-config.xml |sponge /etc/go/cruise-config.xml
fi



if [[ "X${ENTRY_USER}" != "X" ]];then
    chown -R ${ENTRY_USER}: /etc/go/
fi
