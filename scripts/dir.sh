#!/usr/bin/env bash

MASTER_DIR=${HOME}/Documents/jenkins_home
SLAVE_DIR=${HOME}/Documents/jenkins_slave_home


case "$1" in
        master)
            DIRECTORY=${MASTER_DIR}
            ;;
        slave)
            DIRECTORY=${SLAVE_DIR}
            ;;
        *)
            DIRECTORY=${MASTER_DIR}
esac


if [ ! -d "${DIRECTORY}" ]; then
    mkdir -p ${DIRECTORY}
fi