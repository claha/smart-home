"""Send a notification with batteries state to telegram."""
hass = hass  # noqa: F821


def get_entity_state(entity_id):
    """Get entity state as an int."""
    return hass.states.get(entity_id).state


def get_entity_friendly_name(entity_id):
    """Get entity friendly name."""
    return hass.states.get(entity_id).attributes["friendly_name"]


pings = [
    entity_id
    for entity_id in hass.states.entity_ids("binary_sensor")
    if entity_id.startswith("binary_sensor.ping_")
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
    message = message + f"\n{name}: {status}"
message = message + "</code>"
hass.services.call("notify", "telegram", {"message": message})
