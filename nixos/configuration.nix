# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    # TODO: figure this out
    # nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = "24.11"; # default values, we override these in this file
  nixpkgs.config.allowUnfree = true; # allow "unfree" packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # needed for flakes

  services.fwupd.enable = true; # Recommended for updating Linux firmware (required for Framework)

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "hydrogen";
  networking.networkmanager.enable = true;

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


  environment.systemPackages = with pkgs; [
    lf # directory search thing in terminal
    wget # required for a ton of shit
    pkgs.home-manager

    # Framework
    framework-tool
    fw-ectool
  ];

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
    packages = with pkgs; [
    ];
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # vim
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      michael = import ./home.nix;
    };
  };


  # TODO: create home-manager BS and add this there

}
