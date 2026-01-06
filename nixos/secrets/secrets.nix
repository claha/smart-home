let
  naruto = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwSq5lZGTwwD48EwSs+/go931lbRpi5yVuRJQR6rD3d"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrRe8L+iqVPs43Ax+B7z97H4I0W+0MwrfXz6OpVcb34"
  ];
  claes = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGO2k5rXeGp/j8osRdxDfsv6GJ3ngmMic2yalepytUzb"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXxs27iBNhUjfPK55mGV+SXfdfco7auHTcBNZPUrbvf"
  ];
  luffy = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlhYm7+ZyPcFTCjqpgz3QPgedfSEq1M6dkNKY0way69"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWCgyl+ULikm6SQdNFAHB80ffrpcu4fwVk7l+epZckl"
  ];
  eren = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHk3L/1g9kKtaEK5qDKrLZlZduOQ2z4t8vyfz4geIhJ"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDFtb0gNaYyFPHK/mYjdpdvcLxUf6kiEhTAF8FXHwHV"
  ];
in
{
  "bashrc.age".publicKeys = claes ++ naruto ++ luffy ++ eren;
  "duckdns-token.age".publicKeys = claes ++ luffy;
  "user-claes-password.age".publicKeys = claes;
  "user-manager-password.age".publicKeys = claes ++ naruto ++ luffy ++ eren;
}
