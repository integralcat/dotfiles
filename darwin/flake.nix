{
  description = "System configuration";
  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manages configs
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    ...
  } @ inputs: let
    # Username
    primaryUser = "gourav";
  in {
    # build darwin flake using:
    # $ darwin-rebuild build --flake .#<name>
    darwinConfigurations."nmb" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./nix_darwin
      ];
      specialArgs = {inherit inputs self primaryUser;};
    };
  };
}
