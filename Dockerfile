FROM jenkins/jenkins:2.273-slim

ARG user=jenkins

ENV DEBIAN_FRONTEND noninteractive

ARG DOCKER_CLI_VERSION=19.03.8
ARG DOCKER_HOST_GID=999

USER root

# install prerequirement tools, and upgrade
RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends gnupg apt-utils apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

# install docker client
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz | tar -xz -C /tmp \
  && mv /tmp/docker/docker /usr/local/bin \
  && rm -r /tmp/docker*

RUN groupadd -g ${DOCKER_HOST_GID} docker
RUN usermod -aG docker jenkins

# link japanese font in java
RUN mkdir -p ${JAVA_HOME}/jre/lib/fonts/fallback \
    && ln -s /usr/share/fonts/truetype/vlgothic/VL-PGothic-Regular.ttf ${JAVA_HOME}/jre/lib/fonts/fallback

# set timezone to JST
RUN rm -f /etc/localtime \
    && echo "Asia/Tokyo" > /etc/timezone \
    && dpkg-reconfigure tzdata

# install jenkins plugin
USER ${user}
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN cat /usr/share/jenkins/plugins.txt | xargs /usr/local/bin/install-plugins.sh