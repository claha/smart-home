# smart-home

My smart home setup uses docker to run the different services.
Each service has its own compose file located in their respective folder.

To download (pull) and start the container run the following command.

```bash
docker compose up --detach --force-recreate
```

This will pull the image if it is not available, this command will also work if
the tag is changed, and start the container in detach (use `-d` for short) mode.
