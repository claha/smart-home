{ pkgs, ... }:

{
  home.packages = [ pkgs.brave ];

  xdg.desktopEntries.nixos-search = {
    name = "NixOS Search";
    genericName = "Search NixOS packages";
    comment = "Search for NixOS packages, options, and more";
    exec = "${pkgs.brave}/bin/brave --app=https://search.nixos.org --class=NixosSearch";
    icon = "nix-snowflake";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "NixosSearch";
  };

  xdg.desktopEntries.chatgpt = {
    name = "ChatGPT";
    genericName = "ChatGPT";
    comment = "ChatGPT";
    exec = "${pkgs.brave}/bin/brave --app=https://chatgpt.com --class=ChatGPT";
    icon =
      (pkgs.fetchurl {
        url = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/chatgpt-icon.png";
        sha256 = "sha256-1zPcj1WU3ZGNnesllYgyc2cvy55Mliho4bsjH3yeCtY=";
      }).outPath;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "ChatGPT";
  };

  xdg.desktopEntries.gemini = {
    name = "Google Gemini";
    genericName = "Google Gemini";
    comment = "Google Gemini";
    exec = "${pkgs.brave}/bin/brave --app=https://gemini.google.com --class=Gemini";
    icon =
      (pkgs.fetchurl {
        url = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-gemini-icon.png";
        sha256 = "sha256-aRiw7eFUpaooEPa4TTVA97A8ftyaiVFa7e1r4gR2PnA=";
      }).outPath;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "Gemini";
  };

  xdg.desktopEntries.claude = {
    name = "Claude AI";
    genericName = "Claude AI";
    comment = "Claude AI";
    exec = "${pkgs.brave}/bin/brave --app=https://claude.ai --class=Claude";
    icon =
      (pkgs.fetchurl {
        url = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/claude-ai-icon.png";
        sha256 = "sha256-OZU3i6GPgtPgz8qfTG2tCcndcTqac00ZWEclww+jdTY=";
      }).outPath;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "Claude";
  };

  xdg.desktopEntries.grok = {
    name = "Grok";
    genericName = "Grok";
    comment = "Grok";
    exec = "${pkgs.brave}/bin/brave --app=https://grok.com --class=Grok";
    icon =
      (pkgs.fetchurl {
        url = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/grok-icon.png";
        sha256 = "sha256-y7/ntZ8mQc0cXw8nj4GTvKn/KeXln3wy8o4rJ7ryNiQ=";
      }).outPath;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "Grok";
  };
}
