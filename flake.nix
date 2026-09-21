{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv/v2.3";
    };

  };
  outputs = { self, nixpkgs, home-manager, nixvim, sops-nix, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
      nixosConfigurations.nixosSystemD = lib.nixosSystem {
        inherit system;
        modules = [
          ./nixosSystemD/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
             home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs; };
                  users.lucas = import ./home.nix;
              };
            }
        ];
        specialArgs = { inherit inputs; };
      };

  };
}
