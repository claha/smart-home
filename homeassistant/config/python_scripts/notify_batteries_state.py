"""Send a notification with batteries state to telegram."""
hass = hass  # noqa: F821


def get_entity_state_int(entity_id):
    """Get entity state as an int."""
    return int(hass.states.get(entity_id).state)


def get_entity_friendly_name(entity_id):
    """Get entity friendly name."""
    return hass.states.get(entity_id).attributes["friendly_name"]


batteries = [
    "sensor.xiaomi_movement_and_illuminance_0_battery",
    "sensor.xiaomi_temperature_humidity_and_pressure_0_battery",
    "sensor.xiaomi_vibration_0_battery",
    "sensor.xiaomi_wireless_switch_0_battery",
]

message = "<b>Batteries</b><code>"
for battery in batteries:
    name = get_entity_friendly_name(battery)
    name = name.replace("Xiaomi ", "")
    name = name.replace(" battery", "")
    level = get_entity_state_int(battery)
    message = message + "\n{}: {}%".format(name, level)
message = message + "</code>"
hass.services.call("notify", "telegram", {"message": message})
