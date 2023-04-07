# Zigbee2MQTT

Used to control Zigbee devices via MQTT. There is a bug in Docker which selects
the wrong image architecture for Raspberry Pi 1 and Zero. Since this currently
runs on a Zero the platform is explicitly set in the compose file.
