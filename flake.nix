{
  description = "Chen's NixBook configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      formatterSystems = systems ++ [
        "aarch64-darwin"
      ];
    in
    {
      packages = forAllSystems (
        system:
        import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; }
        // {
          disko-install = inputs.disko.packages.${system}.disko-install;
          mkpasswd = nixpkgs.legacyPackages.${system}.mkpasswd;
        }
      );
      formatter = nixpkgs.lib.genAttrs formatterSystems (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      overlays = import ./overlays { inherit inputs; };

      # nixos-rebuild --flake .#nixbook
      nixosConfigurations = {
        nixbook = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/configuration.nix ];
        };
      };
    };
}
