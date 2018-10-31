# jenkins-dind
This project contain 2 parts of Jenkins 

```
jenkins-dind
jenkins-ssh-slave
```


### jenkins-dind
A Jenkins container can mount docker daemon and run docker inside by sudo

It's has sudo permission, it can use for running docker inside of this Jenkins container by mount docker daemon.
Base on official jenkins/jenkins:alpine-lts images

```bash
docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
            -v ${DOCKER}:/usr/bin/docker \
            -p 8080:8080 -p 50000:50000 -p 9917:9917 \
            --name jenkins-master --rm terrych0u/jenkins-dind:alpine-lts-2.138.2
```

### jenkins-ssh-slave
This image prodive ssh with docker in docker as Jenkins slave.

it's a Docker In Docker version (you can use Docker inside) based on official Docker 18.09 DinD image, and use master connects this slave by ssh tunnel as below :

```bash
PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub)
docker run -d  --rm terrych0u/jenkins-ssh-slave:18.09-rc-dind "${PUBLIC_KEY}"
```

### Notice
PS. This image have sudo privilege, use it carefully. **Don't use it on production.**


---
### Ref
[Docker in Docker](https://github.com/jpetazzo/dind)
[Running Docker in Jenkins Container](https://container-solutions.com/running-docker-in-jenkins-in-docker/)