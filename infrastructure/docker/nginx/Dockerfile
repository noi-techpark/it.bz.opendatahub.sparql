FROM nginx:1.17.8-alpine

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

COPY infrastructure/docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# expose port 80
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]