#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
DOCKER_HUB_USERNAME="greyhoundforty"
WRKDIR="$HOME/Repositories/Personal/thetinylab"

cd "$WRKDIR"

rm -rf _site 

jekyll build -d _site

rm -f deployment.yml
cp base-deployment.yml deployment.yml

docker login -u "$DOCKER_HUB_USERNAME" -p "$DOCKER_HUB_PASSWORD"

docker build -t docker.io/${DOCKER_HUB_USERNAME}/blogtinylab:${DOCKERTAG} .

docker push docker.io/${DOCKER_HUB_USERNAME}/blogtinylab:${DOCKERTAG}

sed -i -e "s|NEWTAG|$DOCKERTAG|g" deployment.yml