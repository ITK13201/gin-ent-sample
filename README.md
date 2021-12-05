# Gin Ent Sample

This is a sample application of golang's web framework gin and orm ent.

## Components

- Web Framework: [Gin](https://github.com/gin-gonic/gin)
- ORM: [ent](https://github.com/ent/ent)
- SQL Migration tool: [goose](https://github.com/pressly/goose)

## Install

### Prepare

- docker
- docker-compose

### Clone

```shell
git clone https://github.com/ITK13201/gin-ent-sample.git
cd gin-ent-sample
```

### Init environment variables and create log files

```shell
./scripts/init.sh
```

### Build

```shell
docker-compose build
```


## Usage

### Start Container

```shell
docker-compose up
```

### Stop container

```shell
docker-compose down
```

### Modify Models

Only the directory under [./ent/schema](./ent/schema) needs to be changed.
After the change, you can update the model as follows.

```shell
docker-compose exec app go generate ./ent
```
