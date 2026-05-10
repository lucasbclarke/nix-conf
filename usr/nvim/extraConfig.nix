{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.extraConfigLua = ''
    require('time-tracker').setup({
        data_file = vim.fn.stdpath('data') .. '/time-tracker.db',
    })

    vim.opt.number = true
    vim.opt.relativenumber = true
  '';
}
