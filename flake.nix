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
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

  in {
      nixosConfigurations = {
          nixosSystemD = lib.nixosSystem {
            inherit system;
            modules = [./nixosSystemD/configuration.nix];
            specialArgs = { inherit inputs; };
          };
          nixosGrub = lib.nixosSystem {
            inherit system;
            modules = [./nixosGrub/configuration.nix];
            specialArgs = { inherit inputs; };
          };
          nixosVm = lib.nixosSystem {
            inherit system;
            modules = [./nixosVm/configuration.nix];
            specialArgs = { inherit inputs; };
          };
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
