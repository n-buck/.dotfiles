{ config, pkgs, ... }:

{
  programs = {
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
    waybar.enable = true;
  };

  services.displayManager.defaultSession = "hyprland-uwsm";
  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpolkitagent
  ];
}
