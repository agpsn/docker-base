#!/bin/bash
set -eu

echo $(cat ../.token) | docker login ghcr.io -u $(cat ../.user) --password-stdin &>/dev/null

AVERSION=$(docker run --rm alpine cat /etc/os-release | grep VERSION_ID | cut -f2 -d"=")

echo "Updating Base: v$AVERSION"

docker build --quiet --force-rm --rm --tag ghcr.io/agpsn/docker-base:alpine --tag ghcr.io/agpsn/docker-base:latest .
git tag -f $AVERSION && git push --quiet origin $AVERSION -f --tags
git add . && git commit -am "Updated" && git push --quiet
docker push --quiet ghcr.io/agpsn/docker-base:alpine
docker push --quiet ghcr.io/agpsn/docker-base:latest && docker image rm --quiet ghcr.io/agpsn/docker-base:latest
echo ""
