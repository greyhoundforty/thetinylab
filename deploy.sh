#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
DOCKER_HUB_USERNAME="greyhoundforty"

kubectl set image deploy/blogtinylab blogtinylab=${DOCKER_HUB_USERNAME}/blogtinylab:1 --namespace=dev

