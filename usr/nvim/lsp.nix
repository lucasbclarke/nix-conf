{ config, pkgs, lib, inputs, ... }:

{
  programs.nixvim.lsp = {
      servers.clangd = {
        enable = true;
        package = pkgs.clang-tools;
      };
      servers.pyright = {
        enable = true;
        config = {
          python.pythonPath = "${pkgs.python3.withPackages (ps: [ ps.pynvim ps.debugpy ])}/bin/python";
          python.analysis.extraPaths = [
            "${pkgs.python3.withPackages (ps: [ ps.pynvim ps.debugpy ])}/${pkgs.python3.sitePackages}"
          ];
        };
      };

      servers.lua_ls = {
	enable = true;
	package = pkgs.lua-language-server;

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
	  package = pkgs.zls;
	  config = {
	    zls = {
	      completion_label_details = false;
	    };
	  };
      };

      servers.nixd = {
	enable = true;
	package = pkgs.nixd;
        config = {
	  nix = {
            autoArchive = true;
          };
        };
      };

      servers.nil_ls = {
	enable = true;
	package = pkgs.nil;
	config = {
          nil = { 
	    autoArchive = true;
          };
        };
      };

      servers.harper_ls = {
        enable = true;
        package = pkgs.harper;
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
	config = {
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
