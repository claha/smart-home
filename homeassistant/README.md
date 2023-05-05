# Home Assistant

This folder contains the home assistant configuration and the compose file to run
the service.

## Integrations

Some integrations are added through the user interface (Configuration/Integrations)
since the possibility to configure them using yaml has been removed.

- Chromecast
- Sonos
- Workday
- Weather
- MQTT

## Resources

Currently the main UI is handled automatically by homeassistant. In this mode extra
resources can not be added to a config file but must be added manually. Add the
following resources to Configuration/Lovelace Dashboards/Resources.

| URL                          | Type              |
|------------------------------|-------------------|
| /local/kiosk-mode.js?v=1.6.5 | JavaScript Module |
