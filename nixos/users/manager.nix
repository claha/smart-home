{ config, ... }:
{
  users.users.manager = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-manager-password.path;
    extraGroups = [
      "wheel"
      "networkmanager"
      "transmission"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGO2k5rXeGp/j8osRdxDfsv6GJ3ngmMic2yalepytUzb"
    ];
  };
}
