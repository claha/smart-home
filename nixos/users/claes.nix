{ config, ... }:
{
  users.users.claes = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
      "input"
    ];
    hashedPasswordFile = config.age.secrets.user-claes-password.path;
  };
}
