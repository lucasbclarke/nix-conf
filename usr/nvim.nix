{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
	pkgs.vimPlugins.rose-pine
	pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.lsp-zero-nvim
	pkgs.vimPlugins.lazy-lsp-nvim
	pkgs.vimPlugins.clangd_extensions-nvim
	pkgs.vimPlugins.vim-sleuth
	pkgs.vimPlugins.sqlite-lua
    ];

    extraConfigLua = ''
      local servers = {
	zls = {},
	nixd = {},
	nil_ls = {},

	lua_ls = {
	    Lua = {
	        workspace = { checkThirdParty = false },
	        telemetry = { enable = false },
	      },
	  },
      }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local lspconfig = require('lspconfig')

    for server_name, server_config in pairs(servers) do
      lspconfig[server_name].setup {
	capabilities = capabilities,
		     on_attach = on_attach,
		     settings = server_config,
		     filetypes = server_config.filetypes,
      }
    end
      

      --------  LUASNIP  --------
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      --------  CMP  --------
      local cmp = require 'cmp'

    cmp.setup {
	      completion = {
		completeopt = 'menu,menuone,noinsert',
	      },

	      sorting = {
		comparators = {
		  cmp.config.compare.offset,
		  cmp.config.compare.exact,
		  cmp.config.compare.recently_used,
		  require("clangd_extensions.cmp_scores"),
		  cmp.config.compare.kind,
		  cmp.config.compare.sort_text,
		  cmp.config.compare.length,
		  cmp.config.compare.order,
		},
	      },
    }
      config = function()
	local lsp_zero = require("lsp-zero")

	lsp_zero.on_attach(function(client, bufnr)
	    -- see :help lsp-zero-keybindings to learn the available actions
	    lsp_zero.default_keymaps({
	      buffer = bufnr,
	      preserve_mappings = false
	      })
	    end)

	require("lazy-lsp").setup {}
      end
      '';

        colorschemes.rose-pine = {
	enable = true;
    };

    plugins = {
	treesitter.enable = true;
	treesitter-textobjects.enable = true;
    
	cmp = {
	    enable = true;
	    settings = {
		mapping = {
		  "<C-d>" = {
		    __raw = "cmp.mapping.scroll_docs(-4)";
		  };
		  "<C-u>" = {
		    __raw = "cmp.mapping.scroll_docs(4)";
		  };
		  "<C-Space>" = {
		    __raw = "cmp.mapping.complete()";
		  };
		  "<CR>" = {
		    __raw = "cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })";
		  };
		  "<Tab>" = {
		    __raw = ''
		      function(fallback)
		        if cmp.visible() then
		          cmp.select_next_item()
		        else
		          local luasnip = require("luasnip")
		          if luasnip and luasnip.expand_or_locally_jumpable() then
		            luasnip.expand_or_jump()
		          else
		            fallback()
		          end
		        end
		      end
		    '';
		    modes = [ "i" "s" ];
		  };
		  "<S-Tab>" = {
		    __raw = ''
		      function(fallback)
		        if cmp.visible() then
		          cmp.select_prev_item()
		        else
		          local luasnip = require("luasnip")
		          if luasnip and luasnip.locally_jumpable(-1) then
		            luasnip.jump(-1)
		          else
		            fallback()
		          end
		        end
		      end
		    '';
		    modes = [ "i" "s" ];
		  };
		};

		snippet = {
		  expand = ''
		    function(args)
		      require("luasnip").lsp_expand(args.body)
		    end
		    '';
		};
		sources = [
		  { name = "nvim_lsp"; }
		  {
		    name = "luasnip";
		    option = { show_autosnippets = true; };
		  }
		  { name = "path"; }
		  { name = "buffer"; }
		];
	    };
	};

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

    keymaps = [
  
    {
      mode = [
	"n"
	"v"
      ];

      key = "]c";
      action = ":Gitsigns next_hunk<CR>";
      options = {
	silent = true;
	desc = "next hunk";
      };
    }
   
    {
      mode = [
	"n"
	"v"
      ];

      key = "[c";
      action = ":Gitsigns prev_hunk<CR>";
      options = {
	silent = true;
	desc = "prev hunk";
      };
    }
    
    {
      mode = "v";
      key = "<leader>hs";
      action = "<cmd>lua require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>";
      options = {
	desc = "stage git hunk";
      };
    }
    
    {
      mode = "v";
      key = "<leader>hr";
      action = "function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end";
      options = {
	desc = "reset git hunk";
      };
    }

    {
      mode = "n";
      key = "<leader>hs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options = {
	silent = true;
	desc = "git stage hunk";
      };
    }

    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options = {
	silent = true;
	desc = "git reset hunk";
      };
    }

    {
      mode = "n";
      key = "<leader>hS";
      action = "<cmd>Gitsigns stage_buffer<CR>";
      options = {
        silent = true;
        desc = "git stage buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>hu";
      action = "<cmd>Gitsigns undo_stage_hunk<CR>";
      options = {
        silent = true;
        desc = "undo stage hunk";
      };
    }

    {
      mode = "n";
      key = "<leader>hR";
      action = "<cmd> Gitsigns reset_buffer<CR>";
      options = {
        silent = true;
        desc = "git reset buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>hp";
      action = "<cmd> Gitsigns preview_hunk<CR>";
      options = {
        silent = true;
        desc = "preview git hunk";
      };
    }

    {
      mode = "n";
      key = "<leader>hd";
      action = "<cmd> Gitsigns diffthis<CR>";
      options = {
	silent = true;
	desc = "git diff against index";
      };
    }

    {
      mode = "n";
      key = "<leader>hD";
      action = "<cmd> Gitsigns diffthis ~<CR>";
      options = {
	silent = true;
	desc = "git diff against last commit";
      };
    }

    {
      mode = "n";
      key = "<leader>tb";
      action = "<cmd> Gitsigns toggle_current_line_blame<CR>";
      options = {
	silent = true;
	desc = "toggle git blame line";
      };
    }

    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd> Gitsigns toggle_deleted<CR>";
      options = {
        silent = true;
        desc = "toggle git show deleted";
      };
    }

    {
      mode = [
	"o"
	"x"
      ];

      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      options = {
        silent = true;
        desc = "select git hunk";
      };
    }

    ];
  };
}
