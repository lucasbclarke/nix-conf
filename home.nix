{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./usr/zsh.nix
    ./usr/i3.nix
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

  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "Adwaita-dark";
    COLORTERM = "truecolor";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    QT_QPA_PLATFORMTHEME = "gtk2";
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
        border_width = 0;
      };

      style = ''
        window {
          margin: 0px;
          background-color: #191724;
          border-radius: 0px;
          border: 0px solid #ebbcba;
          color: #e0def4;
          font-family: 'Jetbrains Nerd Font';
          font-size: 20px;
        }

        #input {
          margin: 5px;
          border-radius: 0px;
          border: none;
          border-radius: 0px;;
          color: #eb6f92;
          background-color: #26233a;
        }
        
        #inner-box {
          margin: 5px;
          border: none;
          background-color: #26233a;
          color: #191724;
          border-radius: 0px;
        }
        
        #outer-box {
          margin: 15px;
          border: none;
          background-color: #191724;
        }
        
        #scroll {
          margin: 0px;
          border: none;
        }
        
        #text {
          margin: 5px;
          border: none;
          color: #e0def4;
        } 
        
        #entry:selected {
          background-color: #ebbcba;
          color: #191724;
          border-radius: 0px;;
          outline: none;
        }
        
        #entry:selected * {
          background-color: #ebbcba;
          color: #191724;
          border-radius: 0px;;
          outline: none;
        }
      '';
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
   
  xdg.configFile."quickshell/shell.qml".source = ./quickshell/shell.qml;
  programs.home-manager.enable = true;
}
