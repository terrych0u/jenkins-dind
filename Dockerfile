FROM jenkins/jenkins:lts-alpine
LABEL MAINTAINER="Terry Chou <tequilas721@gmail.com>"

ARG user=jenkins

USER root
RUN apk update --no-cache \
    && apk add sudo curl --no-cache \
    && rm -rf /var/cache/apk/* \
    && echo "%${USER} ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt