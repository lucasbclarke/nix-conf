{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
	rose-pine
	tokyonight-nvim
    ];

    colorschemes.rose-pine = {
	enable = true;
    };

    plugins = {
	treesitter.enable = true;
	treesitter-textobjects.enable = true;

	cmp.enable = true;
	luasnip.enable = true;
	cmp_luasnip.enable = true;
	cmp-nvim-lsp.enable = true;
	cmp-path.enable = true;
	friendly-snippets.enable = true;

	fugitive.enable = true;
    };
    
    
    opts = {
      number = true;         
      relativenumber = true;
      shiftwidth = 2;        
    };
  };
}
