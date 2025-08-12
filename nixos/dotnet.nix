{ config, lib, pkgs, ... }:

let dotnet = pkgs.dotnetCorePackages.combinePackages [
  pkgs.dotnetCorePackages.dotnet_8.sdk
  pkgs.dotnetCorePackages.dotnet_9.sdk
];
in
{
  programs.java.enable = true;
  environment = with pkgs; {
    systemPackages = 
      [
        dotnet
#        dotnetCorePackages.dotnet_9.sdk
        powershell
        mono
        quicktype
    ];
    sessionVariables = {
      DOTNET_ROOT = "${dotnet}";
    };
  };
}
