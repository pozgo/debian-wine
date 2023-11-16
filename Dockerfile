FROM debian:12.2

LABEL maintainer="Polinux"

ENV TIMEZONE=Europe/Warsaw \
    DEBIAN_FRONTEND=noninteractive \
    PUID=0 \
    PGID=0 \
    WINEPREFIX=/wine

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        procps && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        apt-transport-https \
        gnupg2 && \
    wget https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    rm winehq.key && \
    echo "deb https://dl.winehq.org/wine-builds/debian/ bookworm main" >> /etc/apt/sources.list.d/winehq.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        winehq-stable && \
    apt-get remove -y --purge software-properties-common \
        apt-transport-https \
        gnupg2 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]