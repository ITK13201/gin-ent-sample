ARG go_version=1.16-buster

# Tools
FROM golang:${go_version} AS tools

ARG goose_version=v3.4.1
ARG air_version=1.27.8

RUN wget https://github.com/pressly/goose/releases/download/${goose_version}/goose_linux_x86_64 \
    && mv goose_linux_x86_64 /usr/local/bin/goose \
    && chmod +x /usr/local/bin/goose

RUN wget https://github.com/cosmtrek/air/releases/download/v${air_version}/air_${air_version}_linux_amd64.tar.gz \
    && tar -C /usr/local/bin -xzvf air_${air_version}_linux_amd64.tar.gz \
    && chmod +x /usr/local/bin/air \
    && rm air_${air_version}_linux_amd64.tar.gz

# Dvenelopment environment
FROM golang:${go_version} AS development

ARG WORKDIR=/app
ENV GO111MODULE=on

RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

RUN apt-get update

COPY ./go.mod .
COPY ./go.sum .
RUN go mod download

COPY . .
COPY ./scripts /usr/local/bin

COPY --from=tools /usr/local/bin/goose /bin/goose
COPY --from=tools /usr/local/bin/air /bin/air

EXPOSE 8000

ENTRYPOINT ["air", "-c", ".air.toml"]


# Builder
FROM golang:${go_version} AS builder

ARG WORKDIR=/app
ENV GO111MODULE=on
WORKDIR ${WORKDIR}

RUN apt-get update

COPY ./go.mod .
COPY ./go.sum .
RUN go mod download

COPY . .

RUN go build -o ./bin/gin-ent-sample


# Production environment
FROM gcr.io/distroless/base:debug AS production

COPY --from=tools /usr/local/bin/goose /bin/goose
COPY --from=builder /app/bin/gin-ent-sample /bin/gin-ent-sample

ENTRYPOINT ["sh", "-c", "/bin/gin-ent-sample"]
