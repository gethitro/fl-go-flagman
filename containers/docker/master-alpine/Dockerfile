FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 --branch release/1.7 https://github.com/flagman/go-flagman && \
  (cd go-flagman && make gfl) && \
  cp go-flagman/build/bin/gfl /gfl && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-flagman && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gfl"]
