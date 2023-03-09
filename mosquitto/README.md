# mosquitto

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

When connected to the container run the following command and follow the
instructions to created a password file.

```bash
mosquitto_passwd -c /mosquitto/config/passwd <username>
```

Use `exit` to disconnect from the contatiner and then `Ctrl+c` (in the other
terminal) to kill the running container. Remember to restore the changes made
to the mosquitto config file and the docker-compose file before starting the
container again.
