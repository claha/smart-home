# Home Assistant

The homeassistant folder contains my home assistant configuration and a
docker-compose file to run it. Currently it is configured to run on a raspberry
pi 3 but could easily be changed to appropriate hardware in the docker-compose
file.

## Integrations

Some integrations are added through the user interface (Configuration/Integrations).

### Chromecast

The chromecast should be auto detected and an entity called `media_player.chromecast`
should be created when the integration is added.

### Weather

Add OpenWeatherMap and name it `Home`, i.e. there should be an entity called
`weather.home`, use the mode `onecall_daily` and set the language to `se`.

### MQTT

Add MQTT integration with default settings and connect it to mosquitto.

## Resources

Currently the main UI is handled automatically by homeassistant. In this mode extra
resources can not be added to a config file but must be added manually. Add the
following resources to Configuration/Lovelace Dashboards/Resources.

| URL                          | Type              |
|------------------------------|-------------------|
| /local/kiosk-mode.js?v=1.6.5 | JavaScript Module |

## Automation

Automations are written using `yaml`.
