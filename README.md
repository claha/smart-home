# Smart Home

![pre-commit](https://github.com/claha/smart-home/actions/workflows/pre-commit.yaml/badge.svg)

![github-deploy](https://github.com/claha/smart-home/actions/workflows/github-deploy.yaml/badge.svg)

![autorestic](https://github.com/claha/smart-home/actions/workflows/autorestic.yaml/badge.svg)
![diun](https://github.com/claha/smart-home/actions/workflows/diun.yaml/badge.svg)
![duckdns](https://github.com/claha/smart-home/actions/workflows/duckdns.yaml/badge.svg)
![gatus](https://github.com/claha/smart-home/actions/workflows/gatus.yaml/badge.svg)
![glances](https://github.com/claha/smart-home/actions/workflows/glances.yaml/badge.svg)
![healthchecks](https://github.com/claha/smart-home/actions/workflows/healthchecks.yaml/badge.svg)
![homeassistant](https://github.com/claha/smart-home/actions/workflows/homeassistant.yaml/badge.svg)
![homepage](https://github.com/claha/smart-home/actions/workflows/homepage.yaml/badge.svg)
![mosquitto](https://github.com/claha/smart-home/actions/workflows/mosquitto.yaml/badge.svg)
![pihole](https://github.com/claha/smart-home/actions/workflows/pihole.yaml/badge.svg)
![piper](https://github.com/claha/smart-home/actions/workflows/piper.yaml/badge.svg)
![tailscale](https://github.com/claha/smart-home/actions/workflows/tailscale.yaml/badge.svg)
![traefik](https://github.com/claha/smart-home/actions/workflows/traefik.yaml/badge.svg)
![whisper](https://github.com/claha/smart-home/actions/workflows/whisper.yaml/badge.svg)
![zigbee2mqtt](https://github.com/claha/smart-home/actions/workflows/zigbee2mqtt.yaml/badge.svg)

Welcome to the documentation of my smart home setup, which leverages the power of
Ansible, Docker Compose, and NixOS to manage and orchestrate various services. This
setup allows me to efficiently control and monitor different aspects of my smart
home environment.

## Architecture

My smart home setup follows a distributed architecture, where different services
are containerized using Docker and orchestrated using Docker Compose. Additionally,
certain components of my smart home environment run on NixOS, a powerful Linux distribution
known for its declarative and reproducible nature. This hybrid approach combines
the benefits of containerization with the stability and consistency provided by NixOS.

## Ansible

To manage the configuration and deployment of the services, I rely heavily on Ansible.
Ansible is a powerful automation tool that allows me to define and apply consistent
configurations across multiple devices in my smart home. With Ansible, I can easily
define playbooks and roles to provision, configure, and maintain the services and
their dependencies.

## Docker Compose

Docker Compose plays a crucial role in my smart home setup by providing an intuitive
way to define and manage applications. Each containerized service in my setup has
its own Docker Compose file, which resides in the respective Ansible role directory.
This organization allows me to encapsulate the configuration and dependencies of
each service, making it easier to maintain and deploy.

## NixOS

NixOS offers several benefits to my smart home setup. It employs a declarative configuration
model, enabling me to describe the desired system state in a configuration file.
This approach ensures easy reproducibility and eliminates configuration drift. NixOS
also supports atomic upgrades and rollbacks through its functional package management
system, allowing seamless updates and easy reversion to previous configurations if
needed.
