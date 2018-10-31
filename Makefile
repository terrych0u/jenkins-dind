
MASTER_IMAGE := "terrych0u/jenkins-dind"
MASTER_VERSION := "alpine-lts-2.138.2"

SLAVE_IMAGE := "terrych0u/jenkins-ssh-slave"
SLAVE_VERSION := "18.09-rc-dind"

DIRECTORY := "${HOME}/Documents/jenkins_home"
MASTER_DIR := ${HOME}/Documents/jenkins_home
SLAVE_DIR := ${HOME}/Documents/jenkins_slave_home

DOCKER := $(shell which docker)
DOCKER_LISTS := $(shell docker ps -a | awk '{print $$1}' | tail -n +2)
DOCKER_VOLUME := $(shell docker volume ls | awk '{print $$2}' | tail -n +2)
DOCKER_IMAGES_LISTS := $(shell docker images | awk '{print $$3}' | tail -n +2)

PUBLIC_KEY := $(shell cat ${HOME}/.ssh/id_rsa.pub)


help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: dir
dir: ## create directory for jenkins-master or single jenkins containers mount, help to backup file to local.
	@sh scripts/dir.sh master



.PHONY: dir-slave
dir-slave: ## create directory for jenkins-slave containers mount, help to backup file to local.
	@sh scripts/dir.sh slave



.PHONY: build
build: ## create the customized docker images for jenkins master and slave
	@cd $(dirname $0)
	@docker build -t ${MASTER_IMAGE} .
	@docker tag ${MASTER_IMAGE}:latest ${MASTER_IMAGE}:${MASTER_VERSION}
	@docker push ${MASTER_IMAGE}:${MASTER_VERSION}
	@docker build -t ${SLAVE_IMAGE} -f Dockerfile.slave .
	@docker tag ${SLAVE_IMAGE}:latest ${SLAVE_IMAGE}:${SLAVE_VERSION}
	@docker push ${SLAVE_IMAGE}:${SLAVE_VERSION}


.PHONY: build-master
build-master: ## create the customized docker images for jenkins master 
	@cd $(dirname $0)
	@docker build -t ${MASTER_IMAGE} .
	@docker tag ${MASTER_IMAGE}:latest ${MASTER_IMAGE}:${MASTER_VERSION}
	@docker push ${MASTER_IMAGE}:${MASTER_VERSION}
	


.PHONY: build-slave
build-slave: ## create the customized docker images for jenkins slave with ssh
	@cd $(dirname $0)
	@docker build -t ${SLAVE_IMAGE} -f Dockerfile.slave .
	@docker tag ${SLAVE_IMAGE}:latest ${SLAVE_IMAGE}:${SLAVE_VERSION}
	@docker push ${SLAVE_IMAGE}:${SLAVE_VERSION}



.PHONY: master
run: dir ## run standalone jenkins
	@docker run -d -v ${MASTER_DIR}:/var/jenkins_home \
					-v /var/run/docker.sock:/var/run/docker.sock \
					-v ${DOCKER}:/usr/bin/docker \
					-p 8080:8080 -p 50000:50000 -p 9917:9917 \
					--name jenkins-master --rm ${IMAGE}:${VERSION}



.PHONY: slave
slave: dir-slave ## run a slave jenkins
	@docker run -d -v ${SLAVE_DIR}:/var/jenkins_home \
					--name jenkins-slave --rm \
					jenkinsci/ssh-slave "${PUBLIC_KEY}"



.PHONY: run
master-slave: dir dir-slave ## run master + slave mode for jenkins
	@docker run -d -v ${MASTER_DIR}:/var/jenkins_home \
					-v /var/run/docker.sock:/var/run/docker.sock \
					-v ${DOCKER}:/usr/bin/docker \
					-p 8080:8080 -p 50000:50000 -p 9917:9917 \
					--name jenkins-master --rm ${IMAGE}:${VERSION}

	@docker run -d -v ${SLAVE_DIR}:/var/jenkins_home \
					--name jenkins-slave --rm \
					jenkinsci/ssh-slave "${PUBLIC_KEY}"



.PHONY: clean
clean: ## stop the jenkins docker containers
	@docker kill ${DOCKER_LISTS}


.PHONY: clean-all
clean-all: ## stop the jenkins docker containers and clean all related data, images...etc
	@docker kill ${DOCKER_LISTS}
	@docker rmi ${DOCKER_IMAGES_LISTS}
	@docker volume rm ${DOCKER_VOLUME}