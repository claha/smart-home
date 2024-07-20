"""Send a notification with garbage day information to telegram."""

NOON = 12

hass = hass  # noqa: F821
data = data  # noqa: F821
logger = logger  # noqa: F821
datetime = datetime  # noqa: F821


def get_entity(entity_id: str):
    """Get entity."""
    return hass.states.get(entity_id)


now = datetime.datetime.now()
hour = now.hour
today = now.date()
tomorrow = today + datetime.timedelta(days=1)
today = str(today)
tomorrow = str(tomorrow)
garbage_day = get_entity("sensor.tekniska_verken_garbage").state

# Create message
title = "Remember to take out the trash"
message = f"<b>{title}</b><code>\n"
if garbage_day == today:
    message = message + "The trash will be picked up today\n"
elif garbage_day == tomorrow:
    message = message + "The trash will be picked up tomorrow\n"
message = message + garbage_day
message = message + "</code>"

# Send notification
notify = False
if garbage_day == today and hour < NOON or garbage_day == tomorrow and hour > NOON:
    notify = True
if notify:
    hass.services.call("notify", "telegram", {"message": message})
