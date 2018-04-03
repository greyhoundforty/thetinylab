#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
REGISTRYURL="registry.ng.bluemix.net/rtiffany"

kubectl set image deploy/blogtinylab blogtinylab=${REGISTRYURL}/blogtinylab:${DOCKERTAG} --namespace=dev

