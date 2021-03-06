# Build gfl in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-flagman
RUN cd /go-flagman && make gfl

# Pull gfl into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-flagman/build/bin/gfl /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp 30304/udp
ENTRYPOINT ["gfl"]
