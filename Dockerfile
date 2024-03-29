FROM jetbrains/teamcity-agent
LABEL maintainer "Jacek Kleczkowski <jacek@ksoft.biz>"

# image is based on Ubuntu 15 - fix for .NET Core installation
RUN apt-get install wget -y && \
    wget http://launchpadlibrarian.net/201330288/libicu52_52.1-8_amd64.deb && \
    dpkg -i libicu52_52.1-8_amd64.deb

# install .NET Core
RUN sh -c 'echo "deb [arch=amd64] http://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893 && \
    apt-get update && \
    apt-get install mc -y && \
    apt-get upgrade -y

# install .NET Core
ENV DOTNET_VER "dotnet-dev-2.0.0-preview1-005977"
#(apt-cache search dotnet-dev-2.0.0 | awk '{print $1}') | sh 
RUN apt-get install ${DOTNET_VER} -y

# install mono-devel
RUN apt-get install mono-devel mono-xbuild libmono-addins-* -y 
    
# install web tools which are required for "dotnet publish" command
RUN apt-get install npm -y && \
    npm install npm -g && \
    npm install bower gulp -g

VOLUME /opt/buildagent/work
VOLUME /opt/buildagent/logs
VOLUME /data/teamcity_agent/conf
VOLUME /opt/buildagent/plugins

ENV DOCKER_HOST ""
ENV DOCKER_BIN "/usr/bin/docker"
