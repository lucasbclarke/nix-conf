{ config, lib, pkgs, ...}:

{
  programs.tmux = {
      enable = true;
      prefix = "M-q";
      sensibleOnTop = true;
      plugins = with pkgs; [
          tmuxPlugins.rose-pine {
              plugin = tmuxPlugins.rose-pine;
              extraConfig = "set -g @rose_pine_variant 'main'";
          }
      ];
      extraConfig = ''
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi V send -X select-line
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
        set -g base-index 1
        setw -g pane-base-index 1
        set -g status-right ' #{?client_prefix,#[reverse]🗸#[noreverse] ,}"#{=21:pane_title}" %H:%M %d-%b-%y'
        set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
      '';

  };

  programs.ghostty = {
      enable = true;
      settings = {
        gtk-titlebar = false;
        window-decoration = false;
        font-family = "JetBrainsMono NF Medium";
        cursor-style = "block";
        keybind = [
            "ctrl+x=copy_to_clipboard"
            "ctrl+shift+v=unbind"
            "ctrl+v=paste_from_clipboard"
            "ctrl+shift+a=select_all"
        ];
        confirm-close-surface = false;

      };
  };

}
