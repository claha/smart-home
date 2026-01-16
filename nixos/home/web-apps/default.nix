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
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png";
        sha256 = "sha256-TogafwFxgWgUOHSNJAkkChBOF2SGCEe0nolK+sAy9a0=";
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
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-gemini.png";
        sha256 = "sha256-5sV/u5bwvqZULMiGLjbyXZ8D7y7K6fJ0sPgJAYFwV+8=";
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
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png";
        sha256 = "sha256-76HQVfcmqUniwXKBC/E5DiaIdUMR0K3oVWA26HwSdfA=";
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
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/grok.png";
        sha256 = "sha256-c8qACA47PbWONCVlVSRFzdceWHGwi9KvJSLoTkOTNpE=";
      }).outPath;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "Grok";
  };

  xdg.desktopEntries.homepage = {
    name = "Homepage";
    genericName = "Homepage";
    comment = "Homepage";
    exec = "${pkgs.brave}/bin/brave --app=https://homepage.hallstrom.duckdns.org --class=Homepage";
    icon =
      (pkgs.fetchurl {
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/homepage.png";
        sha256 = "sha256-iXO7laQGKs9NgUT6dEfxWpfBY/BRS1OmnIPUfynmMCc=";
      }).outPath;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "Homepage";
  };
}
