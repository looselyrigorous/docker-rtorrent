# rTorrent on Alpine
This is a bare-bones docker container for rTorrent.  The GUI output is locked out, instead a unix socket is exposed for you to use with a plain webserver, [ruTorrent](https://github.com/Novik/ruTorrent)/[Flood](https://github.com/jfurrow/flood) or what have you.

## Configuration

The container creates a "sane defaults" configuration that is tailored to the technicalities of docker (and this specific container). You are encouraged (but not required) to use it. You can bootstrap it to a config volume by running the container like so:  `docker run --rm -v "$(pwd)/config:/config" looselyrigorous/rtorrent`

## Running

You could use `docker` for this but I prefer compose files. Nevertheless, you can use something like this

```
docker run -itd \
	-v ./downloads:/downloads \
	-v ./session:/session \
	-v ./watch:/watch \
	-v ./config:/config \
	-v rtorrent-sock:/socket \
	-p 49161:49161 \
	-p 49161:49161/udp \
	-e PUID=1000 -e PGID=1000 \
	looselyrigorous/rtorrent:0.2
```

Look like a pain in the ass to paste and edit? Well that's because **it is**. Just use a compose file:

```yaml
version: "3"
services:
  rtorrent:
    image: looselyrigorous/rtorrent:0.2
    volumes:
      - "./downloads:/downloads"
      - "./session:/session"
      - "./watch:/watch"
      - "./config:/config"
      - "rtorrent-sock:/socket"
    ports:
      - "49161:49161"
      - "49161:49161/udp"
    environment:
      - PUID=1000
      - PGID=1000
volumes:
  rtorrent-sock: {}
```

Save it as `docker-compose.yml` . Now all you have to do is `docker-compose up -d` and you're off to the races. There are docker-compose files in the compose directory for more complete setups.

## Volumes

| Volume     | Explanation                              |
| ---------- | ---------------------------------------- |
| /downloads | Your downloads.                          |
| /session   | rTorrent specific folder. Used for persistence accross restarts |
| /watch     | Watch folder for .torrent files          |
| /config    | rTorrent configuration                   |
| /socket    | The rTorrent Unix socket                 |

## Environment Variables

Before attempting to launch the container, you should make sure that the volumes you mount are owned by the same UID/GID's you provide as env vars. The container will chown all dirs except /downloads. So just chown your Downloads folder, then set PUID and PGID accordingly, and it just works™.

## Ports

The container exposes 49160/udp for DHT and 49161/{tcp,udp} for incoming connections. DHT is disabled by default but it's fairly trivial to enable it.  The XMLRPC port is **not** enabled on rTorrent and therefore not exposed. This is a bad idea *anyway* cause it doesn't support any kind of authentication. You can instead forward requests to the socket through an nginx proxy with digest authentication.