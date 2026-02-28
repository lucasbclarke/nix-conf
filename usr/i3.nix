# i3 config matching Sway setup from https://github.com/lucasbclarke/nix-conf (look & behaviour)
{ config, lib, pkgs, ... }:

let
  modifier = "Mod4";
  terminal = "ghostty";
  menu = "${config.xdg.configHome}/i3/launcher.sh";
  startGhostty = "${config.xdg.configHome}/i3/start-ghostty.sh";
  setupDisplays = "${config.xdg.configHome}/i3/setup-displays.sh";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      inherit modifier terminal;
      menu = menu;

      # Startup: display setup (HDMI/eDP), Ghostty on workspace 1, quickshell
      startup = [
        { command = "${setupDisplays} &"; always = true; }
        { command = startGhostty; always = false; }
        { command = "qs &"; always = false; }
        { command = "win &"; always = false; }
      ];

      # Assign Ghostty to workspace 1 (WM_CLASS is "ghostty" / "com.mitchellh.ghostty")
      assigns = {
        "1" = [ { class = "ghostty"; } { class = "com.mitchellh.ghostty"; } ];
      };

      # Keybindings — match Sway layout
      keybindings = lib.mkOptionDefault {
        # Apps and system
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+c" = "restart";
        "${modifier}+b" = "exec brave";
        "${modifier}+q" = "exec qutebrowser";
        "${modifier}+Shift+d" = "exec Discord";
        "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes, exit i3' 'i3-msg exit'";
        "${modifier}+p" = "exec powersupply";
        "${modifier}+Shift+p" = "exec systemctl poweroff";
        "${modifier}+Shift+r" = "exec systemctl reboot";
        "${modifier}+Shift+s" = "exec maim -s | xclip -selection clipboard -t image/png";

        # Focus (hjkl)
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # Move containers
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Workspaces 1–10
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

        # Layout
        "${modifier}+g" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "exec true";
        "${modifier}+a" = "focus parent";
        "${modifier}+r" = "mode resize";
      };

      # Resize mode (same as Sway)
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

      # Fonts — match Sway (JetBrains Mono)
      fonts = {
        names = [ "JetBrainsMono Nerd Font" "JetBrains Mono" ];
        size = 11.0;
      };

      # No bar (Sway had bars = [])
      bars = [ ];

      # Colors — Rosé Pine (same as Sway)
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

    # Media keys, titlebar, gaps (i3-specific)
    extraConfig = ''
      title_align center
      default_border pixel 0
      gaps inner 8
      gaps outer 4

      # Media and brightness (PipeWire/pactl like Sway)
      bindsym --release XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym --release XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym --release XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym --release XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle
      bindsym --release XF86MonBrightnessDown exec --no-startup-id brightnessctl set 5%-
      bindsym --release XF86MonBrightnessUp exec --no-startup-id brightnessctl set 5%+
    '';
  };

  # Start Ghostty on workspace 1: switch there, launch, retry move until window exists, focus ws 1
  xdg.configFile."i3/start-ghostty.sh" = {
    text = ''
      #!/usr/bin/env sh
      i3-msg 'workspace number 1'
      ghostty &
      # Ghostty WM_CLASS is "ghostty" or "com.mitchellh.ghostty" — retry until window exists
      for _ in 1 2 3 4 5 6 7 8 9 10; do
        sleep 0.5
        i3-msg '[class="ghostty"] move container to workspace number 1' 2>/dev/null && break
        i3-msg '[class="com.mitchellh.ghostty"] move container to workspace number 1' 2>/dev/null && break
      done
      i3-msg 'workspace number 1'
    '';
    executable = true;
  };

  # Launcher script (same app list as Sway; rofi on i3/X11 because wofi is Wayland-only)
  xdg.configFile."i3/launcher.sh" = {
    text = ''
      #!/usr/bin/env bash
      apps="thunar
      blueman
      virt-manager
      pavucontrol
      printer-settings
      nm-connection-editor
      file-roller
      vlc
      lunarclient
      kiwix
      gimp
      firefox
      excel
      word
      powerpoint
      windows
      outlook
      explorer
      notepad
      onedrive
      win
      packettracer"

      selection=$(echo "$apps" | rofi -dmenu -p "🔍 ")

      case "$selection" in
        thunar) exec thunar ;;
        blueman) exec blueman-manager ;;
        virt-manager) exec virt-manager ;;
        pavucontrol) exec pavucontrol ;;
        printer-settings) exec system-config-printer ;;
        nm-connection-editor) exec nm-connection-editor ;;
        file-roller) exec file-roller ;;
        vlc) exec vlc ;;
        lunarclient) exec lunarclient ;;
        kiwix) exec kiwix-desktop ;;
        gimp) exec gimp ;;
        firefox) exec firefox ;;
        excel) exec /usr/bin/excel ;;
        word) exec /usr/bin/word ;;
        powerpoint) exec /usr/bin/powerpoint ;;
        windows) exec /usr/bin/windows ;;
        outlook) exec /usr/bin/outlook ;;
        explorer) exec /usr/bin/explorer ;;
        notepad) exec /usr/bin/notepad ;;
        onedrive) exec /usr/bin/onedrive ;;
        win) exec /usr/bin/win ;;
        packettracker) exec packettracer9 ;;
        *) ;;
      esac
    '';
    executable = true;
  };

  # Display setup (from Sway setup-displays.sh — HDMI vs internal, using xrandr for i3/X11)
  xdg.configFile."i3/setup-displays.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Same behaviour as Sway: when HDMI connected use 1920x1080 and disable eDP;
      # else use internal (eDP/LVDS) 1440x900 and disable HDMI. Poll every 2s.
      previous_state=""
      while true; do
        output_info=$(xrandr --query 2>/dev/null)

        if echo "$output_info" | grep -qE '^HDMI[^ ]* connected'; then
          current_state="hdmi"
        else
          current_state="internal"
        fi

        if [[ "$current_state" != "$previous_state" ]]; then
          hdmi_out=$(echo "$output_info" | grep -oE '^HDMI[^ ]*' | head -1)
          edp_out=$(echo "$output_info" | grep -oE '^eDP[^ ]*|^LVDS[^ ]*' | head -1)

          if [[ "$current_state" == "hdmi" && -n "$hdmi_out" ]]; then
            xrandr --output "$hdmi_out" --mode 1920x1080 --pos 0 0 --primary
            [[ -n "$edp_out" ]] && xrandr --output "$edp_out" --off
          else
            if [[ -n "$edp_out" ]]; then
              xrandr --output "$edp_out" --mode 1440x900 --pos 0 0 --primary
            fi
            [[ -n "$hdmi_out" ]] && xrandr --output "$hdmi_out" --off
          fi
          previous_state="$current_state"
        fi

        sleep 2
      done
    '';
    executable = true;
  };

  # Rofi: Rose Pine Moon — iris border, surface bg, rose selection, search prompt
  xdg.configFile."rofi/config.rasi" = {
    text = ''
      configuration {
        modi: "dmenu";
        show-icons: false;
        font: "JetBrainsMono Nerd Font 14px";
        width: 600;
        padding: 15;
        border: 0px;
        lines: 12;
      }

      * {
        background-color: #2A273F;
        text-color: #E0DEF4;
        border-color: #C4A7E7;
      }

      window {
        background-color: #2A273F;
        border: 0px;
        border-color: #C4A7E7;
        padding: 15px;
      }

      inputbar {
        background-color: #2A273F;
        padding: 8px;
        children: [ prompt, entry ];
      }

      prompt {
        text-color: #E0DEF4;
        padding: 8px;
      }

      entry {
        text-color: #E0DEF4;
      }

      listview {
        background-color: #2A273F;
        padding: 4px;
        lines: 12;
      }

      element {
        padding: 8px;
        text-color: #E0DEF4;
      }

      element selected {
        background-color: #2A273F;
        text-color: #E0DEF4;
      }

      element-text {
        text-color: inherit;
      }

      element-text selected {
        background-color: #2A273F;
        text-color: #E0DEF4;
      }

      element-icon {
        size: 0;
      }
    '';
  };

}
