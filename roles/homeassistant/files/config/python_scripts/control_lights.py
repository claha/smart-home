"""Control lights."""

hass = hass  # noqa: F821
data = data  # noqa: F821
logger = logger  # noqa: F821

ACTION_ON = "on"
ACTION_DIM = "dim"
ACTION_OFF = "off"


def light_on(entity_id, brightness_pct, color_temp):
    """Turn on a light."""
    hass.services.call(
        "light",
        "turn_on",
        {
            "entity_id": entity_id,
            "brightness_pct": brightness_pct,
            "color_temp": color_temp,
            "transition": 10,
        },
        False,
    )


def light_dim(entity_id):
    """Dim a light."""
    if hass.states.get(entity_id).state == "off":
        return
    hass.services.call(
        "light",
        "turn_on",
        {
            "entity_id": entity_id,
            "brightness_pct": 10,
            "color_temp": 454,
            "transition": 10,
        },
        False,
    )


def light_off(entity_id):
    """Turn off a light."""
    hass.services.call(
        "light",
        "turn_off",
        {
            "entity_id": entity_id,
            "transition": 10,
        },
        False,
    )


def switch_on(entity_id, brightness_pct, color_temp):
    """Turn on a switch."""
    hass.services.call(
        "switch",
        "turn_on",
        {
            "entity_id": entity_id,
        },
        False,
    )


def switch_dim(entity_id):
    """Dim a switch."""
    pass


def switch_off(entity_id):
    """Turn off a switch."""
    hass.services.call(
        "switch",
        "turn_off",
        {
            "entity_id": entity_id,
        },
        False,
    )


on_control = {
    "light": light_on,
    "switch": switch_on,
}

dim_control = {
    "light": light_dim,
    "switch": switch_dim,
}

off_control = {
    "light": light_off,
    "switch": switch_off,
}


lights = {
    "master_bedroom": [
        "light.tradfri_bulb_0",
    ],
    "guest_room": [
        "light.tradfri_bulb_3",
    ],
    "kitchen": [
        "switch.tradfri_control_outlet_1",
        # "switch.osram_smart_plug_1",  # Seems broken?
    ],
    "living_room": [
        "switch.osram_smart_plug_0",
        "switch.tradfri_control_outlet_0",
        "switch.shelly_plug_s_1",
    ],
    "laundry": [
        "light.tradfri_bulb_2",
    ],
    "closet": [
        "light.tradfri_bulb_1",
    ],
    "kids_bedroom": [
        "switch.tradfri_control_outlet_2",
        "switch.tradfri_control_outlet_3",
    ],
    "outdoor": [
        "switch.shelly_plug_s_0",
    ],
}

# Get script arguments
area = data.get("area")
action = data.get("action")
brightness_pct = data.get("brightness_pct", 80)
color_temp = data.get("color_temp", 454)

# Perform action on each entity id
entity_ids = lights[area]
for entity_id in entity_ids:
    entity_type = entity_id.split(".")[0]
    if action == ACTION_ON:
        on_control[entity_type](entity_id, brightness_pct, color_temp)
    elif action == ACTION_DIM:
        dim_control[entity_type](entity_id)
    elif action == ACTION_OFF:
        off_control[entity_type](entity_id)
