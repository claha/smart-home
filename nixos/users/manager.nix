{ ... }:
{
  users.users.manager = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$D5CRBA/vPHr4T6/w5HnT01$i40sRhN/QRq51HD5m8F8YCnhEVdUAvomcNWOcpTpEm1";
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
