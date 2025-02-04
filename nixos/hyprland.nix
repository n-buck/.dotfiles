{ config, pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
    waybar
  ];
}
