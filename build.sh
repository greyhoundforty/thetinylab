#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
REGISTRYURL="registry.ng.bluemix.net/rtiffany"
WRKDIR="$HOME/Repositories/Personal/thetinylab"

cd "$WRKDIR"

rm -rf _site 

jekyll build -d _site

bx login -a api.ng.bluemix.net -o "CDE TEAM" -s coolkids -g CDE
bx cr login 

docker build -t ${REGISTRYURL}/blogtinylab:${DOCKERTAG} .

docker push ${REGISTRYURL}/blogtinylab:${DOCKERTAG}
