{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
  };
    colorschemes.rose-pine = {
      enable = true;
      pakcage = pkgs.vimPlugins.rose-pine;
    };
}
