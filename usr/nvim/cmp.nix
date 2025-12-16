{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.plugins.cmp = {
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
        option = { show_autosnippets = false; };
      }
      { name = "path"; }
      ];
    };

  };
}
