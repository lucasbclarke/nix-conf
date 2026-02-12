{ config, pkgs, lib, inputs, ... }:

 let
   timeTrackerPlugins = import ./time-tracker.nix { inherit pkgs; };
 in
{
  home.packages = [ pkgs.sqlite ];
  programs.nixvim = {  
    enable = true;
    lsp.servers.zls.enable = true;
    lsp.servers.ts_ls.enable = true;
    lsp.servers.jdtls.enable = true;
    lsp.servers.clangd.enable = true;
    lsp.servers.pyright.enable = true;

    extraPlugins = [
	pkgs.vimPlugins.rose-pine
	pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.lsp-zero-nvim
	pkgs.vimPlugins.clangd_extensions-nvim
	pkgs.vimPlugins.vim-sleuth
	timeTrackerPlugins.sqlite-nvim
	timeTrackerPlugins.time-tracker-nvim
    ];

    colorschemes.rose-pine = {
      enable = true;
    };

    plugins = {
	markview.enable = true;
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
	supermaven = {
	  enable = true;
	  settings = {
	    keymaps = {
	      accept_suggestion = "<C-k>";
	      clear_suggestions = "<C-]>";
	      accept_word = "<C-j>";
	    };
	    color = {
	      cterm = 244;
	    };
	    log_level = "info";
	    disable_inline_completion = false;
	    disable_keymaps = false;
	  };

	};

	snacks = {
	  enable = true;
	  settings = {
	    input = { enabled = true; };
	    picker = { enabled = true; };
	  };
	};
    };

    

    opts = {
      number = true;         
      relativenumber = true;
      shiftwidth = 4;        
    };
  };
}
