"""
See your next pickup date for garbage from Tekniska Verken.

For more details about this platform, please refer to the documentation at
https://github.com/custom-components/sensor.tekniska_verken_garbage/blob/master/README.md
"""
import logging
from datetime import datetime, timedelta

import homeassistant.helpers.config_validation as cv
import voluptuous as vol
from homeassistant.components.sensor import PLATFORM_SCHEMA, SensorEntity
from homeassistant.const import CONF_NAME
from homeassistant.helpers.aiohttp_client import async_create_clientsession

_LOGGER = logging.getLogger(__name__)

SCAN_INTERVAL = timedelta(minutes=60)

CONF_CITY = "city"
CONF_STREET = "street"

PLATFORM_SCHEMA = PLATFORM_SCHEMA.extend(
    {
        vol.Required(CONF_CITY): cv.string,
        vol.Required(CONF_STREET): cv.string,
        vol.Optional(CONF_NAME): cv.string,
    }
)

MONTH_NAME_TO_NUMBER = {
    "januari": 1,
    "februari": 2,
    "mars": 3,
    "april": 4,
    "maj": 5,
    "juni": 6,
    "juli": 7,
    "augusti": 8,
    "september": 9,
    "oktober": 10,
    "november": 11,
    "december": 12,
}

TEKNISKA_VERKEN_GARBAGE_URL = "https://www.tekniskaverken.se/privat/avfall-och-atervinning/mat-och-restavfall/?postback=true&street={street}&city={city}"


async def async_setup_platform(hass, config, async_add_entities, discovery_info=None):
    """Set up the Tekniska Verken Garbage sensor."""
    session = async_create_clientsession(hass)
    city = config.get(CONF_CITY)
    street = config.get(CONF_STREET)
    name = config.get(CONF_NAME, "Tekniska Verken Garbage")
    async_add_entities(
        [
            TekniskaVerkenGarbageSensor(
                hass,
                city,
                street,
                name,
                session,
            )
        ],
        True,
    )


class TekniskaVerkenGarbageSensor(SensorEntity):
    """Representation of a Tekniska Verken Garbage sensor."""

    def __init__(
        self,
        hass,
        city,
        street,
        name,
        session,
    ):
        """Initialize a Tekniska Verken Garbage sensor."""
        self._hass = hass
        self._city = city
        self._street = street
        self._name = name
        self._session = session
        self._icon = "mdi:trash-can-outline"
        self._state = ""

    @property
    def name(self):
        """Return the name of the sensor."""
        return self._name

    @property
    def icon(self):
        """Icon to use in the frontend, if any."""
        return self._icon

    @property
    def state(self):
        """Return the state of the device."""
        return str(self._state)

    async def async_update(self):
        """Update state."""
        url = TEKNISKA_VERKEN_GARBAGE_URL.format(
            street=self._street,
            city=self._city,
        )
        resp = await self._session.get(url)
        text = await resp.text()
        lines = text.splitlines()
        for line in lines:
            if "N&#228;sta h&#228;mtning" in line:
                chunks = (
                    line.strip()
                    .replace("<strong>", "")
                    .replace("</strong>", "")
                    .split(" ")
                )
                day, month = chunks[-2:]
                month = MONTH_NAME_TO_NUMBER[month]
                today = datetime.today().date()
                garbage_day = datetime.strptime(
                    f"{today.year}-{month}-{day}", "%Y-%m-%d"
                ).date()
                if garbage_day < today:
                    garbage_day = datetime.strptime(
                        f"{today.year+1}-{month}-{day}", "%Y-%m-%d"
                    ).date()
                self._state = garbage_day
                break
