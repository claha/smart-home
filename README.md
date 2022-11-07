# smart-home

My smart home setup uses docker to run the different services.

## docker compose

Each service has its own docker-compose file located in their respective folder.

To download and start the container issue the following command.

```bash
docker compose up --detach --force-recreate
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
docker-compose up --detach --force-recreate
```
