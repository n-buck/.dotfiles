{ config, lib, pkgs, ... }:

{
  environment = with pkgs; {
    systemPackages = [ dotnetCorePackages.dotnet_8.sdk powershell ];
    sessionVariables = {
      DOTNET_ROOT = "${dotnetCorePackages.dotnet_8.sdk}";
    };
  };
}
