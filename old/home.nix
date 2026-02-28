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
        border_width = 2;
      };

      style = ''
        window {
          margin: 0px;
          background-color: #191724;
          border-radius: 0px;
          border: 2px solid #ebbcba;
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

  services.swaync = {
      enable = true;
    style = ''
      * {
        all: unset;
        font-family: FiraCode Nerd Font;
        transition: 0.3s;
        font-size: 1.2rem;
      }

    .floating-notifications.background .notification-row {
      padding: 1rem;
    }

    .floating-notifications.background .notification-row .notification-background {
      border-radius: 0.5rem;
      background-color: #191724;
      color: #e0def4;
      border: 1px solid #6e6a86;
    }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification {
        padding: 0.5rem;
        border-radius: 0.5rem;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification.critical {
        border: 1px solid #eb6f92;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      .notification-content
      .summary {
        margin: 0.5rem;
        color: #e0def4;
        font-weight: bold;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      .notification-content
      .body {
        margin: 0.5rem;
        color: #908caa;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > * {
        min-height: 3rem;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > *
      .notification-action {
        border-radius: 0.5rem;
        color: #e0def4;
        background-color: #1f1d2e;
        border: 1px solid #6e6a86;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > *
      .notification-action:hover {
        background-color: #26233a;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > *
      .notification-action:active {
        background-color: #6e6a86;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .close-button {
        margin: 0.5rem;
        padding: 0.25rem;
        border-radius: 0.5rem;
        color: #e0def4;
        background-color: #eb6f92;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .close-button:hover {
        color: #191724;
      }

    .floating-notifications.background
      .notification-row
      .notification-background
      .close-button:active {
        background-color: #ebbcba;
      }

    .control-center {
      border-radius: 0.5rem;
      margin: 1rem;
      background-color: #191724;
      color: #e0def4;
      padding: 1rem;
      border: 1px solid #6e6a86;
    }

    .control-center .widget-title {
      color: #ebbcba;
      font-weight: bold;
    }

    .control-center .widget-title button {
      border-radius: 0.5rem;
      color: #e0def4;
      background-color: #1f1d2e;
      border: 1px solid #6e6a86;
      padding: 0.5rem;
    }

    .control-center .widget-title button:hover {
      background-color: #26233a;
    }

    .control-center .widget-title button:active {
      background-color: #6e6a86;
    }

    .control-center .notification-row .notification-background {
      border-radius: 0.5rem;
      margin: 0.5rem 0;
      background-color: #1f1d2e;
      color: #e0def4;
      border: 1px solid #6e6a86;
    }

    .control-center .notification-row .notification-background .notification {
      padding: 0.5rem;
      border-radius: 0.5rem;
    }

    .control-center
      .notification-row
      .notification-background
      .notification.critical {
        border: 1px solid #eb6f92;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content {
        color: #e0def4;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content
      .summary {
        margin: 0.5rem;
        color: #e0def4;
        font-weight: bold;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content
      .body {
        margin: 0.5rem;
        color: #908caa;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > * {
        min-height: 3rem;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > *
      .notification-action {
        border-radius: 0.5rem;
        color: #e0def4;
        background-color: #1f1d2e;
        border: 1px solid #6e6a86;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > *
      .notification-action:hover {
        background-color: #26233a;
      }

    .control-center
      .notification-row
      .notification-background
      .notification
      > *:last-child
      > *
      .notification-action:active {
        background-color: #6e6a86;
      }

    .control-center .notification-row .notification-background .close-button {
      margin: 0.5rem;
      padding: 0.25rem;
      border-radius: 0.5rem;
      color: #e0def4;
      background-color: #eb6f92;
    }

    .control-center .notification-row .notification-background .close-button:hover {
      color: #191724;
    }

    .control-center
      .notification-row
      .notification-background
      .close-button:active {
        background-color: #ebbcba;
      }

    progressbar,
      progress,
      trough {
        border-radius: 0.5rem;
      }

    .notification.critical progress {
      background-color: #eb6f92;
    }

    .notification.low progress,
      .notification.normal progress {
        background-color: #9ccfd8;
      }

    trough {
      background-color: #1f1d2e;
    }

    .control-center trough {
      background-color: #6e6a86;
    }

    .control-center-dnd {
      margin: 1rem 0;
      border-radius: 0.5rem;
    }

    .control-center-dnd slider {
      background: #26233a;
      border-radius: 0.5rem;
    }

    .widget-dnd {
      color: #908caa;
    }

    .widget-dnd > switch {
      border-radius: 0.5rem;
      background: #26233a;
      border: 1px solid #6e6a86;
    }

    .widget-dnd > switch:checked slider {
      background: #31748f;
    }

    .widget-dnd > switch slider {
      background: #6e6a86;
      border-radius: 0.5rem;
      margin: 0.25rem;
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
