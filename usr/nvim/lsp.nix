{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.lsp = {
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

      servers.harper_ls = {
        enable = true;
        config = {
          settings = {
            "harper-ls" = {
              linters = {
                SpellCheck = true;
                SentenceCapitalization = true;
                UnclosedQuotes = true;
                LongSentences = true;
                RepeatedWords = true;
                Spaces = true;
                CorrectNumberSuffix = true;
                SpelledNumbers = false;
                WrongApostrophe = false;
              };
              codeActions = {
                ForceStable = false;
              };
              diagnosticSeverity = "hint";
              dialect = "Australian";
              isolateEnglish = false;
              maxFileLength = 120000;
            };
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
}
