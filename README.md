# smart-home

My smart home setup uses docker (via docker-compose) to run the different
services.

## docker/docker-compose

Each service has its own docker-compose file located in their respective folder.

To download and start the container issue the following command.

```bash
docker-compose up --detach
```

This will pull the image if it is not available and start the container in
detach (use `-d` for short) mode. To restart the container simply run.

```bash
docker-compose restart
```

Execute the following two commands if the tag for the image is changed to get
the new image and start the container.

```bash
docker-compose pull
docker-compose up --detach --build
```

## Home Assistant

The homeassistant folder contains my home assistant configuration and a
docker-compose file to run it. Currently it is configured to run on a raspberry
pi 3 but could easily be changed to appropriate hardware in the docker-compose
file.
