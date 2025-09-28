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
  };

  programs.wofi = {
      enable = true;
      settings = {
        key_forward = "Ctrl-n";
        key_backward = "Ctrl-p";
      };
  };
  programs.nixvim.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
