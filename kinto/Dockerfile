FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git bash wget curl
WORKDIR /go/src/v2ray.com/core
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM caddy:2.1.1-alpine
ENV CONFIG="https://raw.githubusercontent.com/mixool/v2ray/master/kinto/config.json"
ENV WSPATH="/"

COPY --from=builder /tmp/v2ray.tgz /tmp
RUN apk update && apk add --no-cache tor ca-certificates && \
    mkdir -p /usr/bin/v2ray && \
    tar xvfz /tmp/v2ray.tgz -C /usr/bin/v2ray && \
    rm -rf /tmp/v2ray.tgz

ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
