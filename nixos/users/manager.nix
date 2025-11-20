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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwSq5lZGTwwD48EwSs+/go931lbRpi5yVuRJQR6rD3d"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlhYm7+ZyPcFTCjqpgz3QPgedfSEq1M6dkNKY0way69"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHk3L/1g9kKtaEK5qDKrLZlZduOQ2z4t8vyfz4geIhJ"
    ];
  };
}
