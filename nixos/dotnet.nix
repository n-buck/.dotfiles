{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dotnetCorePackages.sdk_8_0_3xx
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet/";
  };
}
