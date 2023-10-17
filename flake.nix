{
  description = "Chen's NixBook configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    packages = forAllSystems (system: import ./pkgs {pkgs = pkgsFor.${system};});
    devShells = forAllSystems (system: import ./shell.nix {pkgs = pkgsFor.${system};});
    formatter = forAllSystems (system: pkgsFor.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # nixos-rebuild --flake .#nixbook
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/configuration.nix];
      };
    };

    # home-manager --flake .#chen@nixbook
    homeConfigurations = {
      "chen@nixbook" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/home.nix];
      };
    };
  };
}
