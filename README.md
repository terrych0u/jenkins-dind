# jenkins-dind
This project is for quick build an Jenkins lab environment on local laptop, to help learning Jenkins, and it contain 2 parts： 

```
jenkins-dind
jenkins-ssh-slave
```

### How to use

You use `make help` command to understand how to setup in your local environment laptop quickly.

you can setup standalone mode or master-slave mode by `make` command.

```
build-master                   Build the customized docker images for jenkins master
build-slave                    Build the customized docker images for jenkins slave with ssh
build                          Build the customized docker images for jenkins master and slave
clean-all                      Stop the jenkins docker containers and clean all related data, images...etc
clean                          Stop the jenkins docker containers
dir-slave                      Create directory for jenkins-slave containers mount, help to backup file to local.
dir                            Create directory for jenkins-master or single jenkins containers mount, help to backup file to local.
help                           List targets & descriptions
master-slave                   Run master + slave mode for jenkins
run                            Run standalone jenkins
slave                          Run a slave jenkins
```


### jenkins-dind
A Jenkins container can mount docker daemon and run docker inside by sudo

It's has sudo permission, it can use for running docker inside of this Jenkins container by mount docker daemon.
Base on official jenkins/jenkins:alpine-lts images

```bash
docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(which docker):/usr/bin/docker \
            -p 8080:8080 -p 50000:50000 -p 9917:9917 \
            --name jenkins-master --rm terrych0u/jenkins-dind:alpine-lts-2.138.2
```

### jenkins-ssh-slave
This image provide ssh with docker in docker as Jenkins slave.

it's a Docker In Docker version (you can use Docker inside) based on official Docker 18.09 DinD image, and use master connects this slave by ssh tunnel as below :

```bash
PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub)
docker run -d  --rm terrych0u/jenkins-ssh-slave:18.09-rc-dind "${PUBLIC_KEY}"
```

### Notice
PS. This image have sudo privilege, use it carefully. **Don't use it on production.**


### To Do
1. docker-compose.
2. an scripts can help setup node into master by api, without any UI control.

---
### Ref
[Docker in Docker](https://github.com/jpetazzo/dind)
[Running Docker in Jenkins Container](https://container-solutions.com/running-docker-in-jenkins-in-docker/)
