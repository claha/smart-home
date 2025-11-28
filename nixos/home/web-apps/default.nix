{ pkgs, ... }:

let
  # Helper: choose icon directly if present, otherwise fetch from url.
  mkIcon = app:
    if app ? icon then
      app.icon
    else
      (pkgs.fetchurl {
        url = app.iconUrl;
        sha256 = app.sha256;
      }).outPath;

  # Build the desktop entry we care about for each app.
  mkEntry = app: {
    name = app.displayName;
    exec = "${pkgs.brave}/bin/brave --app=${app.url} --class=${if app ? class then app.class else app.displayName}";
    icon = mkIcon app;
    type = "Application";
  };

  # Add apps here. For simple icon names use `icon = "name"`. For external images use iconUrl + sha256.
  apps = {
    "nixos-search" = {
      displayName = "NixOS Search";
      url = "https://search.nixos.org";
      icon = "nix-snowflake";
      class = "NixosSearch";
    };

    chatgpt = {
      displayName = "ChatGPT";
      url = "https://chatgpt.com";
      iconUrl = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/chatgpt-icon.png";
      sha256 = "sha256-1zPcj1WU3ZGNnesllYgyc2cvy55Mliho4bsjH3yeCtY=";
      class = "ChatGPT";
    };

    gemini = {
      displayName = "Google Gemini";
      url = "https://gemini.google.com";
      iconUrl = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-gemini-icon.png";
      sha256 = "sha256-aRiw7eFUpaooEPa4TTVA97A8ftyaiVFa7e1r4gR2PnA=";
      class = "Gemini";
    };

    claude = {
      displayName = "Claude AI";
      url = "https://claude.ai";
      iconUrl = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/claude-ai-icon.png";
      sha256 = "sha256-OZU3i6GPgtPgz8qfTG2tCcndcTqac00ZWEclww+jdTY=";
      class = "Claude";
    };

    grok = {
      displayName = "Grok";
      url = "https://grok.com";
      iconUrl = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/grok-icon.png";
      sha256 = "sha256-y7/ntZ8mQc0cXw8nj4GTvKn/KeXln3wy8o4rJ7ryNiQ=";
      class = "Grok";
    };
  };
 in
{
  home.packages = [ pkgs.brave ];

  # Map apps into xdg.desktopEntries with the same keys
  xdg.desktopEntries = builtins.mapAttrs (name: app: mkEntry app) apps;
}