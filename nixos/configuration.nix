# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unfree, inputs, ... }:

{
  imports = [
    # TODO: figure this out
    ./hardware-configuration.nix # generated
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = "24.11"; # default values, we override these in this file
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # needed for flakes

  services.fwupd.enable = true; # Recommended for updating Linux firmware (required for Framework)

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "hydrogen";


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # X11
  services.xserver.enable = true; # turns X11 on (as opposed to Wayland)
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # For some reason I also needed to explicitly turn Wayland off
  services.xserver.displayManager.gdm.wayland = false;

  # Keyboard input
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.libinput.enable = true; # touchpad input

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # for noise cancelation
  programs.noisetorch.enable = true; # needs root access

  environment.systemPackages = with pkgs; [
    lf # directory search thing in terminal
    wget # required for a ton of shit
    jq # required for running PIA with wireguard
    home-manager
    # wireguard-tools

    touchegg
    gnomeExtensions.x11-gestures 

    # Framework
    framework-tool
    fw-ectool

    # development
    gdb

    vesktop
  ];

  services.touchegg.enable = true; # finger gestures on touch-pad

  # FHS stuff, for development
  services.envfs.enable = true; # envfs fills out local variables
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      zstd
      util-linux
      libGL
      glibc
      xorg.libX11
    ];
  };

  environment.etc = {
    "ld.so.conf" = {
      # nix-ld puts symlinks of libraries we add in this directory.
      # The jai compiler checks /etc/ld.so.conf for where to look for libraries
      # first, so the easiest place to make sure it finds them is to create this file
      text = ''
        /run/current-system/sw/share/nix-ld/lib
      '';
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [ "--update-input" "nixpkgs" ];
    dates = "04:00";
    # randomizedDelaySec = "45min";
    # allowReboot = true;
  };


  # User settings and packages
  users.users.michael = {
    isNormalUser = true;
    description = "Michael Miller";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Steam
  programs.steam = {
    package = pkgs-unfree.steam;
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # NOTE: last time I tried this it caused crashes in videogames
  # programs.gamemode.enable = true;

  # vim
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs-unfree ; };
    users = {
      michael = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
