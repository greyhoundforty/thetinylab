#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
WRKDIR="$HOME/Repositories/Personal/thetinylab"

kubectl apply -f deployment.yml

#kubectl set image deploy/blogtinylab blogtinylab=${DOCKER_HUB_USERNAME}/blogtinylab:1 --namespace=dev

