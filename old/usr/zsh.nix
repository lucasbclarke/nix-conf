{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      custom = "$HOME/.oh-my-zsh";
      plugins = [ "git" ];
    };

    shellAliases = {
      sd = "cd \"\$(find $HOME -type d ! -path '*/.*' 2>/dev/null | fzf)\" && clear";
      nix-shell = "nix-shell --run $SHELL";
    };

    initContent = ''
      if command -v tmux &> /dev/null && [ -n "$PS2" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && { [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_VTNR" = "1" ]; }; then
        exec tmux
          fi
          export PATH="$PATH:/opt/nvim-linux64/bin:/usr/lib:$HOME/.local/bin:/usr/bin:$HOME/zig-latest-linux-x86_64:/run/current-system/sw/bin/"
          export MANPAGER='nvim +Man!'
          export NIXPKGS_ALLOW_UNFREE=1

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

      bindkey "^P" up-line-or-search
      bindkey "^N" down-line-or-search

      export SWAYSOCK=$(ls /run/user/1000/sway-ipc.*.sock | head -n1)
      '';

  };
}
