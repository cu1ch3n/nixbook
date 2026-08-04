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
        let
          pkgs = nixpkgs.legacyPackages.${system};
          vscodePkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.nix-vscode-extensions.overlays.default ];
            config.allowUnfree = true;
          };
        in
        import ./pkgs { inherit pkgs; }
        // {
          disko = inputs.disko.packages.${system}.disko;
          inherit (pkgs) mkpasswd nixos-install-tools psmisc;
          vscode-haskell = vscodePkgs.vscode-marketplace-release.haskell.haskell;
          vscode-language-haskell = vscodePkgs.vscode-marketplace-release.haskell.language-haskell;
        }
      );
      formatter = nixpkgs.lib.genAttrs formatterSystems (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      overlays = import ./overlays { inherit inputs; };

      diskoConfigurations.nixbook =
        {
          device,
          lib,
          ...
        }:
        let
          module = import ./scripts/disko.nix { inherit lib; };
        in
        {
          disko.devices = lib.recursiveUpdate module.disko.devices {
            disk.main.device = device;
          };
        };

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
