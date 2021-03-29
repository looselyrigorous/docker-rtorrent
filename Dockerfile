FROM alpine:3.13
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

# Copy distribution rTorrent config for bootstrapping and entrypoint
COPY ./root /

ENTRYPOINT ["/entrypoint"]

CMD ["rtorrent", "-n", "-o", "import=/config/.rtorrent.rc"]
