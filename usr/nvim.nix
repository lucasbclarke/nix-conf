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
	--zls = {},
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
	cmp.enable = true;
	luasnip.enable = true;
	cmp_luasnip.enable = true;
	cmp-nvim-lsp.enable = true;
	cmp-path.enable = true;
	friendly-snippets.enable = true;
	fugitive.enable = true;
	lspconfig.enable = true;
	lazydev.enable = true;

	gitsigns = {
	  enable = true;
	  luaConfig.post = ''
	    opts = {
	      signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '?' },
		changedelete = { text = '~' },
	      },
	    on_attach = function(bufnr)
	      local gs = package.loaded.gitsigns
	      
	      local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	      end

	      map({ 'n', 'v' }, ']c', function()
		  if vim.wo.diff then
		    return ']c'
		  end
		  vim.schedule(function()
		    gs.next_hunk()
		  end)
		  return '<Ignore>'
	      end, { expr = true, desc = 'Jump to next hunk' })

	      map({ 'n', 'v' }, '[c', function()
		  if vim.wo.diff then
		    return '[c'
		  end
		  vim.schedule(function()
		    gs.prev_hunk()
		  end)
		  return '<Ignore>'
		end, { expr = true, desc = 'Jump to previous hunk' })

	      map('v', '<leader>hs', function()
		  gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
	      end, { desc = 'stage git hunk' })
	      map('v', '<leader>hr', function()
		  gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
	      end, { desc = 'reset git hunk' })

	      map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
	      map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
	      map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
	      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
	      map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
	      map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
	      map('n', '<leader>hb', function()
		  gs.blame_line { full = false }
	      end, { desc = 'git blame line' })
	      map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
	      map('n', '<leader>hD', function()
		  gs.diffthis '~'
	      end, { desc = 'git diff against last commit' })

	      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
	      map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

	      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
	    end
	  }


	  '';
	};
    };
    
    
    opts = {
      number = true;         
      relativenumber = true;
      shiftwidth = 2;        
  };
  };
}
