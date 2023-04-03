#icu-libs mediainfo nano p7zip python3 sed sqlite-libs tar tree unzip wget xz
#FROM alpine:latest
#ARG S6_VERSION=3.1.4.1
#ARG S6_ARCH=x86_64
#ENV APP_DIR="/app" CONFIG_DIR="/config" PUID="1000" PGID="1000" UMASK="022" TZ="ETC/UTC" ARGS="" XDG_CONFIG_HOME="${CONFIG_DIR}/.config" XDG_CACHE_HOME="${CONFIG_DIR}/.cache" XDG_DATA_HOME="${CONFIG_DIR}/.local/share" LANG="C.UTF-8" LC_ALL="C.UTF-8" S6_BEHAVIOUR_IF_STAGE2_FAILS=2 PS1="$(whoami)@$(hostname):$(pwd)\\$ "
#RUN  set -xe && apk update && apk add --no-cache bash ca-certificates chromaprint coreutils curl expat findutils ffmpeg flac git gdbm gobject-introspection grep gst-plugins-good gstreamer icu-libs iputils jpeg jq lame libffi libpng libssl3 libxml2 libxslt mediainfo mpg123 nano openjpeg par2cmdline p7zip python3 sed shadow sqlite-libs tar tree tzdata unzip wget xz && apk upgrade --no-cache && mkdir "${APP_DIR}" && useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false agpsn && usermod -G users agpsn && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar -Jxpf - -C /
#RUN  set -xe && apk update && apk add --no-cache bash ca-certificates coreutils curl findutils grep icu-libs iputils jq libxml2 libxslt mediainfo nano p7zip python3 sed shadow sqlite-libs tar tree tzdata unzip wget xz && apk upgrade --no-cache && mkdir "${APP_DIR}" && useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false agpsn && usermod -G users agpsn && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar -Jxpf - -C /

#LABEL org.opencontainers.image.source=https://github.com/agpsn/base
#VOLUME ["${CONFIG_DIR}"]
#ENTRYPOINT ["/init"]


#####---#####
#FROM alpine:3.16 as rootfs-stage
#ENV REL=v3.17 ARCH=x86_64 MIRROR=http://dl-cdn.alpinelinux.org/alpine PACKAGES=alpine-baselayout,alpine-keys,apk-tools,busybox,libc-utils,xz
#RUN apk add --no-cache bash curl tzdata xz
#RUN curl -o /mkimage-alpine.bash -L https://raw.githubusercontent.com/gliderlabs/docker-alpine/master/builder/scripts/mkimage-alpine.bash && chmod +x /mkimage-alpine.bash && ./mkimage-alpine.bash  && mkdir /root-out && tar xf /rootfs.tar.xz -C /root-out && sed -i -e 's/^root::/root:!:/' /root-out/etc/shadow
#ARG S6_OVERLAY_VERSION="3.1.4.2"
#ARG S6_OVERLAY_ARCH="x86_64"
#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
#RUN tar -C /root-out -Jxpf /tmp/s6-overlay-noarch.tar.xz
#RUN tar -C /root-out -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz
#RUN tar -C /root-out -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
#RUN tar -C /root-out -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz
#FROM scratch
#COPY --from=rootfs-stage /root-out/ /
#ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " HOME="/root" TERM="xterm" S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" S6_VERBOSITY=1
#RUN set -xe && apk update && apk add --no-cache alpine-release bash ca-certificates coreutils curl jq procps shadow tzdata && apk upgrade --no-cache && mkdir /app /config /defaults && useradd -u 1000 -U -d /config -s /bin/false agpsn && usermod -G users agpsn
#COPY root/ /
#ENTRYPOINT ["/init"]


FROM alpine:latest

ARG S6_VERSION=3.1.4.2
ARG S6_ARCH=x86_64

ENV APP_DIR="/app" CONFIG_DIR="/config" PUID="1000" PGID="1000" UMASK="022" TZ="ETC/UTC" XDG_CONFIG_HOME="${CONFIG_DIR}/.config" XDG_CACHE_HOME="${CONFIG_DIR}/.cache" XDG_DATA_HOME="${CONFIG_DIR}/.local/share" LANG="C.UTF-8" LC_ALL="C.UTF-8" S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN set -xe && apk update && apk upgrade --no-cache 
#apk add --no-cache coreutils curl shadow tzdata xz 
#mkdir "${APP_DIR}" 
#useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false agpsn 
#usermod -G users agpsn 
#curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar -Jxpf - -C /
#curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -Jxpf - -C /
#curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar -Jxpf - -C /
#curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar -Jxpf - -C /
	
LABEL org.opencontainers.image.source=https://github.com/agpsn/base

VOLUME ["${CONFIG_DIR}"]

ENTRYPOINT ["/init"]

