#! /bin/bash
autorestic restore --config /data/autorestic/config.yaml --verbose --location homeassistant --from backblaze --to /data/homeassistant-restore
