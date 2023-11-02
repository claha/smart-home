"""Send a notification with batteries state to telegram."""
hass = hass  # noqa: F821


def get_entity_state_int(entity_id):
    """Get entity state as an int."""
    return int(float(hass.states.get(entity_id).state))


def get_entity_friendly_name(entity_id):
    """Get entity friendly name."""
    return hass.states.get(entity_id).attributes["friendly_name"]


batteries = [
    entity_id
    for entity_id in hass.states.entity_ids("sensor")
    if entity_id.endswith("_battery")
]

message = "<b>Batteries</b><code>"
for battery in batteries:
    name = get_entity_friendly_name(battery)
    name = name.replace(" battery", "")
    level = get_entity_state_int(battery)
    message = message + f"\n{name}: {level}%"
message = message + "</code>"
hass.services.call("notify", "telegram", {"message": message})
