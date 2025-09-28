{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.extraConfigLua = ''
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local lspconfig = require('lspconfig')


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

      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', options)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', options)
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', options)
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', options)
      vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', options)
      vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', options)
      vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', options)
      vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', options)
    end

    -- IMPORTANT: initialize lsp-zero BEFORE any server setup
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

    -- Nix-related servers
    require('lspconfig').nixd.setup({
      mason = false,
      cmd = { "nixd" },
    })

    require('lspconfig').nil_ls.setup({
      mason = false,
      cmd = { "nil" },
    })
  '';
}
