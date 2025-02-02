{ config, pkgs, ... }:

{
  services.rpcbind.enable = true;
  systemd.mounts = let commonMountOptions = {
    type = "nfs";
    mountConfig = {
      Options = "noatime";
    };
  };

  in

  [
    (commonMountOptions // {
      what = "192.168.1.47:/mnt/Nas_Storage/Media";
      where = "/mnt/media";
    })

    (commonMountOptions // {
      what = "192.168.1.47:/mnt/Nas_Storage/Downloads";
      where = "/mnt/downloads";
    })

    (commonMountOptions // {
      what = "192.168.1.47:/mnt/Nas_Storage/Iso";
      where = "/mnt/iso";
    })
  ];

  systemd.automounts = let commonAutoMountOptions = {
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "300";
    };
  };

  in

  [
    (commonAutoMountOptions // { where = "/mnt/media"; })
    (commonAutoMountOptions // { where = "/mnt/downloads"; })
    (commonAutoMountOptions // { where = "/mnt/iso"; })
  ];

  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
}
