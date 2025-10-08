{ config, pkgs, lib, inputs, ... }:

let
  timeTrackerPlugins = import ./time-tracker.nix { inherit pkgs; };
in
{
  home.packages = [ pkgs.sqlite ];
  programs.nixvim = {  

    lsp.servers.zls.enable = true;

    extraPlugins = [
	pkgs.vimPlugins.rose-pine
	pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.lsp-zero-nvim
	pkgs.vimPlugins.lazy-lsp-nvim
	pkgs.vimPlugins.clangd_extensions-nvim
	pkgs.vimPlugins.vim-sleuth
	timeTrackerPlugins.sqlite-nvim
	timeTrackerPlugins.time-tracker-nvim
    ];

    colorschemes.rose-pine = {
      enable = true;
    };

    plugins = {
	treesitter.enable = true;
	treesitter-textobjects.enable = true;
	luasnip.enable = true;
	cmp_luasnip.enable = true;
	cmp-nvim-lsp.enable = true;
	cmp-path.enable = true;
	cmp-buffer.enable = true;
	friendly-snippets.enable = true;
	fugitive.enable = true;
	lspconfig.enable = true;
	lazydev.enable = true;
	web-devicons.enable = true;
	telescope = {
	  enable = true;
	  extensions = {
	    fzf-native = {
	      enable = true;
	    };
	  };
	};

	gitsigns = {
	  enable = true;
	  settings = {
	      signs = {
		add.text = "+";
		change.text = "~";
		changedelete.text = "~";
		delete.text = "_";
		topdelete.text = "?";
		untracked.text = "┆";
	      };
	  };
	};
    };
    
    opts = {
      number = true;         
      relativenumber = true;
      shiftwidth = 2;        
    };
  };
}
