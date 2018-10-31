#!/usr/bin/env bash

VERSION=$1
DIRECTORY=$2

if [ -z "$VERSION" ] || [ -z "$DIRECTORY" ];
    echo "Please check parameters"
    echo "Example： $0 1.1.1 /opt/xxx/xxx"
fi

docker run -d -v  ${DIRECTORY}:/var/jenkins_home \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(which docker):/usr/bin/docker \
            -p 8080:8080 -p 50000:50000 -p 9917:9917 \
            --name jenkins --rm terrych0u/jenkins-dind:alpine-lts-${VERSION}


