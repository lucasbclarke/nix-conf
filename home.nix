{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./usr/zsh.nix
    ./usr/sway.nix
    ./usr/terminal.nix
    ./usr/nvim/nvim.nix
    ./usr/nvim/keymaps.nix
    ./usr/nvim/cmp.nix
    ./usr/nvim/extraConfig.nix
    inputs.nixvim.homeModules.nixvim
  ];

  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  home.stateVersion = "25.05"; 

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    # Force dark mode for GTK applications
    GTK_THEME = "Adwaita-dark";
    # Set color scheme preference to dark
    COLORTERM = "truecolor";
    # Additional dark mode environment variables
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    QT_QPA_PLATFORMTHEME = "gtk2";
    # Additional dark mode settings
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1";
  };

  programs.wofi = {
      enable = true;
      settings = {
        key_forward = "Ctrl-n";
        key_backward = "Ctrl-p";
        key_exit = "Ctrl-x";
        # Dark theme configuration
        width = 600;
        height = 400;
        location = "center";
        allow_markup = true;
        no_actions = false;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = false;
        allow_images = true;
        image_size = 40;
        gtk_dark = true;
        # Use a dark color scheme
        background_color = "#191724";
        text_color = "#e0def4";
        selected_color = "#ebbcba";
        selected_text_color = "#191724";
        border_color = "#26233a";
        border_width = 2;
      };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    # Force dark mode for GTK applications
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  programs.foot = {
      enable = true;
      settings = {
        main.font = "monospace:size=14";
      };

      
  };

  programs.nixvim.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
