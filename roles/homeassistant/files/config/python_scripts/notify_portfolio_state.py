"""Send a notification with portfolio state to telegram."""
hass = hass  # noqa: F821
data = data  # noqa: F821
logger = logger  # noqa: F821
MESSAGE_MAX_WIDTH = 41


def get_entity(entity_id):
    """Get entity."""
    return hass.states.get(entity_id)


def convert_to_sek(amount, currency):
    """Convert CAD, EUR or USD to SEK."""
    convert = {
        "SEK": 1.0,
    }
    if currency not in convert.keys():
        logger.error("Unknown currency: %s" % currency)
        return 0
    return amount * convert[currency]


def get_value(entity, value_key):
    """Get value of entity in correct currency."""
    return convert_to_sek(
        entity.attributes[value_key], entity.attributes["unit_of_measurement"]
    )


def get_change(entity, change_key, change_percent_key, as_string=False):
    """Get change of entity in correct currency."""
    change, change_percent = None, None
    if change_key:
        change = convert_to_sek(
            entity.attributes[change_key], entity.attributes["unit_of_measurement"]
        )
    if change_percent_key:
        change_percent = entity.attributes[change_percent_key]

    if as_string:
        change = to_string(change)
        change_percent = to_string(change_percent) + "%"

    return (change, change_percent)


def to_string(data):
    """Convert óbject to string, potentially format."""
    if isinstance(data, float):
        return "{:.2f}".format(data)
    if isinstance(data, int):
        return "{}".format(data)
    return data


def adjust_lenght(string, max_length):
    """Adjust the length of string."""
    while len(string) > max_length:
        string = string[:-1]
    return string


stocks = []
funds = []
for entity_id in hass.states.entity_ids("sensor"):
    if entity_id.startswith("sensor.stock_"):
        stocks.append(entity_id)
    elif entity_id.startswith("sensor.fund_"):
        funds.append(entity_id)

# Get script arguments
report = data.get("report", "")
timespan = data.get("timespan", "")

if report == "stock":
    entities = stocks
    title_prefix = "Stock "
elif report == "fund":
    entities = funds
    title_prefix = "Fund "
else:
    entities = stocks + funds
    title_prefix = ""

if timespan == "day":
    change_key = "totalChange"
    change_percent_key = "changePercent"
    title_suffix = " Todays Changes"
elif timespan == "week":
    change_key = "totalChangeOneWeek"
    change_percent_key = "changePercentOneWeek"
    title_suffix = " This Weeks Changes"
elif timespan == "month":
    change_key = "totalChangeOneMonth"
    change_percent_key = "changePercentOneMonth"
    title_suffix = " This Months Changes"
elif timespan == "year":
    change_key = "totalChangeOneYear"
    change_percent_key = "changePercentOneYear"
    title_suffix = " This Years Changes"
else:
    change_key = "totalChange"
    change_percent_key = "changePercent"
    title_suffix = " Todays Changes"

# Get message data
message_data = []
for entity_id in entities:
    entity = get_entity(entity_id)
    try:
        name = entity.attributes["name"]
        total_change, change_percent = get_change(
            entity, change_key, change_percent_key, True
        )
        message_data.append((name, change_percent, total_change))
    except Exception:
        logger.warning("Failed for %s", entity_id)
        message_data.append((entity_id, "-100.00%", "?"))
message_data.sort(key=lambda x: float(x[1][:-1]), reverse=True)

summary_data = [0, 0, 0]
for entity_id in entities:
    try:
        entity = get_entity(entity_id)
        total_value = get_value(entity, "totalValue")
        total_change, _ = get_change(entity, change_key, change_percent_key)
        summary_data[0] = summary_data[0] + total_value
        summary_data[1] = summary_data[1] + total_change
    except Exception:
        logger.warning("Failed for %s", entity_id)
summary_data[2] = 100 * summary_data[1] / (summary_data[0] - summary_data[1])
summary_data[0] = to_string(summary_data[0])
summary_data[1] = to_string(summary_data[1])
summary_data[2] = to_string(summary_data[2]) + "%"

# Create message
message_data_len = [0] * len(message_data[0])
for data in message_data:
    for i in range(len(data)):
        if len(data[i]) > message_data_len[i]:
            message_data_len[i] = len(data[i])

message = "<b>{}Portfolio{}</b><code>\n".format(title_prefix, title_suffix)
message = message + "-" * MESSAGE_MAX_WIDTH + "\n"
for name, change_percent, total_change in message_data:
    change_percent = change_percent.rjust(message_data_len[1] + 1)
    total_change = total_change.rjust(message_data_len[2] + 1)
    name = adjust_lenght(
        name, MESSAGE_MAX_WIDTH - len(change_percent) - len(total_change)
    )
    space = " " * (
        MESSAGE_MAX_WIDTH - len(name) - len(change_percent) - len(total_change)
    )
    message = message + "{}{}{}{}\n".format(name, space, change_percent, total_change)
message = message + "-" * MESSAGE_MAX_WIDTH + "\n"
message = message + "Total Value: {}\n".format(summary_data[0])
message = message + "Total Change: {} ({})\n".format(summary_data[1], summary_data[2])
message = message + "</code>"

# Send notification
hass.services.call("notify", "telegram", {"message": message})
