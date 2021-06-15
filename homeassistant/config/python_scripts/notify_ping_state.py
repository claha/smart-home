"""Send a notification with batteries state to telegram."""
hass = hass  # noqa: F821


def get_entity_state(entity_id):
    """Get entity state as an int."""
    return hass.states.get(entity_id).state


def get_entity_friendly_name(entity_id):
    """Get entity friendly name."""
    return hass.states.get(entity_id).attributes["friendly_name"]


pings = [
    "binary_sensor.ping_info_screen_host",
    "binary_sensor.ping_mosquitto_host",
    "binary_sensor.ping_zigbee2mqtt_host",
]

message = "<b>Pings</b><code>"
for ping in pings:
    name = get_entity_friendly_name(ping)
    name = name.replace("Ping ", "")
    name = name.replace(" Host", "")
    status = get_entity_state(ping)
    if status == "on":
        status = "Connected"
    elif status == "off":
        status = "Disconnected"
    message = message + "\n{}: {}".format(name, status)
message = message + "</code>"
hass.services.call("notify", "telegram", {"message": message})
