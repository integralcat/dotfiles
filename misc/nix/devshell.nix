{
  description = "Python dev flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    pyPkgs = pkgs.python311Packages;
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.python311
        pyPkgs.numpy
        pyPkgs.requests
      ];
    };
  };
}
