{ config, pkgs, lib, inputs, ... }:

let
    timeTrackerPlugins = import ./time-tracker.nix { inherit pkgs; };
    blenderPlugins = import ./blender.nix { inherit pkgs; };
    blenderPythonEnv = pkgs.python3.withPackages (ps: [ ps.pynvim ps.debugpy ]);
  in
{
  home.packages = [ pkgs.sqlite pkgs.tree-sitter pkgs.lua53Packages.tree-sitter-cli pkgs.harper ];
  programs.nixvim = {  
    enable = true;
    nixpkgs.source = inputs.nixpkgs;

    extraPlugins = [
	pkgs.vimPlugins.rose-pine
	pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.lsp-zero-nvim
	pkgs.vimPlugins.clangd_extensions-nvim
	pkgs.vimPlugins.vim-sleuth
	pkgs.vimPlugins.nui-nvim
	pkgs.vimPlugins.nvim-dap
	timeTrackerPlugins.sqlite-nvim
	timeTrackerPlugins.time-tracker-nvim
	blenderPlugins.blender-nvim
	blenderPlugins.nui-components-nvim
	blenderPlugins.nvim-dap-repl-highlights
    ];

    env.PYTHONPATH = "${blenderPythonEnv}/${pkgs.python3.sitePackages}";

    colorschemes.rose-pine = {
      enable = true;
    };

    plugins = {
	markview.enable = true;
	treesitter.enable = true;
	treesitter.nixGrammars = true;
	treesitter.settings = {
	  ensure_installed = [ "dap_repl" ];
	};
	treesitter.luaConfig.pre = ''
	  require('nvim-dap-repl-highlights').setup()
	'';
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
      exrc = true;
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
      require('blender').setup()

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
