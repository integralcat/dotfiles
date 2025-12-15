# Multi System flake

```haskell
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f system (import nixpkgs { inherit system; }));
    in {
      devShells = forAllSystems (system: pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [ python312 git ];
        };
      });
    };
}
```


