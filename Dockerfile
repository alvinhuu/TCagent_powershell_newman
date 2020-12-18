FROM jetbrains/teamcity-agent:latest
USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
      apt-get -y install sudo

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

CMD /bin/bash

RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN apt-add-repository https://packages.microsoft.com/ubuntu/20.04/prod

RUN apt-get update

RUN ACCEPT_EULA=Y apt-get install -y powershell

RUN apt-get install curl build-essential checkinstall libssl-dev --assume-yes

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

ENV NODE_VERSION=14.15.1

RUN apt-get update && \
       apt-get install wget curl ca-certificates rsync -y

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" &&  nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/node /usr/bin/
RUN cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm /usr/bin/
RUN /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm install -g newman@beta --unsafe-perm

RUN apt-get update && \
    apt-get install git -y \
 && rm -rf /var/lib/apt/lists/*

RUN /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm install -g  newman-reporter-teamcity newman-reporter-htmlextra

CMD [ "newman", "-v" ]


