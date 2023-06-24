#!/bin/bash
set -eu

echo $(cat ../.token) | docker login ghcr.io -u $(cat ../.user) --password-stdin &>/dev/null

AVERSION=$(docker run --rm alpine:latest cat /etc/os-release | grep VERSION_ID | cut -f2 -d"=")
UVERSION=$(docker run --rm ubuntu:latest cat /etc/os-release | grep VERSION_ID | cut -f2 -d"=" | cut -f2 -d"\"")

echo "Updating Alpine Base: v$AVERSION"
docker build --force-rm --rm --tag ghcr.io/agpsn/alpine-base:latest --tag ghcr.io/agpsn/alpine-base:$AVERSION --tag ghcr.io/agpsn/alpine-base:alpine-latest -f ./Dockerfile.alpine .
git tag -f $AVERSION && git push --quiet origin $AVERSION -f --tags
git add . && git commit -am "Updated" && git push --quiet
docker push --quiet ghcr.io/agpsn/alpine-base:latest
docker push --quiet ghcr.io/agpsn/alpine-base:$AVERSION && docker image rm ghcr.io/agpsn/alpine-base:$AVERSION
docker push --quiet ghcr.io/agpsn/alpine-base:alpine-latest && docker image rm ghcr.io/agpsn/alpine-base:alpine-latest
echo ""

echo "Updating Ubuntu Base: v$UVERSION"
docker build --force-rm --rm --tag ghcr.io/agpsn/ubuntu-base:latest --tag ghcr.io/agpsn/ubuntu-base:$UVERSION --tag ghcr.io/agpsn/ubuntu-base:ubuntu-latest -f ./Dockerfile.ubuntu .
git tag -f $UVERSION && git push --quiet origin $UVERSION -f --tags
git add . && git commit -am "Updated" && git push --quiet
docker push --quiet ghcr.io/agpsn/ubuntu-base:latest
docker push --quiet ghcr.io/agpsn/ubuntu-base:$UVERSION && docker image rm ghcr.io/agpsn/ubuntu-base:$UVERSION
docker push --quiet ghcr.io/agpsn/ubuntu-base:ubuntu-latest && docker image rm ghcr.io/agpsn/ubuntu-base:ubuntu-latest
echo ""
