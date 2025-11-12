# Pi-hole Docker Compose Setup

This is a Docker Compose setup for running Pi-hole, a network-wide ad blocker.

## Docker Compose Configuration

The setup uses Docker Compose to run Pi-hole with:

- Custom DNS configuration (127.0.0.1)
- Persistent storage for settings
- Custom adlists configuration (adlists.list)

## DNS Configuration

For Pi-hole to work as your DNS server:

- The system needs `resolvconf` installed
- `/etc/resolvconf.conf` is configured to use `127.0.0.1` as nameserver
- DNS changes are applied by running `resolvconf -u`

This ensures all network requests go through Pi-hole for ad blocking.
