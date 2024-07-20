"""Send a notification with batteries state to telegram."""

hass = hass  # noqa: F821


def get_entity_state(entity_id: str) -> str:
    """Get entity state as an int."""
    return hass.states.get(entity_id).state


def get_entity_friendly_name(entity_id: str) -> str:
    """Get entity friendly name."""
    return hass.states.get(entity_id).attributes["friendly_name"]


entity_id = "binary_sensor.garage_door"
message = "<b>Garage Door</b><code>"
name = get_entity_friendly_name(entity_id)
status = get_entity_state(entity_id)
if status == "on":
    message = message + f"\n{name}: is open"
elif status == "off":
    message = message + f"\n{name}: is closed"
message = message + "</code>"
hass.services.call("notify", "telegram", {"message": message})
