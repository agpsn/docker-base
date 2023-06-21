FROM alpine:latest

ARG S6_VERSION=3.1.5.0
ARG S6_ARCH=x86_64

ENV APP_DIR="/app" CONFIG_DIR="/config" PUID="1000" PGID="1000" UMASK="022" TZ="ETC/UTC" XDG_CONFIG_HOME="${CONFIG_DIR}/.config" XDG_CACHE_HOME="${CONFIG_DIR}/.cache" XDG_DATA_HOME="${CONFIG_DIR}/.local/share" LANG="C.UTF-8" LC_ALL="C.UTF-8" S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN set -xe && apk update && apk upgrade --no-cache && apk add --no-cache bash ca-certificates coreutils curl findutils grep jq mediainfo nano p7zip python3 sed shadow sqlite-libs tree tzdata unzip wget xz zip && mkdir "${APP_DIR}" && useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false agpsn && usermod -G users agpsn && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar -Jxpf - -C / && curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar -Jxpf - -C /

LABEL org.opencontainers.image.source="https://github.com/agpsn/docker-base"

VOLUME ["${CONFIG_DIR}"]

ENTRYPOINT ["/init"]
