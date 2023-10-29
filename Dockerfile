FROM golang:alpine as build-env

# Copy source + vendor
COPY . /go/src/github.com/AlexPan90/sonic-hub-proxy
WORKDIR /go/src/github.com/AlexPan90/sonic-hub-proxy

# Build
ENV GOPATH=/go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -v -a -ldflags "-s -w" -o /go/bin/hub_proxy ./cmd/hub-proxy/

FROM alpine
COPY --from=build-env /go/bin/hub_proxy /usr/bin/hub_proxy
RUN apk update
#RUN apk add git
RUN apk add curl
RUN apk add tcpdump
ENTRYPOINT ["hub_proxy"]