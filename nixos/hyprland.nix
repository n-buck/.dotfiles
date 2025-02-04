{ config, pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    waybar.enable = true;
    hyprlock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
  ];
}
