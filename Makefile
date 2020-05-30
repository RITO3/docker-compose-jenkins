build:
	$(eval DOCKER_HOST_GID := $(shell cat /etc/group | grep docker | awk '{ split($$0,array,":");print array[3]}' ))
	docker build --tag private/jenkins:2.238-slim --build-arg DOCKER_HOST_GID=$(DOCKER_HOST_GID) .

start:
	mkdir -p ./volumes/jenkins_home
	docker-compose up -d

getPW:
	docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

stop:
	docker-compose down

clear:
	rm -rf ./volumes
