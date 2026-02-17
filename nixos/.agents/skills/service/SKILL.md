---
name: service
description: Add a new self-hosted service to the NixOS homelab, integrating it with Traefik (reverse proxy + HTTPS) and Homepage (dashboard). Use when the user wants to add, install, or enable any new service on the homelab.
---

# Skill: Add a New Service

## Goal

Add a new self-hosted service to the NixOS homelab, integrating it with
Traefik (reverse proxy + HTTPS) and Homepage (dashboard).

## Prerequisites

- Service is available in nixpkgs (or nixpkgs-unstable)
- Service runs on a specific TCP port
- You know which host will run the service

## Steps

### 1. Research the Service

Use the NixOS MCP to look up package info and module options:

```nix
# Search for the package
mcp_nixos_nix(action="search", query="<service-name>", source="nixos", type="packages")

# Search for NixOS module options
mcp_nixos_nix(action="search", query="services.<service-name>", source="nixos", type="options")

# Get detailed package info
mcp_nixos_nix(action="info", query="<service-name>", source="nixos", type="package")
```

**Key things to identify:**

- What port does it use by default?
- Does it have an `openFirewall` option?
- Does it expose a `port` option you can reference, or is the port hardcoded?
- What settings are available via `settings`?

**For detailed module source, use Sourcegraph:**

```bash
sourcegraph "repo:^github\.com/NixOS/nixpkgs$ services.<name>"
```

Or fetch directly:

```bash
curl -s https://raw.githubusercontent.com/NixOS/nixpkgs/master/nixos/modules/services/<category>/<name>.nix
```

### 2. Find a Similar Service Pattern

Look at an existing service with similar characteristics:

```bash
ls services/
cat services/vikunja.nix  # Simple service example
cat services/mealie.nix   # Package from unstable example
```

### 3. Create Service Wrapper

Create `services/<name>.nix`:

```nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.<name>;
  port = <port-number>;  # Hardcode if module doesn't expose port option
in
{
  options.homelab.<name> = {
    enable = lib.mkEnableOption "<Name> description";
  };

  config = lib.mkIf cfg.enable {
    services.<name> = {
      enable = true;
      package = pkgs.unstable.<name>;  # Use unstable if needed
      # openFirewall = true;  # ONLY if module supports it (check first!)
      settings.<PORT_OPTION> = toString port;  # If port is configurable
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
```

**Note:** Do NOT use `openFirewall = true` if the upstream module references
`cfg.port` without defining it as an option — this causes evaluation errors.

### 4. Wire into Service Imports

Add to `services/default.nix`:

```nix
imports = [
  # ... existing imports ...
  ./<name>.nix
];
```

### 5. Add Traefik Router

In `services/traefik.nix`, add to the `services` attrset:

```nix
services = {
  # ... existing services ...
  <name> = "http://<host-ip>:<port>";
};
```

### 6. Add to Homepage

In `services/homepage.nix`, add to the appropriate category:

```nix
{
  <Category> = [
    {
      "<Display-Name>" = {
        href = "https://<name>.hallstrom.duckdns.org";
        icon = "<name>";
      };
    }
  ];
}
```

Categories: `Media`, `Home`, `Productivity`, `Monitor`, `Tools`, `Network`

### 7. Enable on Host

In `hosts/<hostname>/default.nix`:

```nix
homelab = {
  # ... existing services ...
  <name>.enable = true;
};
```

### 8. Format and Verify

```bash
nix-shell -p nixfmt-tree --run treefmt
git add services/<name>.nix   # New files must be staged before flake check
nix flake check --no-build
```

## Troubleshooting

**"attribute 'port' missing"** — The upstream module references `cfg.port`
without defining it as an option. Don't use `openFirewall = true`; manage the
firewall manually in your wrapper.

**Service not accessible:**

```bash
sudo iptables -L -n | grep <port>    # Check firewall
sudo ss -tlnp | grep <port>          # Verify service is listening
sudo journalctl -u traefik -f        # Check Traefik logs
curl http://localhost:<port>         # Test locally
```

**Flake check fails on new file** — New files must be `git add`-ed before
`nix flake check` can see them.
