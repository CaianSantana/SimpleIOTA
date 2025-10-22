FROM alpine:3.22 AS Builder

WORKDIR /app

RUN apk update 
RUN apk add wget tar curl unzip libpq-dev libudev-zero

ENV IOTA_VERSION="v1.7.0"

RUN wget -O iota-binaries.tgz https://github.com/iotaledger/iota/releases/download/$IOTA_VERSION/iota-$IOTA_VERSION-linux-x86_64.tgz \
    && tar -xzvf iota-binaries.tgz \
    && rm iota-binaries.tgz

FROM alpine:3.22

WORKDIR /usr/local/bin
COPY --from=Builder /app .

RUN adduser -D iota-user
USER iota-user

CMD ["iota", "start", "--force-regenesis", "--with-faucet"]

EXPOSE 9000
EXPOSE 9123

