FROM ontop/ontop-endpoint:4.1-snapshot

RUN apk add --update curl && \
    apk add --no-cache postgresql-client

RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /wait-for-it.sh
RUN chmod u+x /wait-for-it.sh
