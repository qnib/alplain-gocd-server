#!/bin/bash

TAR_FILE=${2:-gocd-config.tar}
CNT_ID=${1}
if [[ "X${CNT_ID}" == "X" ]];then
   echo "usage: $0 <container_id> [output-file]"
   ID=$(docker ps -qf label=com.docker.swarm.service.name=gocd_server)
   if [[ "X${ID}" != "X" ]];then
     echo -n "> found service gocd_server ID (${ID}), should we go ahead with it? (Y/n) "
     read GO
     if [[ "${GO}" == "n" ]];then
       echo "BYE!"
       exit 0
     fi
   fi
   CNT_ID=${ID}
fi

echo ">> create archive within container"
docker exec -t ${CNT_ID} tar cf /tmp/${TAR_FILE} --exclude=password.properties -C /etc/go/ -v .
echo ">> copy archive to local filesystem"
docker cp ${CNT_ID}:/tmp/${TAR_FILE} .
echo ">> rm archive within container"
docker exec -t ${CNT_ID} rm -f /tmp/${TAR_FILE}
