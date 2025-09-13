{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    lib = nixpkgs.lib;
  in {
      nixosConfigurations = {
          nixosSystemD = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [./nixosSystemD/configuration.nix];
            specialArgs = { inherit inputs; };
          };
          nixosGrub = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [./nixosGrub/configuration.nix];
            specialArgs = { inherit inputs; };
          };
          nixosVm = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [./nixosVm/configuration.nix];
            specialArgs = { inherit inputs; };
          };
      };
  };
  
}
