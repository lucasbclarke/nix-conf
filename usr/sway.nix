{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
      config = rec {
        modifier = "Mod4";
        terminal = "ghostty";
        menu = "${../sway/launcher.sh}";

        # Startup commands (including previous exec_always and exec)
        startup = [
          { command = "~/nix-conf/sway/setup-displays.sh"; always = true; }
          { command = "/usr/bin/win &"; always = true; }
          { command = "ghostty"; }
          { command = "sleep 0.5 && swaymsg workspace number 1"; }
        ];

        # Assign Ghostty windows to workspace 1
        assigns = {
          "1" = [ { app_id = "ghostty"; } ];
        };

        # Workspaces and window management keybindings
        keybindings = {
          # Apps and system
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+b" = "exec brave";
          "${modifier}+Shift+d" = "exec Discord";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
          "${modifier}+p" = "exec powersupply";
          "${modifier}+Shift+p" = "exec poweroff";
          "${modifier}+Shift+r" = "exec reboot";
          "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\"";

          # Focus movement (hjkl)
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move containers
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Workspaces
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          # Move container to workspaces
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          # Layout and modes
          "${modifier}+g" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+f" = "fullscreen";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";
          "${modifier}+r" = "mode resize";
        };

        modes = {
          resize = {
            "h" = "resize shrink width 10px";
            "j" = "resize grow height 10px";
            "k" = "resize shrink height 10px";
            "l" = "resize grow width 10px";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
        };

        # General fonts for sway
        fonts = {
          names = [ "JetBrainsMono Medium" ];
          size = 11.0;
        };

        # Bar configuration
        bars = [
          {
            position = "bottom";
            statusCommand = "i3status";
            fonts = {
              names = [ "JetBrainsMono Medium" ];
              size = 11.0;
            };
            colors = {
              statusline = "#ffffff";
              background = "#323232";
              inactiveWorkspace = {
                border = "#32323200";
                background = "#32323200";
                text = "#5c5c5c";
              };
            };
          }
        ];

        # Outputs
        output = {
          "Virtual-1" = { mode = "1440x900"; };
          "HDMI-A-1" = { mode = "1920x1080"; };
          "eDP-1" = { mode = "1440x900"; };
        };

        # Client colors (approximate mapping from your scheme)
        colors = {
          focused = {
            border = "#ebbcba";
            background = "#191724";
            text = "#e0def4";
            indicator = "#ebbcba";
            childBorder = "#ebbcba";
          };
          focusedInactive = {
            border = "#1f1d2e";
            background = "#191724";
            text = "#e0def4";
            indicator = "#908caa";
            childBorder = "#1f1d2e";
          };
          unfocused = {
            border = "#26233a";
            background = "#191724";
            text = "#e0def4";
            indicator = "#26233a";
            childBorder = "#26233a";
          };
          urgent = {
            border = "#eb6f92";
            background = "#191724";
            text = "#e0def4";
            indicator = "#eb6f92";
            childBorder = "#eb6f92";
          };
        };
      };
      # Extra lines for settings not directly mapped by HM options
      extraConfig = ''
        titlebar_padding 5 1

        # Media and brightness keys (need --locked flag)
        bindsym --locked XF86AudioMute exec pactl set-sink-mute \@DEFAULT_SINK\@ toggle
        bindsym --locked XF86AudioLowerVolume exec pactl set-sink-volume \@DEFAULT_SINK\@ -5%
        bindsym --locked XF86AudioRaiseVolume exec pactl set-sink-volume \@DEFAULT_SINK\@ +5%
        bindsym --locked XF86AudioMicMute exec pactl set-source-mute \@DEFAULT_SOURCE\@ toggle
        bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
        bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+

        input type:touchpad {
          events enabled
          pointer_accel 0
          accel_profile adaptive
          natural_scroll disabled
          left_handed disabled
          scroll_factor 1
          middle_emulation disabled
          scroll_method two_finger
          dwt enabled
          tap enabled
          tap_button_map lrm
          click_method button_areas
        }
      '';
  };

}
