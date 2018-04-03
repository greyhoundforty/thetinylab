FROM nginx:alpine

RUN apk add --update \
    wget \
    git \
    ca-certificates

ADD _site/ /usr/share/nginx/html/

CMD nginx -g "daemon off;"    