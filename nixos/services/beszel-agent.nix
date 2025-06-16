{ ... }:

{
  imports =
    [
      ../modules/beszel-agent.nix
    ];

  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    environment = {
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1TvfFNIIKvB89ZLxUx1X8Psam7Q/e0XqcwIymSnTOi";
    };
  };
}
