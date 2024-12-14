{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    inputs.agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    nixpkgs,
    chaotic,
    ...
  }: {
    nixosConfigurations = {
      GodlikeNix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Your system configuration.
          chaotic.nixosModules.default
          agenix.nixosModules.default
        ];
      };
    };
  };
}
