{ config, pkgs, ... }:

{
  boot.kernelModules = ["sg"];
  boot.loader = {
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
