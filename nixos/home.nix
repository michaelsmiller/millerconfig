{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "24.11"; # Changing this will change defaults
  home.username = "michael";
  home.homeDirectory = "/home/michael";

  nixpkgs.config.allowUnfree = true; # copied from main config


  # packages in user space
  home.packages = [
      pkgs.fzf
      pkgs.git
      pkgs.unzip
      pkgs.tmux
      pkgs.discord
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  }; 

  programs.firefox = {
    enable = true;
  };

  # Desktop settings

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = false;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false; # "Gnome calls the good way "traditional"
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # Link dotfiles from nix store to local directory...
  home.file = {
  };

  # This is for shells created by home-manager
  home.sessionVariables = {
    EDITOR = "vim";
  };

}
