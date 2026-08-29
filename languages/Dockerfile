# syntax=docker/dockerfile:1
# comment
ARG BASE_IMAGE=golang:1.23-alpine
ARG UID=1000

FROM ${BASE_IMAGE} AS builder
LABEL org.opencontainers.image.title="sample" maintainer="me@example.com" stage=build
ENV PATH=/usr/local/go/bin:$PATH CGO_ENABLED=0
ENV GOFLAGS -trimpath
ARG VERSION=0.0.0-dev
SHELL ["/bin/sh", "-eu", "-c"]
WORKDIR /src
RUN apk add --no-cache git make \
 && echo "${VERSION:-unset}" > /src/VERSION \
 && rm -rf /var/cache/apk/*
RUN <<EOF
set -eux
printf 'built %s\n' "${VERSION:+tagged}"
EOF
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,source=.,target=/src,rw \
    go build -ldflags "-X main.version=$VERSION" -o /out/app ./cmd/app

FROM builder AS assets
ADD --keep-git-dir=true https://example.com/data.tar.gz /tmp/data.tar.gz

FROM alpine:3.20
ARG UID
COPY --from=builder /out/app /usr/bin/app
COPY --from=assets --chown=$UID:$UID /tmp/data.tar.gz /srv/
COPY --chown=1000:1000 ./etc/ /etc/app/
USER $UID:$UID
EXPOSE 8080/tcp
EXPOSE 53/udp
VOLUME ["/data", "/var/log/app"]
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
STOPSIGNAL SIGTERM
ONBUILD COPY . /app
ENTRYPOINT ["/usr/bin/app", "--listen", ":8080"]
CMD ["--verbose"]
