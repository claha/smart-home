"""Send a notification with portfolio dividend to telegram."""
hass = hass  # noqa: F821
data = data  # noqa: F821
logger = logger  # noqa: F821
datetime = datetime  # noqa: F821
MESSAGE_MAX_WIDTH = 41
TODAY = "today"


def get_entity(entity_id):
    """Get entity."""
    return hass.states.get(entity_id)


def convert_to_sek(amount, currency):
    """Convert CAD, EUR or USD to SEK."""
    convert = {
        "EUR": float(get_entity("sensor.currency_eur_sek").state),
        "USD": float(get_entity("sensor.currency_usd_sek").state),
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
for entity_id in hass.states.entity_ids("sensor"):
    if entity_id.startswith("sensor.stock_"):
        stocks.append(entity_id)

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

    for payment_date in [
        "dividend0_paymentDate",
        "dividend1_paymentDate",
        "dividend2_paymentDate",
    ]:
        if payment_date not in entity.attributes:
            break
        date = entity.attributes[payment_date]
        if date == "unknown":
            break
        name = entity.attributes["name"]
        amount_per_share = get_value(
            entity, payment_date.split("_")[0] + "_amountPerShare"
        )
        shares = entity.attributes["shares"]
        if report == TODAY and date != today:
            continue
        dividends.append((date, name, to_string(amount_per_share * shares)))

dividends.sort()

# Create message
message = "<b>{}</b><code>\n".format(title)
message = message + "-" * MESSAGE_MAX_WIDTH + "\n"
for (date, name, amount) in dividends:
    date = date.ljust(len(date) + 1)
    amount = amount.rjust(len("10000.00") + 1)
    name = adjust_lenght(name, MESSAGE_MAX_WIDTH - len(date) - len(amount))
    space = " " * (MESSAGE_MAX_WIDTH - len(date) - len(name) - len(amount))
    message = message + "{}{}{}{}\n".format(date, name, space, amount)
message = message + "</code>"

# Send notification
if report != TODAY or (report == TODAY and len(dividends) > 0):
    hass.services.call("notify", "telegram", {"message": message})
