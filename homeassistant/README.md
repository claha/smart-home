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

### Lights

The light automations are based on sun elevation and illuminance sensors and
also timers as a fallback (using input_datetime). Some lights also utilises the
state of the TV to keep lights on longer and then turn them off (TBA).

The sun elevation reaches its minimum value at midnight (a negative number larger
than -90) and typically during midday the sun elevation is at its maximum (a
positive number smaller than 90) and then decreases until it reaches its minimum
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
