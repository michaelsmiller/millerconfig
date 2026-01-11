# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unfree, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix # generated
    # inputs.nixos-hardware.nixosModules.framework-16-7040-amd # TODO: pull out
    inputs.disko.nixosModules.disko ./disko-config.nix # disk configuration
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = "26.05"; # default values, we override these in this file
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # needed for flakes

  # services.fwupd.enable = true; # Recommended for updating Linux firmware (required for Framework)

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  # networking.hostName = "hydrogen";
  networking.hostName = "genghis";


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

  # Nvidia
  hardware.graphics.enable = true;
  hardware.nvidia = {
    package = pkgs-unfree.linuxPackages.nvidiaPackages.stable;

    modesetting.enable = true; # need kernel modesetting
    powerManagement.enable = true; # Saves VRAM to /tmp when sleeping
    open = true; # use open source kernel module
    nvidiaSettings = true;
  };
  boot.kernelParams = [ "module_blacklist=amdgpu" ]; # If there are black screen issues, maybe this will fix it


  services.xserver = {
    enable = true;

    ##### X11 / Gnome
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;
    # displayManager.gdm.wayland = false; # turn off Wayland

    xkb = {
      # keyboard layout
      layout = "us";
      variant = "";
    };
    videoDrivers = ["nvidia"]; # not sure if this is necessary
    # extraConfig = ''
    # xrandr --output HDMI-A-1 --mode "3840x2160" --rate 119.86
    # '';
  };


  # Wayland / Plasma
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  environment.variables = {
    __NV_DISABLE_EXPLICIT_SYNC=1; # Needed for OBS + Wayland + Nvidia to work properly
  };


  # services.libinput.enable = true; # touchpad input
  # services.touchegg.enable = true; # finger gestures on touch-pad

  # This is necessary to interact with a specific STM32 microchip
  # My user needs write access to flash code to it and by default
  # only root can do that
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0666"
  '';

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
    gnumake
    usbutils # lsusb
    home-manager

    #### Laptop stuff
    # touchegg
    # gnomeExtensions.x11-gestures 
    # framework-tool
    # fw-ectool

    # development
    gdb
    clang
    gcc-arm-embedded

    # Wayland
    wl-clipboard

    # Discord replacement, requires some weird permissions
    # vesktop

    # steam related
    mangohud # performance monitoring
    protonup-qt # installing custom proton versions
  ];

  # Steam
  programs.steam = {
    package = pkgs-unfree.steam;
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



  # FHS stuff, for software development
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

      llvmPackages.libclang
      libcxx

      cairo
      freetype
    ];
  };

  environment.etc = {
    "ld.so.conf" = {
      # nix-ld puts symlinks of libraries we add in the specific folder below.
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
    allowReboot = false;
  };


  # User settings and packages
  users.users.michael = {
    isNormalUser = true;
    description = "Michael Miller";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs-unfree ; };
    users = {
      michael = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
  };
}
