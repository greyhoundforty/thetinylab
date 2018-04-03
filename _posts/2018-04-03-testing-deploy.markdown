---
layout: post
title:  "From PaaS to hyper.sh"
date:   2018-04-03 10:18:00
categories: hyper paas
---

I was looking to get an old site up and running again recently and decided that instead of setting up a brand new VM, customizing it just so, and then running [Ghost](https://ghost.org/) or [Hugo](http://gohugo.io/) I would instead take a look at [Hyper.sh](https://hyper.sh/).  Hyper.sh provides hosted container applications with per second billing and a pretty nice free tier for kicking the tires. Since most everything else in my life was moving towards containerization I figured one more Dockerfile really wouldn't kill me. 

I decided on [jekyll](https://jekyllrb.com/), one of the grandfathers of static site generators, for one main reason: I am trying to learn ruby. With the decisions of a site generator and hosting provider solved I moved on to how to deploy my new site. I learned long ago to keep projects in Github when I wanted a reliable way to roll back any bad updates.  With this in mind I decided to make use of a Github post-commit hook to generate my site with Jekyll, build and publish the associated Dockerfile and use `hyper.sh` to host the site. When I make a commit to my sites repository the `post-commit` hook calls a `deploy.sh` file that takes care of all of this for me. 

### post-commit hook

```
#!/usr/bin/env bash

blogdir="$HOME/Repos/greyhoundfortydotcom"
logfile="$HOME/Repos/greyhoundfortydotcom/deploylog.txt"

cd "$blogdir"
bash deploy.sh >>"$logfile" 2>&1

git push
```  

### deploy.sh script

```
#!/usr/bin/env bash

docker login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_PASSWORD"
app=hyperjekyll
apphome='$HOME/Repos/greyhoundfortydotcom'

if [[ $(hyper ps -q --filter "name=$app" | grep -q . && echo running) = "running" ]]; then
	hyper stop "$app"
	hyper rm "$app"
fi

cd "$apphome"
rm -rf _site
mkdir _site

bundle install
bundle exec jekyll build -q -d _site

docker build -t hyperjekyll .
docker tag hyperjekyll greyhoundforty/hyperjekyll
docker push greyhoundforty/hyperjekyll

hyper pull greyhoundforty/hyperjekyll
hyper run -d --name=hyperjekyll -p 80:80 greyhoundforty/hyperjekyll
hyper fip attach greyhoundforty hyperjekyll

for i in $(hyper images -f "dangling=true" -q); do hyper rmi "$i";done
```


**The deployment script does the following:**
* Logs me in to dockerhub (in case I have rebooted the system)
* Uses the hyper CLI to kill the existing instance of my site (if one is running)
* Changes to the sites local repository location and removes the previously generated content
* Builds the jekyll site and outputs the HTML to the `_site` directory
* Builds a simple [Dockerfile](https://github.com/greyhoundforty/greyhoundfortydotcom/blob/master/Dockerfile)  and pushes it to [Docker Hub](https://hub.docker.com)
* Use the hyper CLI to pull the updated container image
* Runs the container image and exposes port 80
* Attaches the [Floating IP](https://docs.hyper.sh/Feature/network/fip.html) labeled `greyhoundforty` to the container running the site. 
* Uses the hyper CLI to kill off any old images. 
