#!/bin/bash
set -eu

echo $(cat ../.token) | docker login ghcr.io -u $(cat ../.user) --password-stdin &>/dev/null

echo "Updating Base"

#docker build --quiet --force-rm --rm --tag ghcr.io/agpsn/docker-base:alpine .
docker build --force-rm --rm --tag ghcr.io/agpsn/docker-base:alpine .

#git add . && git commit -am "Updated" && git push --quiet
git add . && git commit -am "Updated" && git push

docker push --quiet ghcr.io/agpsn/docker-base:alpine
docker push ghcr.io/agpsn/docker-base:alpine

echo ""
