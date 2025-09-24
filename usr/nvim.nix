{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
	pkgs.vimPlugins.rose-pine
	pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.mason-nvim
	pkgs.vimPlugins.mason-lspconfig-nvim
	pkgs.vimPlugins.lsp-zero-nvim
	pkgs.nixd
    ];

    extraConfigLua = ''
      local servers = {
	--zls = {},
	rnix = {},

	--lua_ls = {
	  --  Lua = {
	    --    workspace = { checkThirdParty = false },
	    --    telemetry = { enable = false },
	    --  },
	  --},
      }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local mason_lspconfig = require 'mason-lspconfig'
      local lspconfig = require('lspconfig')

      mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
      }

    for server_name, server_config in pairs(servers) do
      lspconfig[server_name].setup {
	capabilities = capabilities,
		     on_attach = on_attach,
		     settings = server_config,
		     filetypes = server_config.filetypes,
      }
    end

      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode')
      luasnip.config.setup {}

    cmp.setup {
      snippet = {
	expand = function(args)
	  luasnip.lsp_expand(args.body)
	  end,
      },
	      completion = {
		completeopt = 'menu,menuone,noinsert',
	      },
	      mapping = cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-u>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
		  behavior = cmp.ConfirmBehavior.Replace,
		  select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
		    if cmp.visible() then
		    cmp.select_next_item()
		    elseif luasnip.expand_or_locally_jumpable() then
		    luasnip.expand_or_jump()
		    else
		    fallback()
		    end
		    end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
		    if cmp.visible() then
		    cmp.select_prev_item()
		    elseif luasnip.locally_jumpable(-1) then
		    luasnip.jump(-1)
		    else
		    fallback()
		    end
		    end, { 'i', 's' })
	      },
	      sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
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
      require("mason").setup()

      require("mason-lspconfig").setup({
	  ensure_installed = { "rnix" }, 
	  automatic_installation = false,
	  automatic_enable = false,    
	  })
      '';

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

	lspconfig.enable = true;
	lazydev.enable = true;
    };
    
    
    opts = {
      number = true;         
      relativenumber = true;
      shiftwidth = 2;        
    };
  };
}
