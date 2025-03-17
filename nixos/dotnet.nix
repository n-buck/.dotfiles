{ config, lib, pkgs, ... }:

let dotnet = pkgs.dotnetCorePackages.combinePackages [
  pkgs.dotnetCorePackages.dotnet_8.sdk
  pkgs.dotnetCorePackages.dotnet_9.sdk
];
in
{
  environment = with pkgs; {
    systemPackages = 
      [
        dotnet
        powershell
        mono
        quicktype
    ];
    sessionVariables = {
      DOTNET_ROOT = "${dotnet}";
    };
  };
}
