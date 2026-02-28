{ pkgs ? import <nixpkgs> {} }:

let
  sqlite-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "sqlite.nvim";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "3rd";
      repo = "sqlite.nvim";
      rev = "a8466c830a89794c2eafa41b41dd11fdf4a0d7ca";
      sha256 = "sha256-MLSB9i0H3H0bU6cbJOtl+eh34aMrAsdCgpoMB/yg41E=";
    };
    # The upstream repo includes spec files that fail the require check in nixpkgs.
    doCheck = false;
    meta.homepage = "https://github.com/3rd/sqlite.nvim";
  };

  time-tracker-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "time-tracker.nvim";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "3rd"; 
      repo = "time-tracker.nvim";   
      rev = "4127c4b5fecaf5f5cb3aa840707e58bb88eb9bf0";
      sha256 = "sha256-zWrQAV5OmlI9nwd/UsY6rFfbLQWja0p23e3FO1vsbUw=";
    };
    doCheck = false;
    meta.homepage = "https://github.com/3rd/time-tracker.nvim";
  };
in
{
  inherit time-tracker-nvim sqlite-nvim;
}
