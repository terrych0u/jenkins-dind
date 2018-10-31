#!/usr/bin/env bash

VERSION=$1

if [ -z "$VERSION" ];
    echo "Please check parameters"
    echo "Example： $0 1.1.1"
fi

cd $(dirname $0)

docker build -t terrych0u/jenkins-dind .

docker tag terrych0u/jenkins-dind:latest terrych0u/jenkins-dind:alpine-lts-${VERSION}

docker push terrych0u/jenkins-dind:alpine-lts-${VERSION}