{ config, pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

#  services.ratbagd.enable = true;
  services.input-remapper.enable = true;

  hardware.logitech.wireless.enable = true;

  environment.systemPackages = [
#    piper
#    input-remapper
    pkgs.solaar
  ];

  networking = {
    nameservers = ["192.168.1.1" "8.8.8.8"];
    hostName = "nico-desktop"; # Define your hostname.
  };

  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/nvme0";
      }
      {
        device = "/dev/nvme1";
      }
    ];
  };

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024; # 16GB
  }];
}
