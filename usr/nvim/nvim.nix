{ config, pkgs, lib, inputs, ... }:

let
    timeTrackerPlugins = import ./time-tracker.nix { inherit pkgs; };
  in
{
  home.packages = [ pkgs.sqlite pkgs.tree-sitter pkgs.lua53Packages.tree-sitter-cli pkgs.harper ];
  programs.nixvim = {  
    enable = true;

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
	treesitter.nixGrammars = true;
	treesitter-textobjects.enable = true;
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

	luasnip = {
	  enable = true;
	  settings = {
	    history = true;
	    updateevents = "TextChanged,TextChangedI";
            auto_archive = true;

	    fromVscode = [{}];
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

	snacks = {
	  enable = true;
	  settings = {
	    input = { enabled = true; };
	    picker = { enabled = true; };
	  };
	};
    };

    opts = {
      shiftwidth = 4;        
      statusline = "%f %=%c,%l";
      scrolloff = 23;
      clipboard = "unnamedplus";
      signcolumn = "yes";
    };

    globals = {
      zig_fmt_autosave = 0;
    };

    extraConfigLua = ''
      vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
        pattern = '*',
        callback = function()
          local ok, err = pcall(vim.highlight.on_yank, { higroup = 'Visual', timeout = 300 })
          if not ok then
            vim.notify('yank highlight err: ' .. tostring(err), vim.log.levels.WARN)
          end
        end,
      })
    '';
  };
}
