FROM acalabs/crystal-alpine as builder

ARG HEALTHCHECK_VERSION="0.1.1"

# Build healthcheck util
RUN wget -qO - https://github.com/aca-labs/rethinkdb-health/archive/v${HEALTHCHECK_VERSION}.tar.gz \
    | tar -xz \
    && mv /rethinkdb-health-${HEALTHCHECK_VERSION} /rethinkdb-health

RUN cd rethinkdb-health && shards install --production && crystal build ./src/rethinkdb-health.cr

FROM alpine:3.10

# Add healthcheck util to RethinkDB container
COPY --from=builder /rethinkdb-health/rethinkdb-health /bin/

RUN apk add --no-cache rethinkdb=2.3.6-r10 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main

VOLUME ["/data"]
WORKDIR /data

HEALTHCHECK CMD rethinkdb-health
CMD ["rethinkdb", "--bind", "all"]

#      process cluster ui
EXPOSE 28015   29015   8080
