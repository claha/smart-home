"""Get latest data for all indices, stocks and funds."""
hass = hass  # noqa: F821

# Get entities
indices = []
stocks = []
funds = []
for entity_id in hass.states.entity_ids("sensor"):
    if entity_id.startswith("sensor.stock_"):
        stocks.append(entity_id)
    elif entity_id.startswith("sensor.fund_"):
        funds.append(entity_id)
    elif entity_id.startswith("sensor.index_"):
        indices.append(entity_id)
entities = indices + stocks + funds

# Update entities
hass.services.call("homeassistant", "update_entity", {"entity_id": entities})
