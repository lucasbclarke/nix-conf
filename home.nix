{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lucas/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        custom = "$HOME/.oh-my-zsh";
        plugins = [ "git" ];
      };

      shellAliases = {
          sd = "cd /home && cd \$(find * -type d | fzf) && clear";
          nix-shell = "nix-shell --run $SHELL";
      };
      initContent = ''
        if command -v tmux &> /dev/null && [ -n "$PS2" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
          exec tmux
        fi
        export PATH="$PATH:/opt/nvim-linux64/bin:/usr/lib:$HOME/.local/bin:/usr/bin:$HOME/zig-latest-linux-x86_64"
        export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
        export MANPAGER='nvim +Man!'
        export NIXPKGS_ALLOW_UNFREE=1
        command xdotool key super+shift+1
        command xdotool key super+1
        command xdotool key ctrl+"+"

        # Force steady block cursor in zsh (vi-mode aware)
        function _cursor_block { print -n '\e[2 q' }
        function zle-line-init { _cursor_block }
        function zle-line-finish { _cursor_block }
        function zle-keymap-select {
          case $KEYMAP in
            vicmd) _cursor_block ;;
            viins|main) _cursor_block ;;
          esac
        }
        function preexec { _cursor_block }
        zle -N zle-line-init
        zle -N zle-line-finish
        zle -N zle-keymap-select
      '';
      
  };

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

  programs.wofi = {
      enable = true;
      settings = {
        key_forward = "Ctrl-n";
        key_backward = "Ctrl-p";
      };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
