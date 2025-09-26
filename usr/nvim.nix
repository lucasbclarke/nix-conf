{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
	 pkgs.vimPlugins.rose-pine
	 pkgs.vimPlugins.tokyonight-nvim
	 pkgs.vimPlugins.lsp-zero-nvim
	 pkgs.vimPlugins.lazy-lsp-nvim
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
      

      --------  CMP  --------
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode')
      luasnip.config.setup {}

    cmp.setup {
	      completion = {
		completeopt = 'menu,menuone,noinsert',
	      },

	      sorting = {
		comparators = {
		  cmp.config.compare.offset,
		  cmp.config.compare.exact,
		  cmp.config.compare.recently_used,
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
		  "<C-d>" = "cmp.mapping.scroll_docs(-4)";
		  "<C-u>" = "cmp.mapping.scroll_docs(4)";
		  "<C-Space>" = "cmp.mapping.complete({})";
		  "<CR>" = "cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })";
		  "<Tab>" = {
		    __raw = ''
		      function(fallback)
		        if cmp.visible() then
		          cmp.select_next_item()
		        elseif luasnip.expand_or_locally_jumpable() then
		          luasnip.expand_or_jump()
		        else
		          fallback()
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
		        elseif luasnip.locally_jumpable(-1) then
		          luasnip.jump(-1)
		        else
		          fallback()
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
