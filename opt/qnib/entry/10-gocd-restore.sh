#!/bin/bash
set -e

if [[ "X${GOCD_BACKUP_RESTORE_ENABLED}" != "Xtrue" ]];then
    echo ">> GOCD_BACKUP_RESTORE_ENABLED != true -> Drop out of backup restore attempt."
    exit 0
fi



SERVER_INSTALLATION_DIR=/opt/go-server
SERVER_CONFIG_DIR=/etc/go/
SERVER_BKP_DIR=/opt/go-server/artifacts/serverBackups/

if [[ ! -d ${SERVER_BKP_DIR} ]];then
    echo ">> Missing backup directory '${SERVER_BKP_DIR}'!"
    exit 1
fi

## find latest backup
LATEST=$(ls ${SERVER_BKP_DIR} |grep ^backup |tail -n1)

if [[ "X${LATEST}" != "X" ]];then
  echo ">> Found Backup '${SERVER_BKP_DIR}/${LATEST}'"
  ## check if all files are present
  if [[ ! -f ${SERVER_BKP_DIR}/${LATEST}/db.zip ]];then
      echo ">>> did not found '${SERVER_BKP_DIR}/${LATEST}/db.zip'"
      exit 1
  fi
  if [[ ! -f ${SERVER_BKP_DIR}/${LATEST}/config-dir.zip  ]];then
      echo ">>> did not found '${SERVER_BKP_DIR}/${LATEST}/config-dir.zip'"
      exit 1
  fi
  if [[ ! -f ${SERVER_BKP_DIR}/${LATEST}/config-repo.zip  ]];then
      echo ">>> did not found '${SERVER_BKP_DIR}/${LATEST}/config-repo.zip'"
      exit 1
  fi

  ## db.zip
  mkdir -p ${SERVER_INSTALLATION_DIR}/db/h2db
  unzip -o -d ${SERVER_INSTALLATION_DIR}/db/h2db/ ${SERVER_BKP_DIR}/${LATEST}/db.zip
  ## config-dir.zip
  mkdir -p ${SERVER_CONFIG_DIR}/
  unzip -o -d ${SERVER_CONFIG_DIR}/ ${SERVER_BKP_DIR}/${LATEST}/config-dir.zip
  ## config-repo.zip
  mkdir -p ${SERVER_INSTALLATION_DIR}/db/config.git/
  unzip -o -d ${SERVER_INSTALLATION_DIR}/db/config.git/ ${SERVER_BKP_DIR}/${LATEST}/config-repo.zip
  echo ">> Finished restore"
fi
