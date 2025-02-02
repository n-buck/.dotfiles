{ config, pkgs, ... }:

{
  users.users.nico = {
    isNormalUser = true;
    description = "Nicolai Buck";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
}
