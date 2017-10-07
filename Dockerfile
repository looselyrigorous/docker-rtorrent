FROM alpine:3.6
LABEL maintainer="looselyrigorous <looselyrigorous@gmail.com>"

# Install rtorrent and su-exec
# Create necessary folders
# Forward Info & Error logs to std{out,err} (à la nginx)
RUN apk add --no-cache \
      rtorrent \
      su-exec && \
    mkdir -p \
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

# Ports for DHT, incoming connections
EXPOSE 49160/udp 49161/tcp 49161/udp

# Copy distribution rTorrent config for bootstrapping and entrypoint
COPY ./root /

CMD ["/init"]