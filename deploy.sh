#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
IBM_REGISTRY_NAMESPACE="rtiffany"
WRKDIR="$HOME/Repositories/Personal/thetinylab"

cd "$WRKDIR"

kubectl apply -f deployment.yml

#kubectl set image deploy/blogtinylab blogtinylab=${DOCKER_HUB_USERNAME}/blogtinylab:1 --namespace=dev

