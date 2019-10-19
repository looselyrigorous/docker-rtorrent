FROM alpine:3.10
LABEL maintainer="looselyrigorous <looselyrigorous@gmail.com>"
ARG BUILD_CORES

# Install rtorrent and su-exec
# Create necessary folders
# Forward Info & Error logs to std{out,err} (à la nginx)a
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    git \
    libtool \
    automake \
    autoconf \
    wget \
    tar \
    xz \
    zlib-dev \
    cppunit-dev \
    openssl-dev \
    binutils \
    linux-headers \
    ca-certificates \
    curl \
    openssl \
    gzip \
    zip \
    zlib \
 && apk add \
    su-exec \
    rtorrent \
 && cd /tmp \
 && git clone https://github.com/mirror/xmlrpc-c.git \
 && cd /tmp/xmlrpc-c/advanced && ./configure && make -j ${NB_CORES} && make install \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/* \
 && mkdir -p \
      /dist \
      /config \
      /session \
      /socket \
      /watch/load \
      /watch/start \
      /downloads && \
    ln -sf /dev/stdout /var/log/rtorrent-info.log && \
    ln -sf /dev/stderr /var/log/rtorrent-error.log

VOLUME ["/config", "/session", "/socket", "/watch", "/downloads"]

# Copy distribution rTorrent config for bootstrapping and entrypoint
COPY ./root /

ENTRYPOINT ["/entrypoint"]

CMD ["rtorrent", "-n", "-o", "import=/config/.rtorrent.rc"]
