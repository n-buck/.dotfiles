{ config, pkgs, ... }:

{
  security = {
    pam.services = {
      sddm.enableKwallet = true;
      kwallet = {
        name = "kdewallet";
        enableKwallet = true;
      };
    };
  };
}
