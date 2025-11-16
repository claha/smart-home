{ config, ... }:
{
  users.users.claes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets.user-claes-password.path;
  };
}
