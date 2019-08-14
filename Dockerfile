FROM alpine:3.10

RUN apk add --no-cache rethinkdb --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main

VOLUME ["/data"]
WORKDIR /data

CMD ["rethinkdb", "--bind", "all"]

#      process cluster ui
EXPOSE 28015   29015   8080
