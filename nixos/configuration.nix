# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # TODO: figure this out
      # nixos-hardware.nixosModules.framework-16-7040-amd
      ./hardware-configuration.nix
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
    lf
    wget

    # Framework
    framework-tool
    fw-ectool
  ];

  # User settings and packages
  users.users.michael = {
    isNormalUser = true;
    description = "Michael Miller";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      fzf
      git
      unzip
      tmux
      discord
    ];
  };

  # vim
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # Streaming
  programs.obs-studio = {
    enable = true;
  };

  # Browser
  programs.firefox.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
