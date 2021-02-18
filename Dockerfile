FROM ubuntu:focal
MAINTAINER ldocky

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg ca-certificates wget curl apt-transport-https

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-13_all.deb && \
dpkg -i repo-mediaarea_1.0-13_all.deb && \
apt-get update && \
rm -rf repo-mediaarea_1.0-13_all.deb

RUN apt-get install -y mediainfo dotnet-sdk-5.0



RUN curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux-core-x64.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) && \
tar -xvzf Radarr.master.*.linux-core-x64.tar.gz && \
mv Radarr /opt

RUN apt-get autoremove -y && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
EXPOSE 7878
VOLUME /config

CMD ["./opt/Radarr/Radarr", "--nobrowser", "--data=/config"]


