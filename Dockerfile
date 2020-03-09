FROM crystallang/crystal:0.33.0-alpine as builder

ARG HEALTHCHECK_VERSION="0.1.3"

# Build healthcheck util
RUN wget -qO - https://github.com/aca-labs/rethinkdb-health/archive/v${HEALTHCHECK_VERSION}.tar.gz \
    | tar -xz \
    && mv /rethinkdb-health-${HEALTHCHECK_VERSION} /rethinkdb-health

WORKDIR /rethinkdb-health

RUN shards install --production
RUN crystal build --static ./src/rethinkdb-health.cr

FROM alpine:3.11

# Add healthcheck util to RethinkDB container
COPY --from=builder /rethinkdb-health/rethinkdb-health /bin/

RUN apk add --no-cache rethinkdb

VOLUME ["/data"]
WORKDIR /data

HEALTHCHECK CMD rethinkdb-health
CMD ["rethinkdb", "--bind", "all"]

#      process cluster ui
EXPOSE 28015   29015   8080
