#!/bin/bash
clear; set -eu

echo $(cat ~/.ghcr-token) | docker login ghcr.io -u $(cat ~/.ghcr-user) --password-stdin &>/dev/null

if [ $(git branch | grep "*" | rev | cut -f1 -d" " | rev) == "latest" ]; then
	GBRANCH=$(git branch | grep "*" | rev | cut -f1 -d" " | rev)
	echo "Updating Base [$GBRANCH]"
	docker build --force-rm --rm --tag ghcr.io/agpsn/base:latest --tag ghcr.io/agpsn/base:alpine .
	git add . && git commit -am "Updated" && git push --quiet
	docker push ghcr.io/agpsn/base:latest; docker push ghcr.io/agpsn/base:alpine

#	docker build --force-rm --rm --tag ghcr.io/agpsn/sonarr:develop --tag ghcr.io/agpsn/sonarr:$DVERSION .
#	git add . && git commit -am "Updated" && git push --quiet && git tag $DVERSION && git push origin $DVERSION
#	docker push ghcr.io/agpsn/sonarr:develop; docker push ghcr.io/agpsn/sonarr:$DVERSION
fi