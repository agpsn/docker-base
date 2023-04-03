

#####
#####
#FROM ghcr.io/agpsn/base:latest
#ARG SBRANCH="main"
#ARG SVERSION
#RUN set -xe && \
#	echo "***** update system packages *****" apk upgrade --no-cache && \
#	echo "***** install build packages *****" && apk add --no-cache --virtual=build-dependencies jq && \
#	echo "***** install runtime packages *****" && 
#apk add --no-cache xmlstarlet curl && 
#apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/main tinyxml2 && 
#apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/community libmediainfo && 
#	echo "***** install sonarr *****" && if [ -z ${SVERSION+x} ]; then SVERSION=$(curl -sX GET http://services.sonarr.tv/v1/releases | jq -r "first(.[] | select(.branch==\"$SBRANCH\") | .version)"); fi && mkdir -p "${APP_DIR}/sonarr/bin" && cutl -o /tmp/sonarr.tar.gz -L "https://download.sonarr.tv/v4/${SBRANCH}/${SVERSION}/Sonarr.${SBRANCH}.${SVERSION}.linux-musl-x64.tar.gz" && tar xzf /tmp/sonarr.tar.gz -C "${APP_DIR}/sonarr/bin" --strip-components=1 && printf "UpdateMethod=docker\nBranch=${SBRANCH}\nPackageVersion=${SVERSION}\nPackageAuthor=[agpsn](https://github.com/agpsn/sonarr/tree/develop)\n" >"${APP_DIR}/sonarr/package_info" && \
#	echo "***** cleanup sonarr *****" && find "${APP_DIR}/bin" -name '*.mdb' -delete && rm -rf "${APP_DIR}/bin/Sonarr.Update" && \
#	echo "***** cleanup *****" && apk del --purge build-dependencies && rm -rf /tmp/* && cert-sync /etc/ssl/certs/ca-certificates.crt && \
#	echo "***** setting version *****" && echo $SVERSION > "${APP_DIR}/sonarr/app_version"
# add local files
#COPY root/ /
# healthcheck
#HEALTHCHECK  --interval=30s --timeout=30s --start-period=10s --retries=5 CMD curl --fail http://localhost:8989 || exit 1
# label
#LABEL org.opencontainers.image.source=https://github.com/agpsn/sonarr/tree/latest
# ports and volumes
#EXPOSE 8989
#VOLUME "${CONFIG_DIR}"

#####---#####---#####
FROM alpine:latest
ARG S6_VERSION=3.1.4.1
ARG S6_ARCH=x86_64
ENV APP_DIR="/app" CONFIG_DIR="/config" PUID="1000" PGID="1000" UMASK="022" TZ="ETC/UTC" ARGS="" XDG_CONFIG_HOME="${CONFIG_DIR}/.config" XDG_CACHE_HOME="${CONFIG_DIR}/.cache" XDG_DATA_HOME="${CONFIG_DIR}/.local/share" LANG="C.UTF-8" LC_ALL="C.UTF-8" S6_BEHAVIOUR_IF_STAGE2_FAILS=2
RUN  set -xe && \
	apk update && apk add --no-cache xz tzdata shadow bash curl wget jq grep sed coreutils findutils python3 unzip p7zip tar ca-certificates && apk upgrade --no-cache && \
	mkdir "${APP_DIR}" && useradd -u 1000 -U -d "${CONFIG_DIR}" -s /bin/false agpsn && usermod -G users agpsn && \
	curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz" | tar -Jxpf - -C / && \
	curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -Jxpf - -C /
LABEL org.opencontainers.image.source=https://github.com/agpsn/base
VOLUME ["${CONFIG_DIR}"]
ENTRYPOINT ["/init"]
