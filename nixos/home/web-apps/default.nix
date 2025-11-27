{ pkgs, ... }:

{
  home.packages = [ pkgs.brave ];

  xdg.desktopEntries.nixos-search = {
    name = "NixOS Search";
    genericName = "Search NixOS packages";
    comment = "Search for NixOS packages, options, and more";
    exec = "${pkgs.brave}/bin/brave --app=https://search.nixos.org --class=NixosSearch";
    icon = "brave-browser";
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
    icon = "brave-browser";
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
    icon = "brave-browser";
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
    icon = "brave-browser";
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
    icon = "brave-browser";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    settings.StartupWMClass = "Grok";
  };
}
