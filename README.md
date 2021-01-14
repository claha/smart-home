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

## mosquitto

Mosquitto is an open source MQTT broker which is used to connect various
hardware to home assistant. Before starting the container the first time a `log`
and `data` folder must be created inside the `mosquitto` folder, next to the
existing `config` folder.

```bash
mkdir log data
```

Also since there is no password file checked into git the line containing
`password_file` in `config/mosquitto.conf` should be commented with a `#`. Also
remove to read-only (`:ro`) restriction to the config folder in the
docker-compose file. Then start the container with the following command.

```bash
docker-compose up
```

Connect to the running container (in another terminal) using.

```bash
docker exec -it mosquito sh
```

When connected to the container run the follwing command and follow the
instructions to created a password file.

```bash
mosquitto_passwd -c /mosquitto/config/passwd <username>
```

Use `exit` to disconnect from the contatiner and then `Ctrl+c` (in the other
terminal) to kill the running container. Remember to restore the changes made
to the mosquitto config file and the docker-compose file before starting the
container again.
