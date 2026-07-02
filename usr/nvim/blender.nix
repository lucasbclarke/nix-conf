{ pkgs ? import <nixpkgs> {} }:

let
  blender-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "blender.nvim";
    version = "2026-05-07";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "blender.nvim";
      rev = "7017462b01a286c3297d4119ac383f05adf3d1b6";
      sha256 = "sha256-ifPYymKr9VSuQPpLmpt/1tbbDsmTP7N3RulNWL+mb+Q=";
    };
    doCheck = false;
    meta.homepage = "https://github.com/b0o/blender.nvim";
  };

  nui-components-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "nui-components.nvim";
    version = "2025-03-15";
    src = pkgs.fetchFromGitHub {
      owner = "grapp-dev";
      repo = "nui-components.nvim";
      rev = "1654dd709f13874089eefc80d82e0eb667f7fdfb";
      sha256 = "sha256-dq/HZ2EEbGu4uHEJQ4tJPSgIn72wga6Bf3ku3XvjKkY=";
    };
    doCheck = false;
    meta.homepage = "https://github.com/grapp-dev/nui-components.nvim";
  };

  nvim-dap-repl-highlights = pkgs.stdenv.mkDerivation {
    pname = "nvim-dap-repl-highlights";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "LiadOz";
      repo = "nvim-dap-repl-highlights";
      rev = "f31deba47fe3ee6ff8d2f13d9dbd06b2d1ae06b5";
      sha256 = "sha256-1QjmDy4v1AvNs5F4V8C3Lu7CVQH+uOV8gU855oz2IjY=";
    };
    dontConfigure = true;
    buildPhase = ''
      mkdir -p parser
      $CC -shared -fPIC -O2 -I src src/parser.c -o parser/dap_repl.so
    '';
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
      # The parser is pre-compiled above; setup() only registers config
      # with nvim-treesitter and does not write files, so leave it intact.
    '';
    doCheck = false;
    meta.homepage = "https://github.com/LiadOz/nvim-dap-repl-highlights";
  };
in
{
  inherit blender-nvim nui-components-nvim nvim-dap-repl-highlights;
}
