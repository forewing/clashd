FROM golang:1.15-alpine AS builder
RUN apk add --no-cache \
    git

WORKDIR /build
RUN go get -u -v github.com/Dreamacro/clash && \
    mv $(which clash) .


FROM alpine:3
RUN apk add --no-cache \
    dumb-init

WORKDIR /app
COPY --from=builder /build/clash /app/

VOLUME ["/conf"]

ENTRYPOINT [ "dumb-init", "--", "/app/clash" ]
CMD ["-d=/conf"]
