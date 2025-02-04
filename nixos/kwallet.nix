{ config, pkgs, ... }:

{
  services.gnome.gnome-keyring.enable = true;
  security = {
    pam.services = {
      sddm.enableKwallet = true;
      hyprland.enableGnomeKeyring = true;
      kwallet = {
        name = "kdewallet";
        enableKwallet = true;
      };
    };
  };
  programs = {
    nix-ld.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}

