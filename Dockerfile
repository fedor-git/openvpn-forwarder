FROM golang:1.13-alpine AS builder

# Install packages
RUN apk add --update --no-cache bash git gcc musl-dev make

# Install application
WORKDIR /go/src/github.com/mysteriumnetwork/openvpn-forwarder
ADD . .

# Build application
RUN make build -B


FROM alpine:3.9

# Install packages
RUN apk add --update --no-cache iptables bash

COPY --from=builder /go/src/github.com/mysteriumnetwork/openvpn-forwarder/build/forwarder forwarder
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
