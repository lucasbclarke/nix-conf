{ pkgs }:

pkgs.writeShellScriptBin "hm-setup" ''
  # Add the nixpkgs and home-manager channels
  nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update

  # Install home-manager using nix-shell
  nix-shell '<home-manager>' -A install
  
  # Switch home-manager configuration (with backup)
  home-manager switch --flake . -b backup
''
