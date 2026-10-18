{ config, pkgs, lib, inputs, ... }:

let
    timeTrackerPlugins = import ./time-tracker.nix { inherit pkgs; };
    blenderPlugins = import ./blender.nix { inherit pkgs; };
    blenderPythonEnv = pkgs.python3.withPackages (ps: [ ps.pynvim ps.debugpy ]);

    # nixpkgs has no tree-sitter-tmux, so build it from source. Nixvim installs
    # it through `plugins.treesitter.grammarPackages` and Neovim picks up
    # parser/tmux.so from the runtimepath.
    treeSitterTmux = pkgs.tree-sitter.buildGrammar {
      language = "tmux";
      version = "0.0.0+rev=75d1b99";
      src = pkgs.fetchFromGitHub {
        owner = "Freed-Wu";
        repo = "tree-sitter-tmux";
        rev = "75d1b995b0c23400ac8e49db757a2e0386f9fa8f";
        hash = "sha256-LdXPdijcsfPYIrbTMDIy46wqOaJfxwVBVpOVVfXrJIg=";
      };
    };
  in
{
  home.packages = [ pkgs.sqlite pkgs.tree-sitter pkgs.lua53Packages.tree-sitter-cli pkgs.harper ];

  xdg.configFile = {
    # Nixvim's injections (lua/vim) followed by our tmux injection. Queries from
    # every runtimepath entry are merged by Neovim, so nvim-treesitter's nix
    # injections keep working alongside this one.
    "nvim/queries/nix/injections.scm".text = ''
      ${builtins.readFile "${inputs.nixvim}/plugins/by-name/treesitter/injections.scm"}
      ${builtins.readFile ./queries/nix/tmux-injection.scm}
    '';
    "nvim/queries/tmux/highlights.scm".source = ./queries/tmux/highlights.scm;
    "nvim/queries/tmux/injections.scm".source = ./queries/tmux/injections.scm;
  };

  programs.nixvim = {  
    enable = true;
    nixpkgs.source = inputs.nixpkgs;

    extraPlugins = [
	pkgs.vimPlugins.rose-pine
	pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.lsp-zero-nvim
	pkgs.vimPlugins.clangd_extensions-nvim
	pkgs.vimPlugins.vim-sleuth
	pkgs.vimPlugins.nui-nvim
	pkgs.vimPlugins.nvim-dap
	timeTrackerPlugins.sqlite-nvim
	timeTrackerPlugins.time-tracker-nvim
	blenderPlugins.blender-nvim
	blenderPlugins.nui-components-nvim
	blenderPlugins.nvim-dap-repl-highlights
    ];

    env.PYTHONPATH = "${blenderPythonEnv}/${pkgs.python3.sitePackages}";

    colorschemes.rose-pine = {
      enable = true;
    };

    plugins = {
	markview.enable = true;
	treesitter.enable = true;
	treesitter.nixGrammars = true;
	treesitter.grammarPackages = config.programs.nixvim.plugins.treesitter.package.allGrammars ++ [ treeSitterTmux ];
	# Nixvim's own injections.scm only knows lua and vim, and it would collide
	# with the file below, so replace it with nixvim's queries plus ours.
	treesitter.nixvimInjections = false;
	treesitter.settings = {
	  ensure_installed = [ "dap_repl" ];
	};
	treesitter.luaConfig.pre = ''
	  require('nvim-dap-repl-highlights').setup()
	'';
	# nvim-treesitter (0.10 rewrite) no longer registers the FileType autocmd
	# that starts the highlighter, so nothing was attaching tree-sitter at all.
	treesitter.luaConfig.post = ''
	  local group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true })
	  vim.api.nvim_create_autocmd("FileType", {
	    group = group,
	    callback = function(args)
	      local lang = args.match
	      if lang and lang ~= "" and pcall(vim.treesitter.language.add, lang) then
	        pcall(vim.treesitter.start, args.buf, lang)
	      end
	    end,
	  })
	'';
	treesitter-textobjects.enable = true;
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

	luasnip = {
	  enable = true;
	  settings = {
	    history = true;
	    updateevents = "TextChanged,TextChangedI";
            auto_archive = true;

	    fromVscode = [{}];
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

	snacks = {
	  enable = true;
	  settings = {
	    input = { enabled = true; };
	    picker = { enabled = true; };
	  };
	};
    };

    opts = {
      exrc = true;
      shiftwidth = 4;        
      statusline = "%f %=%c,%l";
      scrolloff = 23;
      clipboard = "unnamedplus";
      signcolumn = "yes";
    };

    globals = {
      zig_fmt_autosave = 0;
    };

    extraConfigLua = ''
      require('blender').setup()

      vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
        pattern = '*',
        callback = function()
          local ok, err = pcall(vim.highlight.on_yank, { higroup = 'Visual', timeout = 300 })
          if not ok then
            vim.notify('yank highlight err: ' .. tostring(err), vim.log.levels.WARN)
          end
        end,
      })
    '';
  };
}
