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

### Integrations

Some integrations are added through the user interface (Configuration/Integrations).

#### Chromecast

The chromecast should be auto detected and an entity called `media_player.chromecast`
should be created when the integration is added.

#### Weather

Add OpenWeatherMap and name it `Home`, i.e. there should be an entity called
`weather.home`, use the mode `onecall_daily` and set the language to `se`.

#### MQTT

Add MQTT integration with default settings and connect it to mosquitto.

### Resources

Currently the main UI is handled automatically by homeassistant. In this mode extra
resources can not be added to a config file but must be added manually. Add the
following resources to Configuration/Lovelace Dashboards/Resources.

| URL                          | Type              |
|------------------------------|-------------------|
| /local/kiosk-mode.js?v=1.6.5 | JavaScript Module |

### Automation

Automations are written using `yaml`.

#### Lights

The light automations are based on sun elevation and illuminance sensors and
also timers as a fallback (using input_datetime). Some lights also utilises the
state of the TV to keep lights on longer and then turn them off (TBA).

The sun elevation reaches its minimum value at midnight (a negative number larger
than -90) and typically during midday the sun elevation is at its maximum (a
postive number smaller than 90) and then decreases until it reaches its miniumum
again at midnight.

| Turn on                | Turn off                |
|------------------------|-------------------------|
|                        | Sun elevation above X°  |
|                        | Illuminance above Xlx   |
| Sun elevation below Y° |                         |
| Illuminance below Ylx  |                         |
|                        | Timer around bedtime    |

 90 |        _....._
    |     ,="       "=,
    |   ,"             ",
-90 | ."                 ".
        X               Y

Currently an auto off automation handles the case when a light is turned on when
elevation is above X° and the  sun is rising and when the elevation is above Y°
and the sun is setting, i.e. when lights should not be needed to turn on since
it is not dark outside.

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

## Zigbee2MQTT

Used to control Zigbee devices via MQTT. There is a bug in Docker which selects
the wrong image architecture for Raspberry Pi 1 and Zero. Since this currently
runs on a Zero the platform is explicitly set in the docker-compose file.

## ZNC

ZNC is an IRC (Internet Relay Chat) bouncer. Before starting the container the
first time, create a `config` directory next to the `docker-compose.yaml` file.
Then pull and start the container. After the container has been started, log in
(username admin, password admin) through the web ui and change the password
under `User Settings`. Then stop the container and open the file
`config/configs/znc.conf` and enable SSL by adding/changing to `SSL = true` in
the `<Listener>` part of the configuration. Start the container again and start
adding networks and channels using the web ui. ZNC uses modules to enrich the
experience, here are a few that could be useful to enable. These can be found
under `Global Settings` and/or `Your Settings`.

- adminlog
- chansaver
- controlpanel
- log
- nickserv
- simple_away

There are lot more settings that can be changed, some that could be good to look
into are.

- AutoClearChanBuffer
- AutoClearQueryBuffer
- BufferSize

## Syncthing

Syncthing is a continuous file synchronization program. Before starting the
container, add volumes where data is stored to the `docker-compose.yaml` file
and then configure what and how to sync using the web ui.
