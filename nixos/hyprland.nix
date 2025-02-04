{ config, pkgs, ... }:

{
  programs = {
    uwsm.enable = true;
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
