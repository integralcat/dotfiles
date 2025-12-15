
{
  description = "Hello package flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.writeShellScriptBin "hello" ''
      echo "Hello from Nix"
    '';
  };
}
