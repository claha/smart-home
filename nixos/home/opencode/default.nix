{
  config,
  lib,
  pkgs,
  domain,
  ...
}:

let
  port = 8199;
in
{
  age.secrets = {
    openrouter-api-key.file = ../../secrets/openrouter-api-key.age;
    hyper-api-key.file = ../../secrets/hyper-api-key.age;
  };

  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    web = {
      enable = true;
      extraArgs = [
        "--hostname"
        "0.0.0.0"
        "--port"
        (toString port)
        "--cors"
        "https://opencode-%H.${domain}"
      ];
    };
  };

  # Declarative API keys for the web service. Upstream only accepts a
  # single web.environmentFile, so attach both decrypted secrets here.
  # %t is systemd's specifier for $XDG_RUNTIME_DIR, where agenix
  # home-manager symlinks the secrets.
  systemd.user.services.opencode-web = {
    Unit.After = [ "agenix.service" ];
    Service.EnvironmentFile = [
      "%t/agenix/openrouter-api-key"
      "%t/agenix/hyper-api-key"
    ];
  };
}
