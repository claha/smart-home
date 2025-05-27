{ ... }:

{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.hallstrom.duckdns.org";
      listen-http = ":2586";
      behind-prxy = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 2586 ];
}
