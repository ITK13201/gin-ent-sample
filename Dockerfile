ARG APP_NAME=gin-ent-sample
ARG go_version=1.16-buster
ARG goose_version=v3.0.1

# Dvenelopment environment
FROM golang:${go_version} AS development

ARG air_version=v1.27.3
ARG goose_version=v3.0.1
ARG WORKDIR=/app
ENV GO111MODULE=on

RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

RUN apt-get update

COPY ./go.mod .
COPY ./go.sum .
RUN go mod download

RUN go get -u github.com/cosmtrek/air@${air_version} \
    && go build -o /go/bin/air github.com/cosmtrek/air \
    && go get -u github.com/pressly/goose/v3/cmd/goose@${goose_version} \
    && go build -o /go/bin/goose github.com/pressly/goose/v3/cmd/goose

COPY . .
COPY ./scripts /usr/local/bin

EXPOSE 8000

ENTRYPOINT ["air", "-c", ".air.toml"]


# Builder
FROM golang:${go_version} AS builder

ENV GO111MODULE=on
WORKDIR ${WORKDIR}

RUN apt-get update

COPY ./go.mod .
COPY ./go.sum .
RUN go mod download

COPY . .

RUN go build -o ./bin/${APP_NAME}


# Production environment
FROM gcr.io/distroless/base:debug AS production

COPY --from=builder ./bin/${APP_NAME} /bin/${APP_NAME}

ENTRYPOINT ["/bin/${APP_NAME}"]
