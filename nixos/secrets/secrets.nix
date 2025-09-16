let
  naruto = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwSq5lZGTwwD48EwSs+/go931lbRpi5yVuRJQR6rD3d"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKrVgUdJlyiqFnzWQdp1wqdfInM2f2zObzQR/NY6apoo"
  ];
  claes = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGO2k5rXeGp/j8osRdxDfsv6GJ3ngmMic2yalepytUzb"
  ];
  luffy = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlhYm7+ZyPcFTCjqpgz3QPgedfSEq1M6dkNKY0way69"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWCgyl+ULikm6SQdNFAHB80ffrpcu4fwVk7l+epZckl"
  ];
in
{
  "duckdns-token.age".publicKeys = naruto ++ claes ++ luffy;
}
