FROM ubuntu:16.04
MAINTAINER Rowell Pica <rowellpica@gmail.com>
# Replace shell with bash so we can source files
#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "-c"]
# 1.2 Install Environments
# 1.2.1 Install dependencies
RUN apt-get update && \
  apt-get -y install git openssl libssl-dev libkrb5-dev cmake wget curl && \
  apt-get -y install build-essential sudo python vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ARG USERNAME=bcosuser
# Replace following with your user id
ARG USERID=501
# user's home dir should be mapped from EFS
RUN useradd --create-home -s /bin/bash --no-user-group -u $USERID $USERNAME && \
  adduser $USERNAME sudo && \
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN su - $USERNAME -c "touch mine"
RUN sudo apt-get update && sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:webupd8team/java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
RUN sudo apt-get update && sudo apt-get install -y oracle-java8-installer
ENV JAVA_HOME="/usr/lib/jvm/java-8-oracle"
RUN sudo mkdir -p /mydata && \
  sudo chmod 777 /mydata && \
  sudo chown -R $USERNAME /mydata
WORKDIR /mydata
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get update && sudo apt-get install -y nodejs && sudo apt-get install -y build-essential
ENV DISPLAY=":0"
USER $USERNAME
CMD ["tail", "-f", "/dev/null"]