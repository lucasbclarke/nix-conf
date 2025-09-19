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
}
