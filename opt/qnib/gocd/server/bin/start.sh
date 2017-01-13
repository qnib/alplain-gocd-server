#!/bin/bash

if [ "X${GOCD_SERVER_CLEAN_WORKSPACE}" == "Xtrue" ];then
    rm -f /opt/go-server/config/*
fi

if [ ! -f /opt/go-server/config/cruise-config.xml ];then
    consul-template -once -template "/etc/consul-templates/gocd/server/cruise-config.xml.ctmpl:/opt/go-server/config/cruise-config.xml"
fi

/opt/go-server/server.sh 
