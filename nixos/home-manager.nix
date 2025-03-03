{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.users.nico = { pkgs, ... }: {
    xdg.desktopEntries.screenshot = {
      name = "Screenshot";
      genericName = "Screenshot";
      exec = "/home/nico/.scripts/screenshot.sh";
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" ];
      icon = "camera-photo.svg";
    };
    services.easyeffects.enable = true;
    home.stateVersion = "24.11";
  };
  programs.dconf.enable = true;
}

