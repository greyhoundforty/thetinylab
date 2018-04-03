#!/usr/bin/env bash

DOCKERTAG=$(date +%Y%m%d)
IBM_REGISTRY_NAMESPACE="rtiffany"
WRKDIR="$HOME/Repositories/Personal/thetinylab"

cd "$WRKDIR"

rm -rf _site 

jekyll build -d _site

#rm -f deployment.yml
#cp base-deployment.yml deployment.yml

#docker login -u "$DOCKER_HUB_USERNAME" -p "$DOCKER_HUB_PASSWORD"

docker build -t registry.ng.bluemix.net/${IBM_REGISTRY_NAMESPACE}/blogtinylab:${DOCKERTAG} .

docker push registry.ng.bluemix.net/${IBM_REGISTRY_NAMESPACE}/blogtinylab:${DOCKERTAG}

#sed -i -e "s|NEWTAG|$DOCKERTAG|g" deployment.yml

#bash ./deploy.sh

kubectl set image deploy/blogtinylab-app blogtinylab-app=registry.ng.bluemix.net/${IBM_REGISTRY_NAMESPACE}/blogtinylab:${DOCKERTAG}