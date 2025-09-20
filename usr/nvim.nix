{ config, pkgs, lib, ... }:

{
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    viAlias = true;
    vimAlias = true;


    plugins = [
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.lazy-nvim

      {
        plugin = pkgs.vimPlugins.mason-nvim;
        type = "lua";
        config = ''
          require("mason").setup()
          require("mason-lspconfig").setup({
            ensure_installed = { "nil_ls" }, 
            automatic_installation = false,
            automatic_enable = false,    
          })
        '';
      }

      {
        plugin = pkgs.vimPlugins.mason-lspconfig-nvim;
        type = "lua";
        config = ''
          vim.lsp.enable('clangd')
        '';
      }

      {
        plugin = pkgs.vimPlugins.lazydev-nvim;
        type = "lua";
        config = ''
          require("lazydev").setup()
        '';
      }
      
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = ''
          vim.lsp.enable('clangd')
        '';
      }

      {
        plugin = pkgs.vimPlugins.lsp-zero;
        type = "lua";
        config = ''
          local lsp_zero = require('lsp-zero')

          local lsp_attach = function(client, bufnr)
          local options = { buffer = bufnr }

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', options)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', options)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', options)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', options)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', options)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', options)
          vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', options)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', options)
          end

          lsp_zero.extend_lspconfig({
            sign_text = true,
            lsp_attach = lsp_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          })

          -- Configure Lua LS separately to use your custom command
          require('lspconfig').lua_ls.setup({
              mason = false,  -- Disable Mason management
              cmd = { "lua-language-server" },  -- Use your NixOS version
              settings = {
                Lua = {
                  workspace = {
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              }
          })

          require('lspconfig').zls.setup({
            mason = false,
            cmd = { "zls" },
            settings = {
              zls = {
                completion_label_details = false;
              }
            }
          })

          require('lspconfig').clangd.setup({
            mason = false,
            cmd = { "clangd" },
          })
        '';
      }
      
      {
        plugin = pkgs.vimPlugins.nvim-cmp;
        type = "lua";
        config = ''
          local servers = {
            --zls = {},
            nil_ls = {},

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
                require("clangd_extensions.cmp_scores"),
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
              },
            },
          }
        '';
      }

      pkgs.vimPlugins.luasnip
      pkgs.vimPlugins.cpm_luasnip
      pkgs.vimPlugins.cpm-nvim-lsp
      pkgs.vimPlugins.cpm-path
      pkgs.vimPlugins.friendly-snippets

      {
        plugin = pkgs.vimPlugins.rose-pine;
        type = "lua";
        config = ''
          name = "rose-pine",
          config = function ()
            vim.cmd.colorscheme 'rose-pine'
          end

          require("rose-pine").setup({})
          vim.api.nvim_set_hl(0, "DiffAdd", { fg="#9ccfd8" })
          vim.api.nvim_set_hl(0, "DiffDelete", { fg="#eb6f92" })
          vim.api.nvim_set_hl(0, "DiffChange", { fg="#0000FF" }) --not working maybe ??

        '';
      }

      {
        plugin = pkgs.vimPlugins.tokyonight-nvim;
        type = "lua";
        config = ''
          lazy = false,
          priority = 1000,
          opts = {},
        '';
      }



    ];
  };
}
