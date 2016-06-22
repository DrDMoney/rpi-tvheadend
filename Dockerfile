FROM resin/rpi-raspbian

MAINTAINER Sebastien LAPORTE

RUN apt-get update && \
    apt-get install -y  nano \
                        git \
                        openssl \
                        build-essential \
                        python-dev \
                        libssl-dev \
                        pkg-config \
                        gettext \
                        liburiparser-dev \
                        libnss-mdns \
                        bzip2 \
                        wget \
                        cmake \
                        ca-certificates
                        
RUN apt-get install -m -y wget git curl make dkms dpkg-dev \
    debconf-utils software-properties-common \
    build-essential hdhomerun-config libhdhomerun-dev debhelper libswscale-dev \
    libavahi-client-dev libavformat-dev libavcodec-dev liburiparser-dev \
    libssl-dev libiconv-hook1 libiconv-hook-dev

# Compile tvheadend from master
RUN cd /tmp && \
    git clone https://github.com/tvheadend/tvheadend.git && \
    cd /tmp/tvheadend && \
    ./configure --libffmpeg_static && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/tvheadend

RUN apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean

# Config directory, should be persisted
VOLUME ["/config"]

# Records directory, for video recorder and timeshift
VOLUME ["/records"]

# HTTP port (web interface)
EXPOSE 9981

# HTSP port (stream)
EXPOSE 9982

ENTRYPOINT ["/usr/local/bin/tvheadend"]

CMD ["-c", "/config", "-C"]
