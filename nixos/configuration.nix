# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
#      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "alt-intl";
  # };
  
# Configure console keymap
#  console.keyMap = "dvorak";

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  security = {
    pam.services = {
      sddm.enableKwallet = true;
      kwallet = {
        name = "kdewallet";
        enableKwallet = true;
      };
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # Install firefox.
  programs = {
    firefox.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    waybar.enable = true;
    hyprlock.enable = true;
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
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    hyprpaper
    git
    vim
    wget
    htop
    cava
    kwallet-pam
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  fonts.packages = with pkgs; [
    nerdfonts
#    nerd-fonts.Hack
#    nerd-fonts.DejaVuSansMono
  ];
}
