"""Send a notification with garbage day information to telegram."""
hass = hass  # noqa: F821
data = data  # noqa: F821
logger = logger  # noqa: F821
datetime = datetime  # noqa: F821


def get_entity(entity_id):
    """Get entity."""
    return hass.states.get(entity_id)


today = datetime.datetime.now().date()
tomorrow = today + datetime.timedelta(days=1)
today = str(today)
tomorrow = str(tomorrow)
garbage_day = get_entity("sensor.tekniska_verken_garbage").state

# Create message
title = "Remember to take out the trash"
message = "<b>{}</b><code>\n".format(title)
if garbage_day == today:
    message = message + "The trash will be picked up today\n"
elif garbage_day == tomorrow:
    message = message + "The trash will be picked up tomorrow\n"
message = message + garbage_day
message = message + "</code>"

# Send notification
if garbage_day in [today, tomorrow]:
    hass.services.call("notify", "telegram", {"message": message})
