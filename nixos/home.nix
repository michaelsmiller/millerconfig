{ config, pkgs, pkgs-unfree, inputs, ... }:

{
  programs.home-manager = {
    enable = true;
  };
  home.stateVersion = "26.05"; # Changing this will change defaults
  home.username = "michael";
  home.homeDirectory = "/home/michael";


  # packages in user space
  home.packages = [
      # terminal utilities
      pkgs.fzf
      pkgs.unzip
      pkgs.zip
      pkgs.xclip
      pkgs.git
      pkgs.htop
      pkgs.tmux

      pkgs.inkscape

      pkgs.vesktop
      pkgs.brave
      pkgs-unfree.spotify

      # school
      pkgs-unfree.stm32cubemx
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  }; 

  programs.firefox = {
    enable = true;
    package = pkgs-unfree.wrapFirefox inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin.unwrapped {
      extraPolicies = {
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks addons except for those here
          "uBlock0@raymondhill.net" = {
            install_url = "https:addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "ImprovedTube" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-addon/latest.xpi";
            installation_mode = "force_installed";
          };
          "LeechBlock" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/leechblock-ng/latest.xpi";
            installation_mode = "force_installed";
            # TODO: Add youtube config here
          };
        };
        AppAutoUpdate = false;
        DisablePocket = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "gfx.color_management.native_srgb" = true;

          # nightly-only
          "sidebar.revamp" = true; # Not sure what this means
          "sidebar.verticalTabs" = true; # sidebar tabs instead of horizontal
          "sidebar.main.tools" = "syncedtabs"; # just have a button for synced tabs
        };
      };
    };
  };

  # Desktop settings

  # dconf = {
  #   enable = true;
  #   settings = {
  #     "org/gnome/desktop/peripherals/mouse" = {
  #       natural-scroll = false;
  #     };
  #     "org/gnome/desktop/peripherals/touchpad" = {
  #       natural-scroll = false; # "Gnome calls the good way "traditional"
  #     };
  #     "org/gnome/desktop/interface" = {
  #       color-scheme = "prefer-dark";
  #     };

  #     "org/gnome/ally/magnifier" = {
  #       mag-factor = 1.5;
  #     };

  #     # Terminal
  #     "org/gnome/Console" = {
  #       font-scale = 1.2;
  #     };

  #     # Gestures, like 3 finger swipe
  #     "org/gnome/shell" = {
  #       enabled-extensions = ["x11gestures@joseexposito.github.io"];
  #     };
  #   };
  # };

  # Link dotfiles from nix store to local directory...
  home.file = {
  };

  # This is for shells created by home-manager
  home.sessionVariables = {
    EDITOR = "vim";
  };

}
