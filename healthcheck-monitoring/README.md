# How healthy is the application / service running in the container?

Docker introduced the HEALTHCHECK build instruction in v_1.12 to the Dockerfile which allows a healthcheck to be built into the image.  This is incredibly useful.

## Background

When starting a container **there may be a delay between the container starting and a service becoming available.**  This is common with containers running webservers or databases.  The container has started, the service has started but it still isn't accessible.  We normally work around this with some bash in the container looping until the service is accessible. Or we use a script outside of the container which loops until it can access the container service.

## Benefits

Adding a HEALTHCHECK instruction to the Dockerfile has lots of benefits. Here are 4 :

1. It allows to us define what "health" is
2. A user can see the health requirement in the Dockerfile 
3. If a container is not behaving as expected, exec in and manually run the healthcheck
4. Health status is reported in docker ps

## Example [Dockerfile](/healthcheck-monitoring/Dockerfile)


## What do the options mean?

According to the pull request :
```
The options that can appear before `CMD` are:

* `--interval=DURATION` (default: `30s`)
* `--timeout=DURATION` (default: `30s`)
* `--retries=N` (default: `1`)

The health check will first run **interval** seconds after the container is
started, and then again **interval** seconds after each previous check completes.

If a single run of the check takes longer than **timeout** seconds then the check
is considered to have failed.

It takes **retries** consecutive failures of the health check for the container
to be considered `unhealthy`.
``` 

# To try it

## Build container image
```
docker build -t health-check-container:v1 .
```

## Start helloworld container
```
docker run -d <image-id>
ex: docker run -d ad0ce
```

## Check container health
```sh
docker inspect <cont-id> --format '{{ .State.Health.Status }}'
ex: docker inspect a635 --format '{{ .State.Health.Status }}'

# or, more verbose option (`jq` utility must be installed)
docker inspect --format='{{json .State.Health}}' <cont-id> | jq
ex: docker inspect --format='{{json .State.Health}}' a6351 | jq
```

## Check container health using docker ps
```sh
docker ps

CONTAINER ID   IMAGE          COMMAND             CREATED          STATUS                    PORTS     NAMES
a6351c060270   ad0ce4c32456   "/helloworld.bin"   17 minutes ago   Up 17 minutes (healthy)   80/tcp    fervent_nightingale

```

