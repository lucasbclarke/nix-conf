{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.extraConfigLua = ''
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

    -- (removed unused config=function() ... end block)

    --------  TIME TRACKER  --------
    require('time-tracker').setup({
        data_file = vim.fn.stdpath('data') .. '/time-tracker.db',
    })

    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
      callback = function()
        vim.highlight.on_yank()
      end,
        group = highlight_group,
        pattern = '*',
    })

    vim.opt.statusline = "%f %=%c,%l"
    vim.opt.scrolloff = 23
    vim.o.clipboard = 'unnamedplus'
    vim.g.zig_fmt_autosave = 0

    local lsp_zero = require('lsp-zero')

    local lsp_attach = function(client, bufnr)
      local options = { buffer = bufnr }
    end

    -- IMPORTANT: initialize lsp-zero BEFORE any server setup
    lsp_zero.extend_lspconfig({
      sign_text = true,
      lsp_attach = lsp_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })

    -- Configure Lua LS separately to use your custom command
    vim.lsp.config.lua_ls = {
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
    }
    vim.lsp.enable('lua_ls')


    vim.lsp.config.zls = {
      mason = false,
      cmd = { "zls" },
      settings = {
        zls = {
          completion_label_details = false;
        }
      }
    }
    vim.lsp.enable('zls')

    vim.lsp.config.clangd = {
      mason = false,
      cmd = { "clangd" },
    }
    vim.lsp.enable('clangd')

    -- Nix-related servers
    vim.lsp.config.nixd = {
      mason = false,
      cmd = { "nixd" },
      settings = {
        nix = {
          autoArchive = true;
        }
      }
    }
    vim.lsp.enable('nixd')

    vim.lsp.config.nil_ls = {
      mason = false,
      cmd = { "nil" },
      settings = {
        nix = {
          autoArchive = true;
        }
      }
    }
    vim.lsp.enable('nil_ls')
    
    vim.lsp.config('typescript-language-server', {
      mason = false,
      cmd = { "typescript-language-server", "--stdio" }
    })
    vim.lsp.enable('typescript-language-server')

    vim.lsp.config('jdtls', {
      mason = false,
      cmd = { "jdtls" }
    })
    vim.lsp.enable('jdtls')

    pcall(require('telescope').load_extension, 'fzf')
  '';
}
