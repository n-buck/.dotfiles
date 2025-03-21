# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:

let unstable-pkgs = import <nixpkgs-unstable> { config = config.nixpkgs.config; };
in
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
    unstable-pkgs.vscode
    audacity
    azuredatastudio
    discord
    easyeffects
    google-chrome
    ipmiview
    jetbrains.webstorm
    jetbrains.rider
    nodejs_22
    obsidian
    plexamp
    puddletag
    texlive.combined.scheme-full
    teams-for-linux
    vulkan-tools
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
