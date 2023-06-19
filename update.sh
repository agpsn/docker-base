#!/bin/bash
set -eu

echo $(cat ../.token) | docker login ghcr.io -u $(cat ../.user) --password-stdin &>/dev/null

echo "Updating Base"

docker build --quiet --force-rm --rm --tag ghcr.io/agpsn/docker-base:alpine .
git add . && git commit -am "Updated" && git push --quiet
docker push --quiet ghcr.io/agpsn/docker-base:alpine

echo ""
