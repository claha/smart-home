let
  chewbacca = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKrVgUdJlyiqFnzWQdp1wqdfInM2f2zObzQR/NY6apoo";
  claes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGO2k5rXeGp/j8osRdxDfsv6GJ3ngmMic2yalepytUzb";
in
{
  "duckdns-token.age".publicKeys = [ chewbacca claes ];
}
