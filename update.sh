#!/bin/bash
set -eu
[ ! -d "/mnt/user/system/agpsn-github/docker-base" ] && echo "No repo!" && exit 1

cd "/mnt/user/system/agpsn-github/docker-base"
echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null
	GBRANCH=$(git branch | grep "*" | rev | cut -f1 -d" " | rev)
	echo "Updating Base [$GBRANCH]"
	docker build --quiet --force-rm --rm --tag ghcr.io/agpsn/docker-base:alpine .
	git add . && git commit -am "Updated" && git push --quiet
	docker push ghcr.io/agpsn/docker-base:alpine
