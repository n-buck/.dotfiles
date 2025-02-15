# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hyprland.nix
    ];

  programs = {
    firefox.enable = true;
    steam = {
      enable = true;
    };
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git" "sudo" "docker" "kubectl"];
        theme = "robbyrussell";
      };
    };
    obs-studio = {
      enable = true;
    };
  };

  users.users.nico.packages = with pkgs; [
    audacity
    azuredatastudio
    discord
    google-chrome
    ipmiview
    jetbrains.webstorm
    jetbrains.rider
    nodejs_22
    obsidian
    plexamp
    puddletag
    teams-for-linux
  ];

  environment.systemPackages = with pkgs; [
    pamixer
    swappy
    slurp
    grim
    swaynotificationcenter
    networkmanagerapplet
    kitty
    stow
    wofi
    killall
    git
    vim
    wget
    htop
    cava
    kwallet-pam
    nextcloud-client
    wl-clipboard
    smplayer
    mpv
    lshw
    wlsunset
    gnused
    smartmontools
    gparted
    playerctl
    wev
    kdePackages.ark
  ];
}
