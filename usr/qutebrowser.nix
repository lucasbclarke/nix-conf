{ config, pkgs, lib, ... }:

{
  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser;

    settings = {
      general = {
        private_browsing = true;
      };
      editor = {
        command = [ "ghostty" "-e" "nvim" "{file}" "-c" "normal {line}G{column0}l" ];
      };
      colors = {
        webpage = {
          preferred_color_scheme = "dark";
        };
      };
      urls = {
        start_pages = "https://google.com";
      };
    };

    keyBindings = {
      global = {
        "<ctrl-n>" = "completion-item-focus next";
        "<ctrl-p>" = "completion-item-focus prev";
      };
    };

    extraConfig = ''
      import rosepine
      config.load_autoconfig(False)
      rosepine.setup(c, 'rose-pine', True)
    '';
  };

  xdg.configFile."qutebrowser/rosepine".source = ./qutebrowser/rosepine;
}
