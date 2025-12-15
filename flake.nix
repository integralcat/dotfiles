{
  description = "Gourav dotfiles + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.gourav =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
  };
}
