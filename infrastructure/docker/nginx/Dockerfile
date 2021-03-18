FROM nginx:1.17.8-alpine as dev

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

COPY infrastructure/docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY infrastructure/docker/nginx/nginx.conf /etc/nginx/nginx.conf

# expose port 80
EXPOSE 80

# run nginx
CMD ["/bin/sh", "-c", "envsubst '$KEYCLOAK_REALM_URL' < /etc/nginx/ontop.conf.template > /etc/nginx/ontop.conf && nginx -g 'daemon off;'"]

FROM dev as prod
COPY infrastructure/docker/nginx/ontop.conf.template /etc/nginx/ontop.conf.template
