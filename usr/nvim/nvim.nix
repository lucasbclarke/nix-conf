{ config, pkgs, lib, inputs, ... }:

 let
   timeTrackerPlugins = import ./time-tracker.nix { inherit pkgs; };
 in
{
  home.packages = [ pkgs.sqlite pkgs.tree-sitter pkgs.lua53Packages.tree-sitter-cli ];
  programs.nixvim = {  
    enable = true;

    lsp = {
      enable = true;
      servers.clangd.enable = true;
      servers.pyright.enable = true;

      servers.lua_ls = {
	enable = true;

	config = {
          Lua = {
            workspace = {
              checkThirdParty = false;
            };
            telemetry = {
              enable = false;
            };
            diagnostics = {
              globals = [ "vim" ];
            };
          };
        };
      };

      servers.zls = {
	  enable = true;
	  config = {
	    zls = {
	      completion_label_details = false;
	    };
	  };
      };

      servers.nixd = {
	enable = true;
        config = {
	  nix = {
            autoArchive = true;
          };
        };
      };

      servers.nil_ls = {
	enable = true;
	config = {
          nil = { 
	    autoArchive = true;
          };
        };
      };

      servers.ts_ls = {
	enable = true;
	package = pkgs.typescript-language-server;
      };

      setup = {
        ts_ls = {
          cmd = [ "typescript-language-server" "--stdio" ];
          filetypes = [
            "javascript"
            "javascriptreact"
            "javascript.jsx"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
          ];
        };
      };

      servers.jdtls = {
	enable = true;
	package = pkgs.jdt-language-server;
      };

      onAttach = ''
        local options = { buffer = bufnr }
      '';
    };

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
	treesitter.grammars = [ "nix" ];
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
            # Note: Nix uses snake_case for most plugin options to match the Lua API
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
	
	lsp-zero = {
	  enable = true;
	  settings = {
	    sign_text = true;
	  };
	};

    opts = {
      shiftwidth = 4;        
      statusline = "%f %=%c,%l";
      scrolloff = 23;
      clipboard = "unnamedplus";
      signcolumn = true;
    };

    globals = {
      zig_fmt_autosave = 0;
    };

    autoGroups = {
      YankHighlight = {
        clear = true;
      };
    };

    autoCmd = [{
      event = [ "TextYankPost" ];
      group = "YankHighlight";
      pattern = "*";
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
      }];
    };
  };
}
