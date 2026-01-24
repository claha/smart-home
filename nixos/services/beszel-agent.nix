{ ... }:

{
  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    environment = {
      KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG2+g6mI8KiRIcCCOxAJU8OMPSvEy0ks33cayUAKPP8";
    };
  };
}
