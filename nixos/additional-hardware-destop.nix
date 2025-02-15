{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_12;

#  services.ratbagd.enable = true;
  services.input-remapper.enable = true;

  hardware.logitech.wireless.enable = true;
  environment.systemPackages = [
#    piper
#    input-remapper
    pkgs.solaar
  ];

  networking = {
    defaultGateway = "192.168.1.1";
    nameservers = ["192.168.1.1" "8.8.8.8"];
    interfaces = {
      enp7s0.ipv4.addresses = [ {
        address = "192.168.1.15";
        prefixLength = 24;
      } ];
      wlp14s0.ipv4.addresses = [ {
        address = "192.168.1.16";
        prefixLength = 24;
      } ];
    };
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

}
