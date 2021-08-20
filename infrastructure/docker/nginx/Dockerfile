FROM nginx:1.17.8-alpine as dev

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*



COPY infrastructure/docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY infrastructure/docker/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir /dashboard

COPY infrastructure/docker/nginx/odh-vkg-frontpage.zip /tmp
RUN cd /tmp && unzip odh-vkg-frontpage.zip -d /dashboard
RUN rm /tmp/odh-vkg-frontpage.zip
RUN cd /dashboard

# expose port 80
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]

FROM dev as prod

COPY infrastructure/docker/nginx/ontop.conf.template /etc/nginx/ontop.conf.template
COPY infrastructure/docker/nginx/index.js /www/restricted/index.js
CMD ["/bin/sh", "-c", "envsubst '$KEYCLOAK_REALM_URL' < /etc/nginx/ontop.conf.template > /etc/nginx/ontop.conf && nginx -g 'daemon off;'"]
