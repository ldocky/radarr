FROM ubuntu:focal
MAINTAINER ldocky

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg ca-certificates wget curl

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
apt-get update
RUN wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-13_all.deb && \
dpkg -i repo-mediaarea_1.0-13_all.deb && \
apt-get update && \
rm -rf repo-mediaarea_1.0-13_all.deb

RUN curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) && \
tar -xvzf Radarr.develop.*.linux.tar.gz && \
mv Radarr /opt

RUN apt-get autoremove -y && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
EXPOSE 7878
VOLUME /config

CMD ["mono", "--debug", "./opt/Radarr/Radarr.exe", "--nobrowser", "--data=/config"]
