{ config, lib, pkgs, ... }:
{
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors = {
        webpage = {
          bg = "black";
          darkmode = {
            enabled = true;
            policy.images = "never";
          };
        };
      };
      #      fonts = {
      #        default_family = "TerminessNerdFontMono";
      #        default_size = "20px";
      #      };
      hints.uppercase = true;
      scrolling = {
        bar = "never";
        smooth = true;
      };
      tabs.show = "never";
    };
  };
}
