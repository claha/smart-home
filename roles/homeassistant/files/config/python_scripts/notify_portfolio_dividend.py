"""Send a notification with portfolio dividend to telegram."""

hass = hass  # noqa: F821
data = data  # noqa: F821
logger = logger  # noqa: F821
datetime = datetime  # noqa: F821
MESSAGE_MAX_WIDTH = 41
TODAY = "today"


def get_entity(entity_id: str):
    """Get entity."""
    return hass.states.get(entity_id)


def convert_to_sek(amount: float, currency: str) -> float:
    """Convert CAD, EUR or USD to SEK."""
    convert = {
        "SEK": 1.0,
    }
    if currency not in convert:
        logger.error("Unknown currency: %s", currency)
        return 0
    return amount * convert[currency]


def get_value(entity, value_key: str) -> float:
    """Get value of entity in correct currency."""
    return convert_to_sek(
        entity.attributes[value_key],
        entity.attributes["unit_of_measurement"],
    )


def to_string(data) -> str:
    """Convert object to string, potentially format."""
    if isinstance(data, float):
        return f"{data:.2f}"
    if isinstance(data, int):
        return f"{data}"
    return data


def adjust_lenght(string: str, max_length: int) -> str:
    """Adjust the length of string."""
    while len(string) > max_length:
        string = string[:-1]
    return string


stocks = [
    entity_id
    for entity_id in hass.states.entity_ids("sensors")
    if entity_id.startswith("sensor.stock_")
]

# Get script arguments
report = data.get("report", "")
today = str(datetime.datetime.now().date())
if report == TODAY:
    title = "Stock Portfolio Todays Dividends"
else:
    title = "Stock Portfolio Dividends"

# Get message data
dividends = []
for entity_id in stocks:
    entity = get_entity(entity_id)

    if "dividend_paymentDate" not in entity.attributes:
        continue

    date = entity.attributes["dividend_paymentDate"]
    if date == "unknown":
        continue

    name = entity.attributes["name"]
    amount = get_value(entity, "dividend_amount")
    shares = entity.attributes["shares"]
    status = entity.attributes["dividend_exDateStatus"]
    if report == TODAY and date != today:
        continue
    if report != TODAY and status == "HISTORICAL":
        continue
    dividends.append((date, name, to_string(amount * shares)))

dividends.sort()

# Create message
message = f"<b>{title}</b><code>\n"
message = message + "-" * MESSAGE_MAX_WIDTH + "\n"
for date, name, amount in dividends:
    date = date.ljust(len(date) + 1)
    amount = amount.rjust(len("10000.00") + 1)
    name = adjust_lenght(name, MESSAGE_MAX_WIDTH - len(date) - len(amount))
    space = " " * (MESSAGE_MAX_WIDTH - len(date) - len(name) - len(amount))
    message = message + f"{date}{name}{space}{amount}\n"
message = message + "</code>"

# Send notification
if report != TODAY or (report == TODAY and len(dividends) > 0):
    hass.services.call("notify", "telegram", {"message": message})
