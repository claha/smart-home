"""Send a notification with system monitor state to telegram."""
hass = hass  # noqa: F821


def get_entity_state_float(entity_id):
    """Get entity state as a float."""
    return float(hass.states.get(entity_id).state)


disk_use_percent = get_entity_state_float("sensor.disk_use_percent")
memory_use_percent = get_entity_state_float("sensor.memory_use_percent")
processor_use_percent = get_entity_state_float("sensor.processor_use_percent")
processor_temperature = get_entity_state_float("sensor.processor_temperature")

message = """\
<b>System Monitor</b><code>
Disk
  Usage:       {:.0f}%
Memory
  Usage:       {:.0f}%
Processor
  Usage:       {:.0f}%
  Temperature: {:.0f}°C
</code>""".format(
    disk_use_percent, memory_use_percent, processor_use_percent, processor_temperature
)
hass.services.call("notify", "telegram", {"message": message})
