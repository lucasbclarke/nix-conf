{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url= "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig = {
      url = "github:mitchellh/zig-overlay";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nixd, nil, sops-nix, ghostty, ... }@inputs:
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
            ({ pkgs, ... }: {
                environment.systemPackages = [
                  ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
                ];
            })  
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                  useGlobalPkgd = true;
                  useUserPackages = true;
                  users.nixosSystemD = import ./home.nix;
                  backupFileExtension = "backup";
              };
            }
        ];
        specialArgs = { inherit inputs; };
      };

      homeConfigurations = {
          lucas = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./home.nix ];
              extraSpecialArgs = { inherit inputs; };
          };
      };
      home-manager.extraSpecialArgs = { inherit inputs; };
  };
}
