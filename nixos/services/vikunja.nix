{ self, config, ... }:
{
  services = {
    vikunja = {
      enable = true;
      frontendScheme = "https";
      frontendHostname = "vikunja.hallstrom.duckdns.org";
    };
  };
  networking.firewall.allowedTCPPorts = [ config.services.vikunja.port ];
}
